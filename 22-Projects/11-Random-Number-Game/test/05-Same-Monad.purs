module Test.RandomNumber.ReaderT.Standard.SameMonad
  ( main
  , produceGameResult
  ) where

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (fromJust)
import Data.Array (uncons)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)

import Control.Monad.State (State, runState)
import Control.Monad.State.Class (get, put)

import RandomNumber.Core (GameResult)
import RandomNumber.ReaderT.Standard.Domain (game)
import RandomNumber.ReaderT.Standard.SameMonad (runAppT)

import Test.QuickCheck (quickCheck, quickCheck',(<?>))
import Test.RandomNumber.Generators (TestData(..))


main :: Effect Unit
main = do

  -- quickCheck' 1000 (\(TestData record) ->    -- swap this line with next
  quickCheck (\(TestData record) ->             -- to run more tests
    let gameResult = produceGameResult record.random record.userInputs
    in gameResult == record.result <?>
      "GameResult:     " <> show gameResult <> "\n\
      \ExpectedResult: " <> show record.result
  )

{-
The difference in this file from the Different-Monad lies in a few ideas:
- We delegate the Infrastructure implementation to the Environment type.
    This new type will store all the API functions we need. Thus, we can
    use the same monad for both test and production code.
- Thus, we need to update Environment and AppM to take a monad type in their
     type constructor (e.g. AppM a -> AppM m a)
- We will also need to change how we derive AppM's type class instances.
-}

runTestApp :: Int -> State (Array String) GameResult
runTestApp random =
  runAppT { notifyUser: (\_ -> pure unit)

          {-
          Here, we'll use the State monad to run our state-like operations
          to get the next user input
          -}
          , getUserInput: (\_ -> do
              array <- get
              let {head: nextInput, tail: array'} = unsafePartial $ fromJust $ uncons array
              put array'

              pure nextInput
          )
          , createRandomInt: (\_ _ -> pure random)
          } game

-- Here is where we combine the AppM and State monad together
-- to get our final computed game result
produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  let (Tuple result _) = runState (runTestApp random) userInputs
  in result
