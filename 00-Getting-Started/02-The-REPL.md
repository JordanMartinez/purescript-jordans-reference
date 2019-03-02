# The REPL

REPL stands for Read, Evaluate, Print, Loop.

## Preparing a Folder for the REPL

In order to start the REPL, there are three requirements:
- a `psc-package.json` file exists in the current folder or one of its parents.
- the `psci-support` package has been installed (it appears in the the `psc-package.json` file's `depends` field).
- a `.purs-repl` file exists in the current folder or one of its parents. (Not an actual requirement for starting the REPL, but prevents issues a newcomer will otherwise encounter if they don't know anything about Purescript / FP languages.)

Follow these instructions to create a new `psc-package.json` file:
```bash
# 1. Make a new directory
mkdir playground
# 2. Enter it
cd playground

# Note: the following commands will be explained more in the
#   "Build-Tools" folder

# 3. Create a new psc-package.json file using psc-package
psc-package init --set psc-0.12.3-20190227 --source https://github.com/purescript/package-sets.git

# 4. Install the psci-support package using this command:
psc-package install psci-support

# 5. Create the `.purs-repl` file that
# imports `Prelude` when the REPL starts:
echo "import Prelude" > .purs-repl
```
You should now have a folder structure like the following:
```
playground\
  .psc-package\
  .psci-modules\
  .purs-repl
  psc-package.json
```

## Starting the REPL

Once the above three requirements have been met, you can start the REPL using one of two commands:
- `psc-package repl`
- `pulp repl` (this project will use this command)

## Using the REPL

In general, there are five things you can do in the REPL:

1. See the result of an expression by typing it into the REPL (e.g. `3 + 3`) and hitting `Enter`.
2. Define a binding to some variable or function using the `binding = <expression>` syntax. For example...
    - `x = 3`
    - `function = (\x -> x + 1)`
3. Input multi-line expressions using the `:paste` command (followed by `CTRL+D`)
4. Use other commands to explore a module's functions, types, and kinds
5. Use other commands to interact with the REPL's current state (e.g. clearing out bindings and/or imported modules, showing which modules have been imported, etc.)

## Possible Outputted REPL Errors

Sometimes, the REPL will output errors. These errors may not be immediately understandable for new learners, so the table below will help you understand them and know what to do.

| The Error | Its Meaning | What to do |
| - | - | - |
| "No type class instance was found for `Data.Show.Show [Type]`" | An expression cannot be turned into a `String`. For example, a function's implementation (`(\x -> x + 1)`) cannot be turned into a `String` whereas a value (`5`) or expression (`10 + 10`) can be (`5` and `20`, respectively). | If it's possible for you to define one, define an instance of the `Show` type class. If not, then ignore it and move on.
| "Multiple value declarations exist for [binding]." | You defined the binding twice, which you cannot do | See [the Reload command section](#reload) for what your options are |

## A Quick Overview of Some of the REPL Commands

The REPL offers a few commands. You can see the entire list by typing either `:help` or `:?` and pressing Enter.

These commands are listed in the same order as what the `:?` outputs.

Note: the commands can be shortened to their first letter. So, rather than entering `:paste` or `:type`, one can enter `:p` or `:t`

### Help

Displays the REPL commands via `:help`/`:?`.

### Quit

Exits the REPL, returning control to your shell.

### Reload

You can only define a binding once. Defining it again with a different expression will output an error
```purescript
x = 5 -- first time
x = 6 -- second time raises error
-- REPL's outputs error: "Multiple value declarations exist for x."
```
You need to clear the `x` binding name to be able to reuse it for other bindings.

For example, let's say you wrote two functions and the second uses the first. However, you wrote the wrong implementation for the second and need to rewrite it:
```purescript
add1 = (\x -> x + 1)
times2 = (\x -> x * 3) -- "3" should be "2"
```

Ideally, you could just clear the second function's binding and rewrite it. Unfortunately, you cannot do that. You can either:
1. use the `:reload` command to clear out both functions' bindings, redefine the first one, and then define the second one with the correct implementation
2. define a new binding for the correct implementation:
```purescript
-- 1st option
add1 = (\x -> x + 1)
times2 = (\x -> x * 3) -- Whoops! "3" should be "2"
:reload
add1 = (\x -> x + 1) -- define the "add1" binding again
times2 = (\x -> x * 2) -- define "times2" again but with correct implmentation.

-- 2nd option
add1 = (\x -> x + 1)
times2 = (\x -> x * 3) -- Whoops! "3" should be "2"
times2_fix = (\x -> x * 2) -- define new function with correct implementation
```

### Clear

The same as `:reload` except that all imported modules are also removed. If you do this, you will need to reimport any modules you wish to use. For example, you will likely need to reimport Prelude (`import Prelude`), so that you can use number operations (i.e. `+`, `-`, `/`, `*`) and the `==` function again.

### Browse

See all the functions, types, and type classes that a module exports and which you can use

### Type

This displays the type signature of a value, a function or a type-class. One should be able to determine what the body of the function does based on the type signature, so that body is not shown:
```
> :type x + 1
Int
> :type (\x -> x + 1)
Int -> Int
```

### Kind

Displays the kind of a type. Kinds will be explained more in the Syntax folder:
```
> :kind Int
Type
> :kind (Int -> Int)
Type -> Type
```

### Show

There are two commands in this one:
- `show loaded`/`:s loaded` - Shows all modules which you can import into the REPL.
- `show import`/`:s imported` - Shows which modules you currently have imported in the REPL

### Print

Changes how a value is printed to the console after an expression is evaluated. By default, it uses [`PSCI.Support.eval`](https://github.com/purescript/purescript-psci-support/blob/master/src/PSCI/Support.purs).

New learners can ignore this command for now. Those who are familiar with the language can change it to a different one by calling `:print Path.To.Module.functionName`.

Regardless, to reset it to the default, one can call `:print PSCI.Support.eval`.

### Paste

The REPL only accepts single-line Purescript code. If anything requires you to write multi-line expressions, you must use the `:paste` command.

The workflow goes something like this:
1. Type in the paste command: `:paste`
2. Do one of the following
    - input multi-line expressions (e.g. a type class and its function, a data type and its values, a function's type signature and its implementation, etc.).
    - paste some external code into the REPL
3. Type `CTRL+D`/`CMD+D` to indicate that you are finished.

The REPL will then parse and all of the code, enabling you to use it from that point forward.

### Complete

The REPL does not currently support tab-completion. This command shows the options one might use.

For example, one could type `:complete a`/`:c a` to show what are all of the usuable functions that start with `a`.
