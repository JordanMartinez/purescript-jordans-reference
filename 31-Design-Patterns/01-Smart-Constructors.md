# Smart Constructors

Smart constructors are a solution to the problem of how to create a valid value of some type when the type's definition does not allow invalid values.

## The Problem

For example, one might want to use a type to specify a small integer (0 to 3). A possible solution is wrapping an `Int` in a newtype:
```haskell
module Example.SmallInt (SmallInt(..)) where

newtype SmallInt = SmallInt Int
```

However, anyone can create a `SmallInt` using an `Int` value that is less than 0 or larger than 3: `SmallInt 5`.

As another example, consider this code:
```haskell
module FlawedConstructors
  ( TheType(..)
  , example
  ) where

import Partial.Unsafe (unsafeCrashWith)

-- Let's assume that String value below
-- should only be of three kinds: "apple", "orange", and "banana".
-- (Note: "String" is the wrong type for our situation. We should be using
--   something like "data Fruit = Apple | Orange | Banana".
--   I'm doing this to teach a concept. Don't do this in real code.)
data TheType = DumbConstructor String

example :: TheType -> Int
example (DumbConstructor "apple")  = 1
example (DumbConstructor "orange") = 2
example (DumbConstructor "banana") = 42
example (DumbConstructor _)        = unsafeCrashWith "This should never occur!"
```
Since the type and its constructor are both exported, this enables a user of this module to use it incorrectly. For example, in code outside this module, one could incorrectly write:
```purscript
example (DumbConstructor "fire") -- crashes program with an error
```

## The Solution

The solution is to not export the types' constructors and instead export "smart constructors," which are functions that create a correct value of the type. The only way to get a value of the type is to use one of these functions:
```haskell
module Example.SmallInt (SmallInt, zero, one) where

newtype SmallInt = SmallInt Int

zero :: SmallInt
zero = SmallInt 0

one :: SmallInt
one = SmallInt 1

-- the same for 'two' and 'three'
```
In our previous example, we could also write this:
```haskell
module SmartConstructors
  ( TheType -- `DumbConstructor` isn't exported

  , apple   -- but the functions that wrap the constructor are
  , orange
  , banana
  ) where

import Partial.Unsafe (unsafeCrashWith)

data TheType = DumbConstructor String

apple :: TheType
apple = DumbConstructor "apple"

orange :: TheType
orange = DumbConstructor "orange"

banana :: TheType
banana = DumbConstructor "banana"

example :: TheType -> Int
example (DumbConstructor "apple")  = 1
example (DumbConstructor "orange") = 2
example (DumbConstructor "banana") = 42
example (DumbConstructor _) = unsafeCrashWith "We can guarantee that this will never occur!"
```
Since `DumbConstructor` isn't exported, one is forced to use the apple, orange, or banana smart constructors to get a value of `TheType`. Thus, it prevents one from creating incorrect `TheType` values.
```haskell
preventBadValues :: Array Int
preventBadValues =
  [ example apple  -- returns 1
  , example orange -- returns 2
  , example banana -- returns 42

  , example (DumbConstructor "fire") {- compiler error:
    "You don't have access to that constructor!" -}
  ]
```
