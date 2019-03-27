# Yargs

This file overviews the syntax and API of `purescript-yargs`.

**Note:** the Yargs-based projects will need to use `node` to run the JavaScript program because `spago run -- arg1` passes `arg1` to the `purs compile` command, not the actual program being run.

To run the examples, use
```bash
# Learn Yargs files
# Shows what happens when not all required arguments are provided
spago bundle -m Learn.Yargs -t dist/libraries/yargs/learnYargs.js
node dist/libraries/yargs/learnYargs.js

# Shows what actual 'program' using values looks like
spago bundle -m Learn.Yargs -t dist/libraries/yargs/learnYargs.js
node dist/libraries/yargs/learnYargs.js -c "test" -d "test"

spago bundle -m Learn.Yargs.GetRootDirViaAbsolutePath -t dist/libraries/yargs/getRootViaAbsPath.js
node dist/libraries/yargs/getRootViaAbsPath.js --rootDir <your absolute root dir argument here>

# Shows what actual 'program' using values looks like
spago bundle -m Learn.Yargs.GetRootDirViaEitherPath -t dist/libraries/yargs/getRootViaEitherPath.js --rootDir <your absolute root dir argument here>
# use absolute path
node dist/libraries/yargs/getRootViaEitherPath.js --rootDir <your absolute dir argument here>
# use relative path
node dist/libraries/yargs/getRootViaEitherPath.js -r --rootDir "."
```
