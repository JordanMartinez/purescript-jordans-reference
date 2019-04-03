# Table of Contents

In this folder, we will build a program that can recursively parse this project's files and automatically create a Table of Contents file.

## Libraries Used

`Total Number: 2`

Be familiar with the contents of the below folders in the `Libraries` folder before reading this folder's content:
- Yargs
- Node-FS
- Tree
- String-Parsers
- HTTP

## Compilation Instructions

Run the following while in the `Projects/` folder.

Currently, only there are no tests or benchmarks.

### Standard

```bash
# Build the program using either the ReaderT or Run implementation
spago bundle --main ToC.ReaderT.Main --to dist/table-of-contents/readert-ghtoc.js

spago bundle --main ToC.Run.Main --to dist/table-of-contents/run-ghtoc.js

# Change directory to be at the root directory
cd ../

# Then run it using one of commands:
node 22-Projects/dist/table-of-contents/readert-ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"

node 22-Projects/dist/table-of-contents/run-ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"
```
