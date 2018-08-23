module Syntax.TypeClasses.InstanceChains where

{-
When interacting with the unsafe, impure, and chaotic Javascript world,
let's say you want to verify whether some type is an Int.

How might you do that?
-}

-- naive attempt
isInt0 :: Int -> Boolean
isInt0 _ = true
-- isInt 5 == true
-- isInt "string" -> compilation error

-- One will quickly realize that they need to use a type class:
class IsInt1 a where
  isInt1 :: a -> Boolean

instance isInt1_Int :: IsInt1 Int where
  isInt1 _ = true

instance isInt1_String :: IsInt1 String where
  isInt1 _ = false

typeIsInt1 :: forall a. IsInt1 a => a -> Boolean
typeIsInt1 = isInt1

{-
However, the above shows a problem. One would literally need to write
an instance for every non-Int type in order to use it in
the `typeIsInt1` function. Isn't there a better way?

Yes, and they are called 'instance chains'.

See the below Purescript issue:
https://github.com/purescript/purescript/issues/2315

See the original paper here:
http://homepages.inf.ed.ac.uk/jmorri14/pubs/morris-icfp2010-instances.pdf

As of this writing (use `git blame` to determine the date of this writing
as it may change in the future), Purescript does not support all of the
features described in the paper (i.e. backtracking), but it does work
for simpler use cases:
-}

-- Instance chain syntax:
class InstanceChain a where
  function :: a -> String

instance match1 :: InstanceChain Type1 where
  function _ = "If type is Type1, return this string"
else instance match2 :: InstanceChain Type2 where
  function _ = "else if type is Type2, return this string"
else instance default :: InstanceChain a where -- notice the `a` generic type here
  function _ = "else return this string"

-- Returning to our original problem, we can write:
class IsInt2 a where
  isInt2 :: a -> Boolean

instance isInt_Int :: IsInt2 Int where
  isInt2 _ = true
else instance isInt_a :: IsInt2 a where
  isInt2 _ = false

typeIsInt2 :: forall a. IsInt2 a => a -> Boolean
typeIsInt2 = isInt2

-- necessary to compile
newtype Type1 = T1 Int
newtype Type2 = T2 Number
