module Test.Games.RandomNumber.Run.Layered.Infrastructure where

import Prelude
import Data.Tuple (Tuple, snd)
import Data.Maybe (fromJust)
import Data.Array (uncons)
import Data.Functor.Variant (on)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)
import Games.RandomNumber.Core (GameResult)
import Games.RandomNumber.Run.Layered.Domain (
  game
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.Layered.API (
  runDomain
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Run (Run, interpret, send, extract)
import Run.State (STATE, runState, get, put)
import Test.QuickCheck (quickCheck, quickCheck',(<?>))
import Test.Games.RandomNumber.Generators (TestData(..))
import Type.Row (type (+))


main :: Effect Unit
main = do

-- Uncomment these two lines to see the data the code generates:
  -- sample <- randomSample genTestData
  -- log $ show $ (\(TestData record) -> record) <$> sample

  -- quickCheck' 1000 (\(TestData record) ->    -- swap this line with next
  quickCheck (\(TestData record) ->             -- to run more tests
    let gameResult = produceGameResult record.random record.userInputs
    in gameResult == record.result <?>
      "GameResult:     " <> show gameResult <> "\n\
      \ExpectedResult: " <> show record.result
  )

produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  game
    # runDomain
    # runAPI random
    # runInfrastructure userInputs
    # extractStateOutput

  -- which is the same as writing...
  -- extractStateOutput
  --   (runInfrastructure userInputs
  --     (runAPI random (runDomain game)))

extractStateOutput :: Run () (Tuple (Array String) GameResult) -> GameResult
extractStateOutput = snd <<< extract

-- Get rid of the reader/state code and
-- don't make the row type "open" via ' | r' or ' + r'
runInfrastructure :: Array String
                  -> Run (state :: STATE (Array String)) GameResult
                  -> Run () (Tuple (Array String) GameResult)
runInfrastructure allGuesses program =
  program
    # runState allGuesses

-- Get rid of the API-level code
-- and interpret it into reader/state code
runAPI :: forall r.
          Int
       -> Run (state :: STATE (Array String) |
               NOTIFY_USER + GET_USER_INPUT + CREATE_RANDOM_INT +    r)
       ~> Run (state :: STATE (Array String) | r)
runAPI random = interpret (
  send
    # on _notifyUser notifyUserToInfrastructure
    # on _getUserInput getUserInputToInfrastructure
    # on _createRandomInt (createRandomIntToInfrastructure random)
  )

-- Algebras

notifyUserToInfrastructure :: forall r. NotifyUserF ~> Run r
notifyUserToInfrastructure (NotifyUserF _ next) = pure next

getUserInputToInfrastructure :: forall r.GetUserInputF ~> Run (state :: STATE (Array String) | r)
getUserInputToInfrastructure (GetUserInputF _ reply) = do
  array <- get
  let {head: nextInput, tail: array'} = unsafePartial $ fromJust $ uncons array
  put array'

  pure (reply nextInput)

createRandomIntToInfrastructure :: forall r. Int -> CreateRandomIntF ~> Run ( | r)
createRandomIntToInfrastructure random (CreateRandomIntF _ reply) = do
  pure (reply random)
