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

### Standard

```bash
# Build the program
pulp --psc-package build -m Projects.ToC.Main --to dist/table-of-contents/ghtoc.js

# Change directory to be at the root directory
cd ../

# Then run it using these commands:
node 22-Projects/dist/table-of-contents/ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"
```
