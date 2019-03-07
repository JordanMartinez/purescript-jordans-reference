# Bower: From Start to Finish

**Warning:** This code hasn't been checked. Most of it should be correct, but some parts might be wrong.

## Create the project

One of two ways
```bash
bower init
pulp init
```

## Bower: Addressing Common Problems

### The Solution to Most Bower Problems

At various times, you might encounter a problem with Bower due to its cache mechanism. When in doubt, run the following command and see if that fixes your issue:
```bash
# Deletes the 'bower_components' and 'output' directories,
# ensuring that the cache mechanism is not corrupting your build
# and that the next build will be completely fresh.
rm -rf bower_components/ output/
```

### A Note on Breaking Compiler Changes

The following issue is happening less and less frequently due to the PureScript language stabilizing, but it still needs to be stated.

#### Annoyance Defined

If a compiler release that includes breaking changes was released recently, it will take some time for libraries in the ecosystem to become compatible with that release. If you are using Bower as your dependency manager, it may try to install libraries that are and are not compatible with the new release, creating problems.

#### Recommended Guidelines

In such circumstances, follow these guidelines to help find the correct version of a library:
- Go to Pursuit and look at the library's package page. Choose one of the library's versions and compare that version's publish date with the date of the compiler release. Those that occur after the compiler release are likely compatible with the new release.
- Since `purescript-prelude` is a dependency for most libraries, see which version of `purescript-prelude` the library uses. That should indicate whether it's compatible with a new compiler release or not.
- If all else fails, check the library's last few commit messages in its repository for any messages about updating to the new compiler release.

## Install dependencies

```bash
# Need to install NPM packages and initialize them
npm install npm-package1 npm-package2
npm init
bower install package1 package2 --save
```

### Write the Code

```bash
# Open the REPL to play with a few ideas or run simple tests
pulp repl

# Automatically re-build project whenever a source file is changed/saved
pulp --watch --before 'clear' build

# Automatically re-test project whenever a source/test file is changed/saved
pulp --watch --before 'clear' test

# Build a developer version
pulp browserify --to dist/fileName.js # if program
pulp browserify --no-main-check --to dist/fileName.js # if library

# Run the program
pulp run -- arg1PassedToProgram arg2PassedToProgram
```
### Publish the Package for the First Time

See this [help page for authors](https://pursuit.purescript.org/help/authors) on Pursuit. Its instructions are more authoritative than what follows.

```bash
# Build the docs
pulp docs -- --format html
# Then read over them to insure there aren't any formatting issues or typos

# Make a production build via Browserify
#   If building a program...
pulp browserify --optimise --to dist/fileName.js
#   If building a library
pulp browserify --no-main-check --optimise --to dist/fileName.js

# Set the initial version
pulp version v0.1.0

# Publish the version
pulp publish
```

### Publish a New Version of an Already-Published Package

```bash
# Build and check the docs
pulp docs -- --format html

# Make a production build
#   If building a program...
pulp browserify --optimise --to dist/fileName.js
#   If building a library
pulp browserify --no-main-check --optimise --to dist/fileName.js

# bump project version
pulp version major
pulp version minor
pulp version patch
# or specify a version
pulp version v1.5.0

# publish it
pulp publish
```
