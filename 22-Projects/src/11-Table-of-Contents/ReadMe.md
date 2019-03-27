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
- Parallel - TODO

## Compilation Instructions

Run the following while in the `Projects/` folder.

Currently, only the ReaderT implementation exists and there are no tests or benchmarks.

### Standard

```bash
# Build the program
spago bundle --main Projects.ToC.Main --to dist/table-of-contents/ghtoc.js

# Change directory to be at the root directory
cd ../

# Then run it using these commands:
node 22-Projects/dist/table-of-contents/ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"
```
