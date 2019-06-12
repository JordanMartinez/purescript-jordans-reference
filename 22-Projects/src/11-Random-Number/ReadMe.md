# Random Number

**Note:** a large number of files from this folder were moved to the `z-dead` folder since an API change in Halogen v5 broke some design assumptions I had made. I czme up with a solution to workaround the change, but i believe it lead to an anti-pattern. Rather than scrapping the entire game, I explained why my workaround was an anti-pattern (see the `Halogen.purs` and `Terminal.purs` files in the `ReaderT--Standard` folder) and moved the other files (i.e. standard and "layered" Free and Run approaches) that used to work on Halogen v4 to `z-dead`.

<hr>

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

The following is no longer true due to the Halogen v5 API changes. See the note at the top of this file.

~Normally, one will use the 'standard' way of structuring their application: via `ReaderT design pattern` or `Run`. Since readers might still be unfamiliar with `Run`, I will also include `Free`. In the upcoming projects, only `ReaderT` and `Run` will be used.~

~I also include the "layered compilers" idea mentioned in the `Hello World/Application Structure/Free` folder. This is purely an experimental idea that shows what one _can_ do, but not necessarily "best practices" per say. It might help one write a program when the specifications are still not well-understood. Or it might just be pointless boilerplate-y work.~

~By "layered compilers," I mean defining a monad with a `Free`/`Run`-based higher-level language (e.g. Highest-level Domain) that gets interpreted another lower-level language (e.g. Lower-Level Domain) recursively until the final low-level language is interpreted into an impure monad (e.g. `Effect` or `Aff`).~

~Since "layered compilers" is rather long, I'll just use "layered" in folders' and modules' names.~

## Libraries Used

`Total Number: 2`

Be familiar with the contents of the below folders in the `Libraries` folder before reading this folder's content:
- ReadLine and Aff
- Halogen

## Compilation Instructions

Run the following while in the `Projects/` folder.

The web-based games require a 2-step process of first running the `spago` command followed by the `parcel` command. The below `parcel` commands are rather verbose because of how this folder is structured. See the overview of the first instance of the command in the below compilation instructions.

The games can be opened and played via `dist/random-number/<FP structure approach>/index.html`.

```bash
# == Node-Based implementation ==
spago run -m RandomNumber.ReaderT.Standard.Main.Console

# == Browser-based implementation ==
spago bundle-app --main RandomNumber.ReaderT.Standard.Main.Halogen --to dist/random-number/readerT--standard/app.js
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

# == Test ==
spago test -m Test.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.RandomNumber.ReaderT.Standard.SameMonad
```
