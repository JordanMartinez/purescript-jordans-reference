# Spago: From Start to Finish

The below example uses `spago` as the build tool and dependency manager.

## Create the project

```bash
# 1. Sets up the initial files and structure of the project
spago init
```

If you need to override/add packages to the standard package set, proceed to `Configure the Package Set`. Otherwise, continue to `Install Dependencies`

### Configure the Package Set

```bash
# 2a) Open the below file, read its top-level comment,
#       and follow its instructions to override/add packages
nano packages.dhall

# 2b) When finished, either verify that a single patched/added package
#       works with the rest of the set...
spago verify singlePackageName
#       or re-verify the entire package set
spago verify-set
```

### Freeze the Package Set

Note: Spago does this automatically now. So, one likely does not need to do this anymore. It is provided for context / historical purposes.
```bash
# 3) Freeze the package set to prevent security issues.
#     For a deeper explanation on what happens here,
#     see Dhall's safety guarantees wiki page:
#     https://github.com/dhall-lang/dhall-lang/wiki/Safety-guarantees
spago freeze
```

## Install Dependencies

One of two ways
```bash
# Install a package from the package set to your project
spago install packageName1 packageName2 # ...
```

## Write the Code

```bash
# Open the REPL to play with a few ideas or run simple tests
spago repl

# Build the docs
spago docs --open

# Automatically re-build project whenever a source/test file is changed/saved
# and clear the screen before rebuilding
spago build --watch --clear-screen
```

## Build the Code

```bash
# Install all dependencies (if not done so already) and
# compile the code
spago build

# Build a developer-level executable file
spago bundle-app --main Module.Path.To.Main --to dist/index.js
node dist/index.js

# Build a production-level Node-backend file via Parcel
spago bundle-app --main Module.Path.To.Main --to dist/bundle-output.js
parcel build dist/bundle-output.js --target "node" -o app.js
```

To build a production-level browser-backend file...
```bash
# Build a production-level browser-backend file
spago bundle-app --main Module.Path.To.Main --to dist/app.js
```
Create an HTML file (dist/example.html) that references the 'app.js' file
```html
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <!-- Insert your title here -->
    <title>Some Title</title>
  </head>
  <body>
    <!-- Reference the outputted bundle here -->
    <script src="/app.js" charset="utf-8"></script>
  </body>
</html>
```
Then use parcel to do minification and open the resulting web page
```bash
parcel build dist/example.html --target "browser" -o index.html --open
# it'll create a few files in the `dist/` folder and open the resulting
# "dist/index.html" file via your default web browser
```
