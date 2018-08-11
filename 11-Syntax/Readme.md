# Syntax

This folder contains compileable Purescript syntax using meta-language (a language that describes the syntax). Thus, rather than saying something like
```purescript
f :: String -> Int
```
which doesn't tell you anything, it'll say:
```purescipt
functionName :: ParameterType -> ReturnType
```

The files should be read in numerical order using a depth-first search. See the `src/` file in each folder (e.g. 01-Basic-Syntax) for the actual documentation on the syntax.

If you want to play around with the syntax, you can compile the code by typing `pulp --psc-package build` inside each folder that has a `psc-package.json` file.

Note: The "Type-Level-Programming-Syntax" folder is still a WIP.
