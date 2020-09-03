module Syntax.Basic.SpecialCompilerFeatures.TypedWildcards where

{-
Sometimes, when writing code, we're not always sure what type something
should be in a type signature.

In such cases, we can use a feature called "typed wildcards"
to ask the compiler to tell us which type it thinks should go there.

This feature can often be very helpful when debugging a compiler error
or when exploring a new library for the first time.

Typed Wildcards can be either unnamed ("_") or named "?name".

Named typed wildcards will emit a compiler error whereas
unnamed typed wildcards will emit a compiler warning.
-}

someValue :: _ -- unnamed typed wildcard
someValue =
  """
  The '_' character above is an unnamed typed wildcard
  It will produce a compiler warning whose message will include
  the compiler's guess as to what goes there.
  """

-- Uncomment the below code and then rebuild the folder to see what happens

-- someValue2 :: ?TellMeTheType
-- someValue2 =
--   """
--   The "?name" syntax above is a named typed wildcard.
--   It will produce a compiler error whose message will include
--   the compiler's guess as to which type goes there.
--   """
