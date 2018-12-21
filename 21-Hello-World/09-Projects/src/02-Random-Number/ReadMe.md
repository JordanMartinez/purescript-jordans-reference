# Random Number

This folder will show how to build a "guess the random number" game. Here's an overview of its contents:
- Design process and properties we wish to employ
- Shared Code: the domain types, data structures, and their related functions that are used across all the other folders. This folder excludes any infrastructure/framework code (e.g. `Node.ReadLine`/`Halogen`).
- Folders for each application structure

## Compilation Instructions

Run the following while in the `Hello World/Projects/` folder. The web-based games can be opened via `Hello World/Projects/dist/random-number/<FP structure approach>/index.html`:
```bash
## Node-Based implementation
pulp --psc-package run -m Games.RandomNumber.ReaderT.Standard.Infrastructure.Console
pulp --psc-package run -m Games.RandomNumber.Free.Layered.Infrastructure.Console
pulp --psc-package run -m Games.RandomNumber.Run.Layered.Infrastructure.Console

### Changes in Run folder
pulp --psc-package run -m Games.RandomNumber.Run.Layered.ChangeImplementation
pulp --psc-package run -m Games.RandomNumber.Run.Layered.AddDomainTerm

## Browser-based implementation
pulp --psc-package browserify -O -m Games.RandomNumber.ReaderT.Standard.Infrastructure.Halogen.Web --to dist/random-number/readerT/app.js
pulp --psc-package browserify -O -m Games.RandomNumber.Free.Layered.Infrastructure.Halogen.Web --to dist/random-number/free/app.js
pulp --psc-package browserify -O -m Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web --to dist/random-number/run/app.js

## Test
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
pulp --psc-package test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
```
