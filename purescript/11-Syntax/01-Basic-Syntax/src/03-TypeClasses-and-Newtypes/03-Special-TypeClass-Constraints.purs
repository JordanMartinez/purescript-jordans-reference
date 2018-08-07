module Syntax.Typeclass.Special where

import Prelude
-- Oddly enough, some type classes don't have a method or an instance.
-- Odder still, this is actually useful:

-- Symbol will be explained in later

-- class Warn (message :: Symbol)

-- deprecatedFunction :: Warn "This warning message will appear when compiling" => TypeSignature

-- class Error (message :: Symbol)

-- brokenFunction :: Error "This will throw a compiler error and output this message" => TypeSignature

{-
A type class which documents which functions are partial, rather than total.
A total function can map any value in one domain to another domain. Integer
  addition via the "+" operator is an example: any integer (starting domain)
  can be mapped to another integer (ending domain) using the function "+".
A partial function can map only some values in one domain to another domain.
  Integer division via the "/" operator is an example: not all integers
  (starting domain) can be mapped to another integer (ending domain).
  Why? Division by zero is undefined: x / 0 = ???
  Thus, division is a partial function whereas addition is a total function.
-}

-- class Partial a where

import Partial (crashWith)
import Partial.Unsafe (unsafePartial)

arrayFirstElement :: forall a. Partial => Array a -> a
arrayFirstElement [] = crashWith "An empty array cannot have a 'first' element"
arrayFirstElement [a, _] = a

-- and then using it in code

test :: Boolean
test =
  (unsafePartial ( arrayFirstElement ["hello"] )) == "hello"

-- This type exists in cases where it'll increase performance as long as
-- we use it safely. By using `unsafePartial` in your code, you are indicating
-- that you are using the code correctly.
