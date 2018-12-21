module Test.Games.RandomNumber.Run.Infrastructure where

import Prelude
import Data.Tuple (Tuple, snd)
import Data.Maybe (fromJust)
import Data.Array (uncons)
import Data.Functor.Variant (on)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)
import Games.RandomNumber.Core (GameResult)
import Games.RandomNumber.Run.Domain (
  game
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.API (
  runDomain
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Run (Run, interpret, send, extract)
import Run.Reader (READER, runReader, ask)
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
    # runAPI
    # runInfrastructure random userInputs
    # extractStateOutput

  -- which is the same as writing...
  -- extractStateOutput
  --   (runInfrastructure random userInputs
  --     (runAPI (runDomain (runCore game))))

extractStateOutput :: Run () (Tuple (Array String) GameResult) -> GameResult
extractStateOutput = snd <<< extract

-- Get rid of the reader/state code and
-- don't make the row type "open" via ' | r' or ' + r'
runInfrastructure :: Int
                  -> Array String
                  -> Run (reader :: READER Int, state :: STATE (Array String)) GameResult
                  -> Run () (Tuple (Array String) GameResult)
runInfrastructure random allGuesses program =
  program
    # runReader random
    # runState allGuesses

-- Get rid of the API-level code
-- and interpret it into reader/state code
runAPI :: forall r
        . Run (reader :: READER Int, state :: STATE (Array String) |
               NOTIFY_USER + GET_USER_INPUT + CREATE_RANDOM_INT +    r)
       ~> Run (reader :: READER Int, state :: STATE (Array String) | r)
runAPI = interpret (
  send
    # on _notifyUser notifyUserToInfrastructure
    # on _getUserInput getUserInputToInfrastructure
    # on _createRandomInt createRandomIntToInfrastructure
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

createRandomIntToInfrastructure :: forall r. CreateRandomIntF ~> Run (reader :: READER Int | r)
createRandomIntToInfrastructure (CreateRandomIntF _ reply) = do
  random <- ask
  pure (reply random)
