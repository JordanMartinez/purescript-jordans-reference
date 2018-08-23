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

-- The Prelude module might be imported
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

If you want to play around with the syntax, use this table for reference

| Command | Usage |
| - | - |
| `pulp repl` | Play with &lt;10 lines of syntax |
| `pulp --psc-package --watch build` | Test out 10+ lines of syntax<br>Saving a file will re-compile project |

Note: The "Type-Level-Programming-Syntax" folder is still a WIP.
