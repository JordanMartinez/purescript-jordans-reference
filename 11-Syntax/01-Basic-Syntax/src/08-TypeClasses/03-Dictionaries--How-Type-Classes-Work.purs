module Syntax.Basic.Typeclass.Dictionaries where

import Prelude

{-
Previously, we saw that `show` could be used "implicitly" when we
knew what the type was and "explicitly" when we did not know what
the type was but knew it had a constraint

In both cases, the compiler automatically figures out how which instance's
implementation to use. But how does it do this? How do Type Classes work?

Dictionaries are what enable a function/value to magically appear in the
implementation of a function's body. The below code is a summary of
this article about type class 'dictionaries':
https://web.archive.org/web/20200116160958/https://www.schoolofhaskell.com/user/jfischoff/instances-and-dictionaries

I could not explain it clearer nor more concisely than they did.
-}

-- This code....
class ToBoolean a where
  toBoolean :: a -> Boolean

  unUsed :: a -> String

example :: forall a. ToBoolean a => a -> Boolean
example value = toBoolean value

-- ... gets desugared to this code

data ToBooleanDictionary a =
  ToBooleanDictionary
    { toBoolean :: a -> Boolean
    , unUsed :: a -> String
    }

example' :: forall a. ToBooleanDictionary a -> a -> Boolean
example' (ToBooleanDictionary record) value = record.toBoolean value
