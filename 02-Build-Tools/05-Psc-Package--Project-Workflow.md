# Psc-Package: From Start to Finish

The below example uses `psc-package` as its dependency manager. It assumes that one is installing packages only from the default package set maintained by Justin Woo [here](https://github.com/purescript/package-sets), and not from their own custom package set.

## Create the project

One of two ways
```bash
# 1) Via pulp
#
# This gets the default package set based on
# the system's installed PureScript compiler version (purs)
# which usually does not include as many packages as
# the latest package set. Thus, this approach is not recommended.
pulp --psc-package init projectName

# 2a) Via psc-package
#
# This lets you specify which package set to use
# which should be the latest version of the
# default package set. This is the recommended approach.
# (See the latest release here):
#    https://github.com/purescript/package-sets/releases
psc-package init --set psc-0.12.3-20190227 --source https://github.com/purescript/package-sets.git

# 2b) Open the below file and change the 'name' field to your project's name.
#
# The resulting psc-package.json file from Option 2 will have `untitled`
# in its 'name' field since it doesn't know what your project's name is.
nano psc-package.json
```
## Install dependencies

One of two ways
```bash
# To see which packages are already installed...
psc-package dependencies

# To see which packages are available in your package set...
psc-package available

# 1) Via psc-package install
psc-package install package # remember to omit the 'purescript-' prefix

# Note: only one package can be installed at a time using this approach
psc-package install onlyOnePackage
psc-package install onlyOnePackage
psc-package install onlyOnePackage

# 2) Via manual file modification and the below command:
#   a) Open `psc-package.json`, add dependencies in `deps`, save file
#
#   b) Then run this command to make psc-package aware of them.
psc-package install
```

### Write the Code

```bash
# Open the REPL to play with a few ideas or run simple tests
psc-package repl        # via psc-package
pulp --psc-package repl # via pulp

# Build the docs
pulp --psc-package docs -- --format html

# Automatically re-build project whenever a source file is changed/saved
pulp --watch --before 'clear' --psc-package build

# Automatically re-test project whenever a source/test file is changed/saved
pulp --watch --before 'clear' --psc-package test
```

### Build the Code

```purescript
# Run the program
pulp --psc-package run -- arg1PassedToProgram arg2PassedToProgram

# Build a node-backend version
pulp --psc-package build --to dist/fileName.js

# Build a web-backend version
pulp --psc-package browserify --to dist/fileName.js
```
