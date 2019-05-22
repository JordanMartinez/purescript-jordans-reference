# Node FS

This file overviews the syntax to use for `purescript-fs-aff`.

It uses `Yargs` in one file so check that out before looking at this one.

To run the examples, use
```bash
spago run -m Learn.NodeFS.Syntax

spago run -m Learn.NodeFS.PrintAllFiles
# To run the above with your own argument, use this instead:
spago bundle-app -m Learn.NodeFS.PrintAllFiles -t dist/libraries/node-fs/printAllFiles.js
node dist/libraries/node-fs/printAllFiles.js --rootDir <your relative/absolute directory path argument here>
```
