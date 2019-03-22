# Table of Contents

In this folder, we will build a program that can recursively parse this project's files and automatically create a Table of Contents file.

The libraries we will cover here are:
- `purescript-yargs` - bindings to a JavaScript command line parser library
- `purescript-node-fs-aff` - bindings to Node's file system API
- `purescript-tree` - A Rose Tree
- `purescript-string-parsers` - Parser library when content is known to be a `String`.
- `purescript-node-http` - bindings to Node's http API
- `purescript-parallel` - TODO - execute parallel computations

## Compilation Instructions

Run the following while in the `Projects/` folder.

The Yargs-based projects will need to use `node` to run the JavaScript program because `spago run -- arg1` passes `arg1` to the `purs compile` command, not the actual program being run.

### Pre-reqs

```bash
# Learn Yargs files
# Shows what happens when not all required arguments are provided
spago bundle -m Learn.Yargs -t dist/table-of-contents/learnYargs.js
node dist/table-of-contents/learnYargs.js
# Shows what actual 'program' using values looks like
spago bundle -m Learn.Yargs -t dist/table-of-contents/learnYargs.js
node dist/table-of-contents/learnYargs.js -c "test" -d "test"

spago bundle -m Learn.Yargs.GetRootDirViaAbsolutePath -t dist/table-of-contents/getRootViaAbsPath.js
node dist/table-of-contents/getRootViaAbsPath.js --rootDir <your absolute root dir argument here>

spago bundle -m Learn.Yargs.GetRootDirViaEitherPath -t dist/table-of-contents/getRootViaEitherPath.js --rootDir <your absolute root dir argument here>
# use absolute path
node dist/table-of-contents/getRootViaEitherPath.js --rootDir <your absolute dir argument here>
# use relative path
node dist/table-of-contents/getRootViaEitherPath.js -r --rootDir "."

spago run -m Learn.NodeFS.Syntax

spago run -m Learn.NodeFS.PrintAllFiles
# To run the above with your own argument, use this instead:
spago bundle -m Learn.NodeFS.PrintAllFiles -t dist/table-of-contents/printAllFiles.js
node dist/table-of-contents/printAllFiles.js --rootDir <your relative/absolute directory path argument here>

# All others
spago run -m Learn.Tree.Syntax

spago run -m Learn.StringParsers.Syntax

spago run -m Learn.Http.Syntax
```

### Standard

```bash
# Build the program
spago bundle --main Projects.ToC.Main --to dist/table-of-contents/ghtoc.js

# Change directory to be at the root directory
cd ../

# Then run it using these commands:
node 22-Projects/dist/table-of-contents/ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"
```
