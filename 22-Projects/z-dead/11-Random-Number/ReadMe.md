# Random Number Game

This folder contains the code that became 'dead' after the API change smade in the Halogen v5 release.

What follows is the instructions that were relevant to the dead code before it became "dead."

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The below `parcel` commands are rather verbose because of how this folder is structured. See the overview of the first instance of the command in the below compilation instructions.

The games can be opened and played via `dist/random-number/<FP structure approach>/index.html`.

### Standard

```bash
# == Node-Based implementation ==
spago run -m RandomNumber.Free.Standard.Main.Console
spago run -m RandomNumber.Run.Standard.Main.Console

# == Browser-based implementation ==
spago bundle-app --main RandomNumber.Free.Standard.Main.Halogen --to dist/random-number/free--standard/app.js
# Read the below as:
# "Use 'example.html' to figure out the dependency tree, which will pick up
# our 'app.js' bundle from Spago. Parcel will output a minified version
# of the `app.js` bundle to the path:
# 'dist/random-number/readert--standard/app.someHash.js'.
# Then, the `example.html` file will be copied to `index.html` and the `app.js`
# reference will be changed to the parcel-ed `app.someHash.js` reference.
#
# Since we have the '--open' flag enabled and specify the port to `1111,`
# your web browser will open 'localhost:1111', which automatically serves the
# 'index.html' file that parcel outputted.
#
# From here, you can modify your code, re-bundle with spago, and Parcel
# will hotload the changes."
parcel build dist/random-number/free--standard/example.html --open -p 1112 -d dist/random-number/free--standard/ -o index.html

spago bundle-app --main RandomNumber.Run.Standard.Main.Halogen --to dist/random-number/run--standard/app.js
parcel build dist/random-number/run--standard/example.html --open -p 1113 -d dist/random-number/run--standard/ -o index.html

# == Test ==
spago test -m Test.RandomNumber.Run.Standard
```

### Layered

```bash
# == Node-Based implementation ==
spago run -m RandomNumber.Free.Layered.Main.Console
spago run -m RandomNumber.Run.Layered.Main.Console

# === Changes in Run folder: Node-based ===
spago run -m RandomNumber.Run.Layered.ChangeImplementation
spago run -m RandomNumber.Run.Layered.AddDomainTerm

# === Changes in Run folder: Browser-based ===
spago build --main RandomNumber.Free.Layered.Main.Halogen --to dist/random-number/free--layered/app.js
parcel build dist/random-number/free--layered/example.html --open -p 1114 -d dist/random-number/free--layered/ -o index.html

spago build --main RandomNumber.Run.Layered.Main.Halogen --to dist/random-number/run--layered/app.js
parcel build dist/random-number/run--layered/example.html --open -p 1115 -d dist/random-number/run--layered/ -o index.html

# == Test ==
spago test -m Test.RandomNumber.Run.Layered
```
