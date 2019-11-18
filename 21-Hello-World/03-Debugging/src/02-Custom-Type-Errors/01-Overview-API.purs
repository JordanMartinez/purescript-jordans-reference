module Debugging.CustomTypeErrors.OverviewAPI where

{-
# Prim Special Submodules

Every Purescript project imports the Prim module by default:
https://pursuit.purescript.org/builtins/docs/Prim

This module defines `kind Type` and the types
for `Int`, `Array`, and `Function`.

In addition, the Prim module has sub module called "TypeError"
that is not imported by default. Within it, Prim defines a few
things for writing your own custom type warnings/errors.

Similar to what we did in the Syntax folder, we'll show the
value-level definitions of these type-level types, instances, and functions
-}

{-
The following is commented out to prevent a compiler warning:
  "import is redundant"

-- new imports
import Prim.TypeError (
  -- type-level type
    kind Doc

  -- type-level instances
  , Text
  , Quote
  , Above
  , Beside

  -- type-level functions
  , class Warn
  , class Fail
  )

-}

data Doc_
  = Text_ String      -- wraps a Symbol
  | Quote_ String     -- the Type's name as a Symbol
  | QuoteLabel_ String -- Similar to Text but handles things differently
                       -- Used particularly for 'labels', the 'keys'
                       -- in rows/records (see functions file)
  | Beside_ Doc_ Doc_ -- Similar to "left <> right" ("leftright") in that
                      -- it places documents side-by-side. However, it's
                      -- different in that these documents are aligned at
                      -- the top.
  | Above_ Doc_ Doc_  -- same as "top" <> "\n" <> "bottom" ("top\nbottom")

type Explanation = String

warn :: Explanation
warn = """
         Usage:
              - Constrain a type with Warn in a value/function declaration
              - Constrain a type in a type class instance with Warn
         Result:
              If value/function is used, outputs a warning during compile-time
         Compilation succeeds?:
              Yes
         Use Cases:
              - "Soft" Deprecation - Indicate to users of library that this
                  function/value will be removed/changed in future
              - Warning indicating developer/debug code should be removed
                  before production code is released
         Does the REPL display it?:
              No (as of this writing)
         """

fail :: Explanation
fail = """
         Usage:
              - Constrain a type with Fail in a value/function declaration
              - Constrain a type in a type class instance with Fail
         Result:
              If instance is used, outputs an error during compile-time
         Compilation succeeds?:
              No
         Use Cases:
              - "Hard" Deprecation - Remove support for a value/function and
                  force users of library to migrate to new approach or
                  use a different value/function that does the same thing.
              - Provide better error messages for specific type class instances
                  that cannot exist.
         Does the REPL display it?:
              Yes
         """
