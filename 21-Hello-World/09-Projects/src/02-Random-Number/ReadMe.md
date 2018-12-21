# Random Number

This folder will show how to build a "guess the random number" game. Here's an overview of its contents:
- Design process and properties we wish to employ
- Shared Code: the domain types, data structures, and their related functions that are used across all the other folders. This folder excludes any infrastructure/framework code (e.g. `Node.ReadLine`/`Halogen`).
- Folders for each application structure

## Compilation Instructions

Run the following while in the `Hello World/Projects/` folder. The web-based games can be opened via `Hello World/Projects/dist/random-number/<FP structure approach>/index.html`:
```bash
# The Node Readline & Aff folder
pulp --psc-package run -m ConsoleLessons.ReadLine.Effect
pulp --psc-package run -m ConsoleLessons.ReadLine.AffMonad

# The Random Number folder
## Node-Based implementation
pulp --psc-package run -m Games.RandomNumber.Free.Infrastructure
pulp --psc-package run -m Games.RandomNumber.Run.Infrastructure
pulp --psc-package run -m Games.RandomNumber.MTL.Infrastructure

### Changes in Run folder
pulp --psc-package run -m Games.RandomNumber.Run.ChangeImplementation
pulp --psc-package run -m Games.RandomNumber.Run.AddDomainTerm

### Changes in MTL folder
pulp --psc-package run -m Games.RandomNumber.MTL.ChangeImplementation
pulp --psc-package run -m Games.RandomNumber.MTL.AddDomainTerm

## Browser-based implementation
pulp --psc-package browserify -O -m Games.RandomNumber.Free.Halogen.Infrastructure --to dist/random-number/free/app.js
pulp --psc-package browserify -O -m Games.RandomNumber.Run.Halogen.Infrastructure --to dist/random-number/run/app.js
pulp --psc-package browserify -O -m Games.RandomNumber.MTL.Halogen.Infrastructure --to dist/random-number/mtl/app.js

## Run-based Test
pulp --psc-package test -m Test.Games.RandomNumber.Run.Infrastructure
```
