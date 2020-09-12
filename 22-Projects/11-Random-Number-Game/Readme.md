# Random Number

This folder will show how to build a "guess the random number" game. It's main purpose is to explore the various ways one can structure an application, including a few experimental ones.

## Libraries Used

`Total Number: 2`

Be familiar with the contents of the below folders in the `Libraries` folder before reading this folder's content:
- ReadLine and Aff
- Halogen

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The below `parcel` commands are rather verbose because of how this folder is structured. See the overview of the first instance of the command in the below compilation instructions.

The games can be opened and played via `dist/example.html`.

```bash
# == Node-Based implementation ==
spago run -m RandomNumber.ReaderT.Standard.Main.Console

# == Browser-based implementation ==
spago bundle-app --main RandomNumber.ReaderT.Standard.Main.Halogen --to dist/app.js
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
parcel dist/random-number/readerT--standard/example.html --open -p 1111 -d dist/ -o index.html

# == Test ==
spago test -m Test.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.RandomNumber.ReaderT.Standard.SameMonad
```
