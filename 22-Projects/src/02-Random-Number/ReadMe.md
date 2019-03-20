# Random Number

This folder will show how to build a "guess the random number" game. Here's an overview of its contents:
- Design process and properties we wish to employ
- Shared Code: the domain types, data structures, and their related functions that are used across all the other folders. This folder excludes any infrastructure/framework code (e.g. `Node.ReadLine`/`Halogen`).
- Folders for each application structure

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The games can be opened and played via `dist/random-number/<FP structure approach>/index.html`.

### Standard

```bash
## Node-Based implementation
spago run -m Games.RandomNumber.ReaderT.Standard.Infrastructure.Console
spago run -m Games.RandomNumber.Free.Standard.Infrastructure.Console
spago run -m Games.RandomNumber.Run.Standard.Infrastructure.Console

## Browser-based implementation
spago bundle --main Games.RandomNumber.ReaderT.Standard.Infrastructure.Halogen.Web --to dist/random-number/readerT--standard/app.js
parcel build -o dist/random-number/readerT--standard/app.js dist/random-number/readerT--standard/index.html

spago bundle --main Games.RandomNumber.Free.Standard.Infrastructure.Halogen.Web --to dist/random-number/free--standard/app.js
parcel build -o dist/random-number/free--standard/index.html

spago bundle --main Games.RandomNumber.Run.Standard.Infrastructure.Halogen.Web --to dist/random-number/run--standard/app.js
parcel build -o dist/random-number/run--standard/app.js dist/random-number/run--standard/index.html

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
parcel build -o dist/random-number/free--layered/app.js dist/random-number/free--layered/index.html

spago build --main Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web --to dist/random-number/run--layered/app.js
parcel build -o dist/random-number/run--layered/app.js dist/random-number/run--layered/index.html

## Test
spago test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```
