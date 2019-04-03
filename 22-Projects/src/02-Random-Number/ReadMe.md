# Random Number

This folder will show how to build a "guess the random number" game. It's main purpose is to explore the various ways one can structure an application, including a few experimental ones.

Here's an overview of its contents:
- Design process and properties we wish to employ
- Shared Code: the domain types, data structures, and their related functions that are used across all the other folders. To help reduce duplicate code, some parts of the Infrastructure will appear here as well.
- A folder for each application structure:
    - ReaderT design pattern
    - Free
    - Run
    - Free (experimental approach via 'layered compiler' idea)
    - Run (experimental approach via 'layered compiler' idea)

## Purpose: Exploring The Various Ways One Can Structure the Application

Normally, one will use the 'standard' way of structuring their application: via `ReaderT design pattern` or `Run`. Since readers might still be unfamiliar with `Run`, I will also include `Free`. In the upcoming projects, only `ReaderT` and `Run` will be used.

I also include the "layered compilers" idea mentioned in the `Hello World/Application Structure/Free` folder. This is purely an experimental idea that shows what one _can_ do, but not necessarily "best practices" per say. It might help one write a program when the specifications are still not well-understood. Or it might just be pointless boilerplate-y work.

By "layered compilers," I mean defining a monad with a higher-level language (e.g. Domain) that gets interpreted  (`Free`/`Run`) into another monad with a lower-level language (e.g. API) recursively until the final low-level language is interpreted into an impure monad (e.g. `Effect` or `Aff`).

Since "layered compilers" is rather long, I'll just use "layered" in folders' and modules' names.

## Libraries Used

`Total Number: 2`

Be familiar with the contents of the below folders in the `Libraries` folder before reading this folder's content:
- ReadLine and Aff
- Halogen

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The below `parcel` commands are rather verbose because of how this folder is structured. See the overview of the first instance of the command in the below compilation instructions.

The games can be opened and played via `dist/random-number/<FP structure approach>/index.html`.

### Standard

```bash
# == Node-Based implementation ==
spago run -m Games.RandomNumber.ReaderT.Standard.Main.Console
spago run -m Games.RandomNumber.Free.Standard.Main.Console
spago run -m Games.RandomNumber.Run.Standard.Main.Console

# == Browser-based implementation ==
spago bundle --main Games.RandomNumber.ReaderT.Standard.Main.Halogen --to dist/random-number/readerT--standard/app.js
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

spago bundle --main Games.RandomNumber.Free.Standard.Main.Halogen --to dist/random-number/free--standard/app.js
parcel build dist/random-number/free--standard/example.html --open -p 1112 -d dist/random-number/free--standard/ -o index.html

spago bundle --main Games.RandomNumber.Run.Standard.Main.Halogen --to dist/random-number/run--standard/app.js
parcel build dist/random-number/run--standard/example.html --open -p 1113 -d dist/random-number/run--standard/ -o index.html

# == Test ==
spago test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
spago test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
spago test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```

### Layered

```bash
# == Node-Based implementation ==
spago run -m Games.RandomNumber.Free.Layered.Infrastructure.Console
spago run -m Games.RandomNumber.Run.Layered.Infrastructure.Console

# === Changes in Run folder: Node-based ===
spago run -m Games.RandomNumber.Run.Layered.ChangeImplementation
spago run -m Games.RandomNumber.Run.Layered.AddDomainTerm

# === Changes in Run folder: Browser-based ===
spago build --main Games.RandomNumber.Free.Layered.Infrastructure.Halogen.Web --to dist/random-number/free--layered/app.js
parcel build dist/random-number/free--layered/example.html --open -p 1114 -d dist/random-number/free--layered/ -o index.html

spago build --main Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web --to dist/random-number/run--layered/app.js
parcel build dist/random-number/run--layered/example.html --open -p 1115 -d dist/random-number/run--layered/ -o index.html

# == Test ==
spago test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```
