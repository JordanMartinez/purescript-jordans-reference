{-
Now that we understand how to generate random data via combinators,
it's time to look at the Arbitrary type class.
-}
module Test.RandomDataGeneration.Arbitrary where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- needed to compile
import Data.Maybe (fromJust)
import Data.List.NonEmpty as NEL
import Data.Array.NonEmpty as NEA
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)

import Test.QuickCheck (quickCheck)
import Test.QuickCheck.Gen (elements, frequency, Gen)

-- new imports
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)

-- Arbitrary simply defines what a given type's default generator is...

class Arbitrary_ a where
  arbitrary_ :: Gen a

-- For example, given this code...

data Fruit
  = Apple
  | Banana
  | Orange

instance arbitraryFruit :: Arbitrary Fruit where
  arbitrary = elements $ unsafePartial fromJust $ NEA.fromArray [ Apple, Banana, Orange]

-- ... the below (useless) code would compile
-- main :: Effect Unit
-- main = quickCheck (\(fruit :: Fruit) -> true)

{-
The below explanation is largely based on the purescript-quickcheck's repo's
guide. The copyright appears at the end of this file.

Above, I said that `Arbitrary` represents a type's "default generator."
What if we wanted to generate a `Fruit` instance that is more frequently
an `Apple` rather than a `Banana` or `Orange`?
In such cases, we can use `newtype`
-}

-- define our newtype
newtype FrequentApple = FrequentApple Fruit

-- helper function
constant :: Fruit -> Gen FrequentApple
constant fruit = elements $ NEA.singleton $ FrequentApple fruit

-- write its instance
instance arbitraryFrequentApple :: Arbitrary FrequentApple where
  arbitrary = frequency $
    NEL.cons      (Tuple 6.0 (constant Apple))  $
    NEL.cons      (Tuple 2.0 (constant Banana)) $
    NEL.singleton (Tuple 1.0 (constant Orange))

-- write a helper function for unwrapping the type
runApple :: FrequentApple -> Fruit
runApple (FrequentApple fruit) = fruit

-- Then use it in a function
-- main :: Effect Unit
-- main = quickCheck (\usuallyApple -> (\_ -> true) $ runApple usuallyApple)


-- Likewise, we can use the type's arbitrary to create a newtype's arbitrary
newtype SmallInt = SmallInt Int

instance arbitrarySmallInt :: Arbitrary SmallInt where
  arbitrary = (SmallInt <<< (_ / 1000)) <$> arbitrary -- Arbitrary Int

runInt :: SmallInt -> Int
runInt (SmallInt i) = i

-- Now let's put it all together
main :: Effect Unit
main = do
  log "Regular Apple"
  quickCheck (\(fruit :: Fruit) -> true )

  log "Frequent Apple"
  quickCheck (\usuallyApple -> (\_ -> true) $ runApple usuallyApple)

  log "Small Int"
  quickCheck (\(SmallInt i) -> true )

-- Copyright notice of above explanation
{-
Copyright 2018 PureScript

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-}
