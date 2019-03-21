# Random Number

This folder will show how to build a "guess the random number" game. Here's an overview of its contents:
- Design process and properties we wish to employ
- Shared Code: the domain types, data structures, and their related functions that are used across all the other folders. This folder excludes any infrastructure/framework code (e.g. `Node.ReadLine`/`Halogen`).
- Folders for each application structure

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The below `parcel` commands are rather verbose because of how this folder is structured. See the overview of the first instance of the command in the below compilation instructions.

The games can be opened and played via `dist/random-number/<FP structure approach>/index.html`.

### Standard

```bash
## Node-Based implementation
spago run -m Games.RandomNumber.ReaderT.Standard.Infrastructure.Console
spago run -m Games.RandomNumber.Free.Standard.Infrastructure.Console
spago run -m Games.RandomNumber.Run.Standard.Infrastructure.Console

## Browser-based implementation
spago bundle --main Games.RandomNumber.ReaderT.Standard.Infrastructure.Halogen.Web --to dist/random-number/readerT--standard/app.js
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
parcel dist/random-number/readerT--standard/example.html --open -p 1111 -d dist/random-number/readerT--standard/ -o index.html

spago bundle --main Games.RandomNumber.Free.Standard.Infrastructure.Halogen.Web --to dist/random-number/free--standard/app.js
parcel build dist/random-number/free--standard/example.html --open -p 1112 -d dist/random-number/free--standard/ -o index.html

spago bundle --main Games.RandomNumber.Run.Standard.Infrastructure.Halogen.Web --to dist/random-number/run--standard/app.js
parcel build dist/random-number/run--standard/example.html --open -p 1113 -d dist/random-number/run--standard/ -o index.html

## Test
spago test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
spago test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
spago test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```

### Layered

```bash
## Node-Based implementation
spago run -m Games.RandomNumber.Free.Layered.Infrastructure.Console
spago run -m Games.RandomNumber.Run.Layered.Infrastructure.Console

### Changes in Run folder
spago run -m Games.RandomNumber.Run.Layered.ChangeImplementation
spago run -m Games.RandomNumber.Run.Layered.AddDomainTerm

## Browser-based implementation
spago build --main Games.RandomNumber.Free.Layered.Infrastructure.Halogen.Web --to dist/random-number/free--layered/app.js
parcel build dist/random-number/free--layered/example.html --open -p 1114 -d dist/random-number/free--layered/ -o index.html

spago build --main Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web --to dist/random-number/run--layered/app.js
parcel build dist/random-number/run--layered/example.html --open -p 1115 -d dist/random-number/run--layered/ -o index.html

## Test
spago test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```
