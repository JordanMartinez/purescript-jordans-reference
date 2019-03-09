# Spago: From Start to Finish

The below example uses `spago` as the build tool and dependency manager.

## Create the project

```bash
# 1. Sets up the initial files and structure of the project
spago init
```

If you need to override/add packages to the standard package set, proceed to `Configure the Package Set`. Otherwise, continue to `Freeze the Package Set`

### Configure the Packaget Set

```bash
# 2a) Open the below file, read its top-level comment,
#       and follow its instructions to override/add packages
nano packages.dhall

# 2b) When finished, either verify that a single patched/added package
#       works with the rest of the set...
spago verify singlePackageName
#       or re-verify the packaget set
spago verify-set
```

## Freeze the Package Set

```bash
# 3) Freeze the package set to prevent security issues.
#     For a deeper explanation on what happens here,
#     see Dhall's safety guarantees wiki page:
#     https://github.com/dhall-lang/dhall-lang/wiki/Safety-guarantees
spago freeze
```

## Install dependencies

One of two ways
```bash
# Install a package from the package set to your project
spago install packageName1 packageName2 # ...
```

### Write the Code

```bash
# Open the REPL to play with a few ideas or run simple tests
spago repl        # via psc-package

# Build the docs
# Note: no corresponding command for this yet, but it's a WIP.
# See: https://github.com/spacchetti/spago/issues/89

# Automatically re-build project whenever a source/test file is changed/saved
# No corresponding command for this yet.
# See: https://github.com/spacchetti/spago/issues/65
```

### Build the Code

```bash
# Install all dependencies (if not done so already) and
# compile the code
spago build

# Build a developer-level executable file (excludes "dead-code elimination")
spago bundle --main Module.Path.To.Main --to dist/index.js
node dist/index.js

# Build a production-level Node-backend file (includes "dead-code elimination")
# via Parcel
spago make-module --main Module.Path.To.Main --to dist/make-module-output.js
parcel build -t "node" -o dist/node-executable-file.js dist/make-module-output.js

# Build a production-level browser-backend file (includes "dead-code elimination")
# via Parcel
spago make-module --main Module.Path.To.Main --to dist/make-module-output.js
parcel build -t "browser" -o dist/browser-file.js dist/make-module-output.js
```
