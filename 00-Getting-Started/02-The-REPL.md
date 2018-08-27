# The REPL

REPL stands for Read, Evaluate, Print, Loop.

## Preparing a Folder for the REPL

In order to start the REPL, there are three requirements:
- a `psc-package.json` file exists in the current folder or one of its parents.
- the `psci-support` package has been installed (it appears in the the `psc-package.json` file's `depends` field).
- a `.purs-repl` file exists in the current folder or one of its parents. (Not an actual requirement for starting the REPL, but prevents issues a newcomer will otherwise encounter if they don't know anything about Purescript / FP languages.)

Follow these instructions to create a new `psc-package.json` file:
```bash
# Make a new directory
mkdir playground
# enter it
cd playground

# Note: the following commands will be explained more in the
#   "Build-Tools" folder

# Create a new psc-package.json file using psc-package
psc-package init --set psc-0.12.0-20180819 --source https://github.com/purescript/package-sets.git
```
Install the psci-support package using this command: `psc-package install psci-support`

Create the `.purs-repl` file that imports Prelude when the REPL starts:
`echo "import Prelude" > .purs-repl`

You should now have a folder structure like the following:
```
playground\
  .psc-package\
  .psci-modules\
  .purs-repl
  psc-package.json
```

## Starting the REPL

Once the above three requirements have been met, you can start the REPL using one of two commands. Use the one that's easiest to remember:
- `psc-package repl`
- `pulp repl`

Once the REPL starts, type `:?` to see the list of commands
