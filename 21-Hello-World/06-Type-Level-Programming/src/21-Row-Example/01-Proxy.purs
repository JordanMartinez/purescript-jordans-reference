module TLP.RowExample.Proxy where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Prim.Row (class Union, class Nub, class Cons)
import Type.Proxy (Proxy(..))

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

  Proxy row1 -> Proxy row2 -> Proxy finalRow
f _ _ = Proxy

first :: Proxy (name :: String, age :: Int)
first = Proxy

second :: Proxy (pets :: Array Pet)
second = Proxy

-- A function that can change what the outputted Record type must be
-- based on the row type it receives.
g :: forall finalRow a. Proxy finalRow -> a -> (a -> Record finalRow) -> Record finalRow
g _ a function = function a

-- Same thing as `g` but uses shorter type names and the shorter Record syntax
z :: forall r        a. Proxy r        -> a -> (a -> { | r }        ) -> { | r }
z _ a function = function a

main :: Effect Unit
main = do
  -- These examples show that the type of the returned record differs
  -- depending on what the two rows we pass to `f` are
  log $ show $ g (f first second) 5
    (\five -> { age: five, name: "John", pets: [Pet], otherField: "other"})

  log $ show $ g (f first (Proxy :: Proxy (singlePet :: Pet))) 5
    (\five -> { age: five, name: "John", singlePet: Pet, otherField: "other"})

  -- These examples show that the output is the same regardless of
  -- whether we use the short/long Record syntax
  -- in our function's type signature.
  log $ show $ g (Proxy :: Proxy (name :: String)) 5 (\five -> { name: "a " <> show five })
  log $ show $ z (Proxy :: Proxy (name :: String)) 5 (\five -> { name: "a " <> show five })

-- needed to compile

data Pet = Pet
instance Show Pet where
  show _ = "Pet"
