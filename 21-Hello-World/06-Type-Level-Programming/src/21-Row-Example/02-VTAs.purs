module TLP.RowExample.VTAs where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Prim.Row (class Union, class Nub, class Cons)
import Type.Proxy (Proxy(..))

type First = (name :: String, age :: Int)
type Second = (pets :: Array Pet)
                                                                                          {-
A function that can change what the outputted Record type must be
based on the row type it receives.

`g` does the following type-level computation:
    - combine two rows using union
    - add another field using cons (age :: Int)
    - remove a duplicate field using Nub
    - union the result with `(otherField :: String`)                                    -}
g
  :: forall a @row1 @row2 row1And2 row1And2PlusAge nubbedRow1And2PlusAge finalRow
  . Union row1 row2 row1And2
  => Cons "age" Int row1And2 row1And2PlusAge
  => Nub row1And2PlusAge nubbedRow1And2PlusAge
  => Union nubbedRow1And2PlusAge (otherField :: String) finalRow
  => a
  -> (a -> Record finalRow) 
  -> Record finalRow
g a function = function a

main :: Effect Unit
main = do
  -- These examples show that the type of the returned record differs
  -- depending on what the two rows we pass to `g` are
  log $ show $ g @First @Second
    5
    (\five -> { age: five, name: "John", pets: [Pet], otherField: "other"})

  log $ show $ g @First @(singlePet :: Pet) 5
    (\five -> { age: five, name: "John", singlePet: Pet, otherField: "other"})

-- needed to compile

data Pet = Pet
instance Show Pet where
  show _ = "Pet"
