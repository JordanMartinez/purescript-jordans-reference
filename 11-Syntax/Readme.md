# Syntax

This folder contains compileable Purescript syntax using meta-language (a language that describes the syntax). Thus, rather than saying something like
```purescript
f :: String -> Int
```
which doesn't tell you anything, it'll say:
```purescipt
functionName :: ParameterType -> ReturnType
```

Since the syntax can be compiled, it can be verified as valid and correct syntax.

As a result, most files will appear like so:
```purescript
-- The module will be declared at the top of the file
--   It can be ignored.
module Syntax.ModuleName where

-- The Prelude module will usually be imported
--   It, too, can be ignored.
import Prelude

-- The thing that the file is documenting usually goes here.
--    Don't ignore this stuff.
data Box a = Box a

-- Sometimes the comment "necessary to compile" will appear.
-- It makes the meta-language compileable. Ignore everything underneath it
--   as you read through the files.

-- necessary to compile
type SomeTypeName = String
```

In each folder listed here, go to its `src/` folder to continue reading the documentation.

If you want to play around with the syntax, start the REPL using `pulp repl` or run the command, `pulp --psc-package --watch build`, inside a folder that has a `psc-package.json` file. The latter command will recompile the source files in the folder containing the JSON file each time they are saved, enabling fast feedback loops.

Note: The "Type-Level-Programming-Syntax" folder is still a WIP.
