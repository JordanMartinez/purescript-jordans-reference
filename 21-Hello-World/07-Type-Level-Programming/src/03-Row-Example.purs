module TLP.RowExample where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Prim.Row (class Union, class Nub, class Cons)
import Type.Row (RProxy(..))

{-
`f` does the following type-level computation:
    - combine two rows using union
    - add another field using cons (age :: Int)
    - remove a duplicate field using Nub
    - union the result with something else                                    -}
f :: forall row1 row2 row1And2 row1And2PlusAge nubbedRow1And2PlusAge finalRow.
  Union row1 row2 row1And2 =>
  Cons "age" Int row1And2 row1And2PlusAge =>
  Nub row1And2PlusAge nubbedRow1And2PlusAge =>
  Union nubbedRow1And2PlusAge (otherField :: String) finalRow =>

  RProxy row1 -> RProxy row2 -> RProxy finalRow
f _ _ = RProxy

first :: RProxy (name :: String, age :: Int)
first = RProxy

second :: RProxy (pets :: Array Pet)
second = RProxy

-- A function that can change what the outputted Record type must be
-- based on the row type it receives.
g :: forall finalRow a. RProxy finalRow -> a -> (a -> Record finalRow) -> Record finalRow
g _ a function = function a

-- Same thing as `g` but uses shorter type names and the shorter Record syntax
z :: forall r        a. RProxy r        -> a -> (a -> { | r }        ) -> { | r }
z _ a function = function a

main :: Effect Unit
main = do
  -- These examples show that the type of the returned record differs
  -- depending on what the two rows we pass to `f` are
  log $ show $ g (f first second) 5
    (\five -> { age: five, name: "John", pets: [Pet], otherField: "other"})

  log $ show $ g (f first (RProxy :: RProxy (singlePet :: Pet))) 5
    (\five -> { age: five, name: "John", singlePet: Pet, otherField: "other"})

  -- These examples show that the output is the same regardless of
  -- whether we use the short/long Record syntax
  -- in our function's type signature.
  log $ show $ g (RProxy :: RProxy (name :: String)) 5 (\five -> { name: "a"})
  log $ show $ z (RProxy :: RProxy (name :: String)) 5 (\five -> { name: "a"})

-- needed to compile

data Pet = Pet
instance showPet :: Show Pet where
  show _ = "Pet"
