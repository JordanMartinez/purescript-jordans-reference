# The REPL

REPL stands for Read, Evaluate, Print, Loop.

## Starting the REPL

Use `spago repl`. The REPL should print something like the following:
```
$ spago repl
PSCi, version 0.13.8
Type :? for help

import Prelude

> |
```
Let's walk through each part:
- `PSCi` means "PureScript Compiler interactive". It's similar to GHCi, the Haskell language's REPL.
- `version` prints the PureScript version you are using.
- `:?` indicates how to print a list of commands with their description. These are described below in this file.

After this, you may see zero or more `import <ModuleName>` lines. Spago will read the `.purs-repl` file to get this list and import the modules automatically. The `.purs-repl` file is covered at the end of this file.

Note: if you do not see `import Prelude` appear above, expressions like `5 + 5` will produce an error. To fix that, you should import the Prelude module by typing `import Prelude` followed by pressing Enter.

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

| The Error                                                      | Its Meaning                                                                                                                                                                                                                      | What to do                                                                                                               |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| "No type class instance was found for `Data.Show.Show [Type]`" | An expression cannot be turned into a `String`. For example, a function's implementation (`(\x -> x + 1)`) cannot be turned into a `String` whereas a value (`5`) or expression (`10 + 10`) can be (`5` and `20`, respectively). | If it's possible for you to define one, define an instance of the `Show` type class. If not, then ignore it and move on. |
| "Multiple value declarations exist for [binding]."             | You defined the binding twice, which you cannot do                                                                                                                                                                               | See [the Reload command section](#reload) for what your options are                                                      |
| "Unknown operator (+)"                                         | The `+` function was not imported because the `Prelude` module was imported                                                                                                                                                      | Import the Prelude module by typing `import Prelude` followed by pressing Enter.                                         |

## A Quick Overview of Some of the REPL Commands

The REPL offers a few commands. You can see the entire list by typing either `:help` or `:?` and pressing Enter.

These commands are listed in the same order as what the `:?` outputs.

Note: the commands can be shortened to their first unique letters. So, rather than entering `:type`, one can enter `:t`. Likewise, rather than entering `:paste` or `:print`, one can enter `:pa` or `:pr`, respectively.

### Help

Displays the REPL commands via `:help`/`:?`.

### Quit

Exits the REPL, returning control to your shell.

### Reload

#### The Problem

You can only define a binding once. Defining it again with a different expression will output an error
```haskell
x = 5 -- first time
x = 6 -- second time raises error
-- REPL's outputs error: "Multiple value declarations exist for x."
```
You need to clear the `x` binding name to be able to reuse it for other bindings.

For example, let's say you wrote two functions and the second uses the first. However, you wrote the wrong implementation for the second and need to rewrite it:
```haskell
add1 = (\x -> x + 1)
times2 = (\x -> x * 3) -- "3" should be "2"
```

#### The Solutions

Ideally, you could just clear the second function's binding and rewrite it. Unfortunately, you cannot do that. You can either:
1. use the `:reload` command to clear out both functions' bindings, redefine the first one, and then define the second one with the correct implementation
2. define a new binding for the correct implementation:

```haskell
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

3. define your code in a file (as a module) and import that module into your REPL session. Any edits made to this file are picked-up upon a REPL reload.

Create a file containing your REPL script:
```haskell
-- MyModule.file
module MyModule where

import Prelude

add1 = (\x -> x + 1)
times2 = (\x -> x * 3) -- This typo will be fixed later
```

Load script into the REPL:
```
> import MyModule
> times2 4
12
```

Make any edits to this file. For example, change to `times2 = (\x -> x * 2)`. Save file, then reload in existing REPL session. The `MyModule` import will be remembered.
```
> :reload
> times2 4
8
```

### Clear

Use `:cl` rather than `:c` to distinguish between this command and `:complete`. This works the same as `:reload` except that all imported modules are also removed. If you do this, you will need to reimport any modules you wish to use. For example, you will likely need to reimport Prelude (`import Prelude`), so that you can use number operations (i.e. `+`, `-`, `/`, `*`) and the `==` function again.

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
Type
> :kind Array
Type -> Type
```

### Show

There are two commands in this one:
- `show loaded`/`:s loaded` - Shows all modules that the REPL session knows about. Some may or may not have been imported. (Before the REPL session starts, the PureScript compiler will compile all PureScript files based on the source globs given to it. All modules in those globs are then known to the REPL session, but you might not want to use them all in a given session.)
- `show import`/`:s import` - Shows which modules you currently have imported into the REPL session

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

The REPL already supports tab-completion. So, this command isn't meant to be used by humans. Rather, it's for tools that need a way to get tab-completion. For context, see [Harry's comment](https://github.com/purescript/purescript/issues/3746#issuecomment-550512591).

## The `.purs-repl` File

If you ever want to automatically import a list of modules, modify the `.purs-repl` file. By default, it will only display the following content:
```
import Prelude
```
You can add more modules there so you don't have to type them in later:
```
import Prelude
import Data.Maybe
import Data.Either
```

Unfortunately, defining variables in the file will not automatically create them before the REPL starts. Let's say you update `.purs-repl` to the below content
```
import Prelude

x = 5
```
When you run `spago repl`, it will produce the following error:
```
$ spago repl
PSCi, version 0.13.8
Type :? for help

Unexpected or mismatched indentation at line 3, column 1
```

## Other Gotchas

- `do notation` (covered later) is not supported in the REPL
- The REPL works by converting the PureScript code into a new program and running it on Node each time. Thus, using a monad like `Effect` and `let x = unsafePerformEffect (randomInt 1 10)` will not store a random number in the variable `x` that stays the same after that point. Rather, `x` will have a new number each time one inputs a new expression and runs it by pressing ENTER.
