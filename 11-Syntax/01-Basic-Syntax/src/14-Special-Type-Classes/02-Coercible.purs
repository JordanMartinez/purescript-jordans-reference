module Syntax.Basic.Typeclass.Special.Coercible where

import Prelude
import Prim.Coerce (class Coercible)
import Safe.Coerce (coerce)

-- ## Linking to the paper for an (optional) detailed explanation

-- In this file, we'll provide a beginner-friendly summary of the paper
-- that is linked below. For our purposes, we will only explain the bare
-- minimum necessary to make the rest of this file make sense.

-- If you wish to know more, read the paper below. However, be warned that
-- those who are new to functional programming will likely not understand
-- as much until they understand the `Functor` and/or `Foldable` type classes.
-- These are covered in the `Hello World/Prelude-ish` folder in this project.

-- Here's the paper: "Safe zero-cost coercions for Haskell"
-- https://repository.brynmawr.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=1010&context=compsci_pubs

---------------------------------------------------------------------------

-- ## Summary of the Problem

-- While we have stated earlier that newtypes are "zero-cost abstractions"
-- in that one does not incur a performance penalty for wrapping and unwrapping
-- a newtyped value, there are some situations where this is not true.

-- For example, let's say you had the following types:

-- | A comment that has multiple lines of text.
newtype MultiLineComment = MultiLineComment String

-- | A comment that has only 1 line of text.
newtype SingleLineComment = SingleLineComment String

-- Let's say we wish to convert an `Array MultiLineComment` into
-- `Array SingleLineComment` via the function,
--     `exposeLines :: String -> Array String`

-- While newtypes are "zero-cost abstractions," this particular algorithm
-- would incur a heavy performance cost. Here's what we would have to do:
-- 1. Convert the `MultiLineComment` type into the `String` type
--      by iterating through the entire `Array MultiLineComment` and unwrapping
--      the `MultiLineComment` newtype wrapper.
-- 2. Use `exposeLines` to convert each multi-line `String` into an `Array`
--      of Strings by iterating through the resulting array.
--      Each `String` in the resulting array would have only 1 line of content.
-- 3. Combine all `Arrays` of single-line `String`s into one Array.
--      In other words, `combine :: Array (Array String) -> Array String`
-- 4. Convert the `String` type into the `SingleLineComment` type
--       by iterating through the final `Array` and wrapping each `String` in a
--      `SingleLineComment` newtype.

-- Steps 1 and 4 are necessary to satisfy type safety. At the type-level,
-- a `String` is not a `MultiLineComment`, nor a `SingleLineComment`.
-- However, those three types do have the same runtime representation. Thus,
-- Steps 1 and 4 are an unnecessary performance cost. Due to using newtypes
-- in this situation, we iterate through the array two times more than needed.

-- A `MultiLineComment` can be converted into a `String` safely and
-- a `String` into a `SingleLineComment` safely. This type conversion
-- process is safe and therefore unnecessary. The problem is that the developer
-- does not have a way to provide the compiler with a proof of this safety.
-- If the compiler had this proof, it could verify it and no longer complain
-- when the developer converts the `Array MultiLineComment` into an
-- `Array String` through a O(1) functio.

-- The solution lays in two parts: the `Coercible` type class
-- and "role annotations."

-- ## Coercible

-- This is the exact definition of the `Coercible` type class. However,
-- we add the "_" suffix to distinguish this fake one from the real one.
class Coercible_ a b where
  coerce_ :: a -> b

-- The `Coercible` type class says, "I can safely convert a value of type `a`
-- into a value of type `b`." This solves our immediate problem, but it
-- introduces a new problem. Since the main usage of `Coercible` is to
-- remove the performance cost of newtypes in specific situations, how do
-- make it impossible to write `Coercible` instances for invalid types?

-- For example, a `DataBox` is a literal box at runtime because it uses the
-- `data` keyword. It actually has to wrap and unwrap the underying value:
data DataBox a = DataBox a

-- The `NewtypedBox` below is NOT a literal box at runtime because
-- it doesn't actually wrap/unwrap the underlying value.
newtype NewtypedBox theValue = NewtypedBox theValue

-- Thus, while we could have a type class instance for `MultiLineComment`,
-- `String`, and `SingleLineComment`, should we have an instance
-- between `DataBox` and `NewtypedBox`? The answer is no.
--
-- However, how would we tell that to the compiler, so it could verify that
-- for us? The answer is "role annotations."

-- ## Role Annotations

-- For another short explanation, see the answer to the post,
-- "What is a role?" https://discourse.purescript.org/t/what-is-a-role/2109/2

-- Role annotations tell the compiler what rules to follow when determining
-- whether a Coercible instance between two types is valid. There are
-- three possible values: representational, phantom, and nominal.

-- Role annotation syntax follows this syntax pattern:
-- `type role TheAnnotatedType oneRoleAnnotationForEachTypeParameter`

-- ### Representational

-- Representational says,
--  "If `A` can be safely coerced to `B` and the runtime representation of
--     `Box a` does NOT depend on `a`, then `Box a` can be safely
--     coerced to `Box b`." (in contrast to `nominal`)

-- Given a type like Box, which only has one type parameter, `a`...
data Box a = Box a

-- ... we would write the following:
type role Box representational

-- Here's another example that shows what to do when we have
-- multiple type parameters
data BoxOfThreeValues a b c = BoxOfThreeValues a b c

type role BoxOfThreeValues representational representational representational

-- ### Phantom

-- Phantom says,
-- "Two phantom types never have a runtime representation. Therefore,
-- two phantom types can always be coerced to one another."

-- Given a box-like type that has a phantom type parameter, `phantomType`...
data PhantomBox :: Type -> Type
data PhantomBox phantomType = PhantomBox

-- ... we would write the following:
type role PhantomBox phantom

-- Here's another example that mixes role annotations:
data BoxOfTwoWithPhantom :: Type -> Type -> Type -> Type
data BoxOfTwoWithPhantom a phantom b = BoxOfTwoWithPhantom

type role BoxOfTwoWithPhantom representational phantom representational

-- ### Nominal

-- Nominal says,
--  "If `A` can be safely coerced to `B` and the runtime representation of
--     `Box a` DOES depend on `a`, then `Box a` can NOT be safely
--     coerced to `Box b`." (in contrast to `representational`)

-- When we don't have enough information (e.g. writing FFI), we default
-- to the nominal role annotation. Below, we'll see why.

-- For example, let's consider `HashMap key value`. Let's say we use a type class
-- called `Hashable` to calculate the hash of a given key. Since newtypes
-- can implement a different type class instance for the same runtime
-- representation, wrapping that value in a newtype and then hashing it
-- might not produce the same hash as the original. Thus, we would return
-- a different value.

class Hashable key where
  hash :: key -> Int

instance hashableInt :: Hashable Int where
  hash key = key

newtype SpecialInt = SpecialInt Int

derive instance eqSpecialInt :: Eq SpecialInt
instance hashableSpecialInt :: Hashable SpecialInt where
  hash (SpecialInt key) = key * 31

data Map key value = Map key value

type role Map representational representational

data Maybe a = Nothing | Just a

derive instance eqMaybe :: (Eq a) => Eq (Maybe a)

lookup
  :: forall key1 key2 value
   . Coercible key2 key1
  => Hashable key1
  => Map key1 value
  -> key2
  -> Maybe value
lookup (Map k value) key =
  let
    coercedKey :: key1
    coercedKey = coerce key
  in
    if hash k == hash coercedKey then Just value
    else Nothing

normalMap :: Map Int Int
normalMap = Map 4 28

-- This will output `true`
testLookupNormal :: Boolean
testLookupNormal = (lookup normalMap 4) == (Just 4)

-- This will output `false`
testLookupSpecial :: Boolean
testLookupSpecial = (lookup specialMap 4) == (Just 4)
  where
  -- changes `Map 4 28` to `Map (SpecialInt 4) 28`
  specialMap :: Map SpecialInt Int
  specialMap = coerce normalMap

-- To prevent this possibility from ever occurring, we indicate that
-- a type parameter's role is 'nominal'. Rewriting our `Map` implementation
-- so that `key` is nominal would prevent this from occurring. Since
-- the `value` type parameter does not affect the runtime representation,
-- it can be representational.

data SafeMap key value = SafeMap key value

type role SafeMap nominal representational
