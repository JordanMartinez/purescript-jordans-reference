# OptParse

This file overviews the syntax and API of `purescript-optparse`.

**Note:** the OptParse-based projects will need to use `node` to run the JavaScript program because `spago run -- arg1` passes `arg1` to the `purs compile` command, not the actual program being run.

To run the examples, use
```bash
# Build the Syntax file
spago bundle-app -m Learn.OptParse -t dist/libraries/optparse/learnOptParse.js

# Run the program without required arguments to see the help text
node dist/libraries/optparse/learnOptParse.js

# Run the program with required arguments to see the program's output
node dist/libraries/optparse/learnOptParse.js --long-name3 example --switch



# Build the 'GetRootDirViaAbsolutePath' file
spago bundle-app -m Learn.OptParse.GetRootDirViaAbsolutePath -t dist/libraries/optparse/getRootViaAbsPath.js

# Run the program
node dist/libraries/optparse/getRootViaAbsPath.js --rootDir <your absolute root dir argument here>



# Build the 'GetRootDirViaEitherPath' file
spago bundle-app -m Learn.OptParse.GetRootDirViaEitherPath -t dist/libraries/optparse/getRootViaEitherPath.js

# Run the program using an absolute path
node dist/libraries/optparse/getRootViaEitherPath.js --rootDir <your absolute dir argument here>

# Run the program using a relative path
node dist/libraries/optparse/getRootViaEitherPath.js -r --rootDir .
```
