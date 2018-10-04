# Games

Let's tie all of these ideas together. This folder is a project for a simple working game (guess a random number). As such, it will include:
- side-effects (e.g. state manipulation, random number generation, etc.)
- testing
- benchmarking (pretty sure I can't implement this yet either)
- data validation
- user input via a terminal

It will also demonstrate how one can write a program using a domain-driven design / Onion Architecture mentioned previously.

Start with `src` and then look at `test`.

## Contents

- Explain how to use `Node.ReadLine` in Purecript. Also explain the basics of `Aff`.
- Explain our thinking process for why we wrote the program according to the way that we did (i.e. where did we draw the lines for the "onion" layers in our architecture). This will include visual diagrams.
- Write our program in a few different styles that show their pros/cons:
    - Free-based approach
    - Run-based approach
- Explain our thinking process for how to write a QuickCheck test for our Run-based approach
- Write an example QuickCheck test for our program

## Compilation Instructions

To run the programs/test in this folder, copy and paste this into your terminal:
```bash
# The Node Readline & Aff folder
pulp --psc-package run -m ConsoleLessons.ReadLine.Effect
pulp --psc-package run -m ConsoleLessons.ReadLine.AffMonad

# The Random Number folder
pulp --psc-package run -m Games.RandomNumber.Free.Infrastructure
pulp --psc-package run -m Games.RandomNumber.Run.Infrastructure

# Changes in Run folder
pulp --psc-package run -m Games.RandomNumber.Run.ChangeImplementation
pulp --psc-package run -m Games.RandomNumber.Run.AddDomainTerm

# Run-based Test
pulp --psc-package test -m Test.Games.RandomNumber.Run.Infrastructure
```
