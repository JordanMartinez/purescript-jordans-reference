# Table of Contents

In this folder, we will build a program that can recursively parse this project's files and automatically create a Table of Contents file.

## Libraries Used

`Total Number: 2`

Be familiar with the contents of the below folders in the `Libraries` folder before reading this folder's content:
- Optplicative
- Node-FS
- Tree
- String-Parsers
- HTTP

## Compilation Instructions

Run the following while in the `Projects/` folder.

Currently, there are no benchmarks. Tests are a WIP.

```bash
# Build the program using either the ReaderT or Run implementation
spago bundle-app --main ToC.ReaderT.Main --to dist/readert-ghtoc.js

spago bundle-app --main ToC.Run.Main --to dist/run-ghtoc.js

# Change directory to be at the root directory
cd ../

# Then run it using one of the below commands
# To actually check whether the hyperlinks work, remove the
# '--skip-url-verification' flag:
node 22-Projects/11-ToC-Generator/dist/readert-ghtoc.js -r . -o ./table-of-contents.md --log-level info --skip-url-verification

node 22-Projects/11-ToC-Generator/dist/run-ghtoc.js -r . -o ./table-of-contents.md --log-level info --skip-url-verification
```

To test the code in both approaches, run this code:
```haskell
spago test -m Test.ToC.MainLogic.QuickCheckTest
```
