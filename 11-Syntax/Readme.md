# Syntax

This folder contains compileable Purescript syntax using meta-language (a language that describes the syntax). Thus, rather than saying something like
```haskell
f :: String -> Int
```
which doesn't tell you anything, it'll say:
```haskell
functionName :: ParameterType -> ReturnType
```

Since the syntax can be compiled, it can be verified as valid and correct syntax.

As a result, most files will appear like so:
```haskell
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

If you want to play around with the syntax, follow these instructions:
1. Go to a directory that has a `spago.dhall` file (otherwise, the rest of these commands won't work)
2. Install the dependencies: `spago install`
3. Start a REPL or build the files with watching (refer to the table below)

| Command | Ideal Usage | Other Comments
| - | - | - |
| `spago repl` | Play with &lt;10 lines of syntax | Edit `.purs-repl` and add `import ModuleName` to automatically import that module whenver you run this command
| `spago build --watch` | Test out 10+ lines of syntax | Saving a file after running this command will re-compile the project |
