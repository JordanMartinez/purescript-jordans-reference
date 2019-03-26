# Bower: From Start to Finish

**Warning:** This code hasn't been checked. Most of it should be correct, but some parts might be wrong.

## Create the project

One of two ways
```bash
pulp init
```

## Install dependencies

```bash
# Need to install NPM packages and initialize them
npm install npm-package1 npm-package2
npm install
bower install package1 package2 --save
bower install
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

# Run the program and pass args to the underlying program
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
