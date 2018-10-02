module Games.RandomNumber.Run.API
  ( GetUserInputF(..), GET_USER_INPUT, _getUserInput, getUserInput
  , CreateRandomIntF(..), CREATE_RANDOM_INT, _createRandomInt, createRandomInt
  , getIntFromUser, recursivelyRunUntilPure
  , defineBoundsToAPI, defineTotalGuessesToAPI, makeGuessToAPI, genRandomIntToAPI

  , runDomain
  ) where

import Prelude
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, FProxy, lift, interpret, send)
import Data.Int (fromString)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Games.RandomNumber.Core ( Bounds, mkBounds, mkGuess, mkRandomInt
                               , mkRemainingGuesses, totalPossibleGuesses
                               )

import Games.RandomNumber.Run.Domain (
  NOTIFY_USER, notifyUser
, DefineBoundsF(..), _defineBounds, DEFINE_BOUNDS
, DefineTotalGuessesF(..), _defineTotalGuesses, DEFINE_TOTAL_GUESSES
, GenRandomIntF(..), _genRandomInt, GEN_RANDOM_INT
, MakeGuessF(..), _makeGuess, MAKE_GUESS
)


{-
data API_F a
  -- Rather than adding another term here
  -- that does nothing but forward the message to the infrastructure,
  -- we'll omit it entirely and translate directly from the domain
  -- to the infrastructure level
  = Log String a

  -- However, these two are still kept!
  | GetUserInput String (String -> a)
  | CreateRandomInt Bounds (Int -> a)
-}

data GetUserInputF a = GetUserInputF String (String -> a)
derive instance guif :: Functor GetUserInputF

_getUserInput :: SProxy "getUserInput"
_getUserInput = SProxy

type GET_USER_INPUT r = (getUserInput :: FProxy GetUserInputF | r)

getUserInput :: forall r. String -> Run (GET_USER_INPUT + r) String
getUserInput msg = lift _getUserInput (GetUserInputF msg identity)

---

data CreateRandomIntF a = CreateRandomIntF Bounds (Int -> a)
derive instance criF :: Functor CreateRandomIntF

_createRandomInt :: SProxy "createRandomInt"
_createRandomInt = SProxy

type CREATE_RANDOM_INT r = (createRandomInt :: FProxy CreateRandomIntF | r)

createRandomInt :: forall r. Bounds -> Run (CREATE_RANDOM_INT + r) Int
createRandomInt bounds = lift _createRandomInt (CreateRandomIntF bounds identity)

-- Algebras

defineBoundsToAPI :: forall r. DefineBoundsF ~> Run (NOTIFY_USER + GET_USER_INPUT + r)
defineBoundsToAPI (DefineBoundsF reply) = do
  notifyUser "Please, define the range from which to choose a \
             \random integer. This could be something easy like '1 to 5' \
             \or something hard like `1 to 100`. The range can also include \
             \negative numbers (e.g. '-10 to -1' or '-100 to 100')"

  bounds <- recursivelyRunUntilPure
    (mkBounds
      <$> getIntFromUser "Please enter either the lower or upper bound: "
      <*> getIntFromUser "Please enter the other bound: ")

  notifyUser $ "The random number will be between " <> show bounds <> "."
  pure (reply bounds)

defineTotalGuessesToAPI :: forall r. DefineTotalGuessesF ~> Run (NOTIFY_USER + GET_USER_INPUT + r)
defineTotalGuessesToAPI (DefineTotalGuessesF bounds reply) = do
  notifyUser $ "Please, define the number of guesses you will have. \
               \This must be a postive number. Note: due to the bounds you \
               \defined, there are " <> (show $ totalPossibleGuesses bounds)
               <> " possible answers."

  totalGuesses <- recursivelyRunUntilPure
    (mkRemainingGuesses <$>
      getIntFromUser "Please enter the total number of guesses: ")

  notifyUser $ "You have limited yourself to " <> show totalGuesses
               <> " guesses."
  pure (reply totalGuesses)

genRandomIntToAPI :: forall r. GenRandomIntF ~> Run (NOTIFY_USER + CREATE_RANDOM_INT + r)
genRandomIntToAPI (GenRandomIntF bounds reply) = do
  notifyUser $ "Now generating random number..."

  random <- recursivelyRunUntilPure
    (mkRandomInt bounds <$> createRandomInt bounds)

  notifyUser $ "Finished."
  pure (reply random)

makeGuessToAPI :: forall r. MakeGuessF ~> Run (NOTIFY_USER + GET_USER_INPUT + r)
makeGuessToAPI (MakeGuessF bounds reply) = do
  guess <- recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
  pure (reply guess)

-- Code

getIntFromUser :: forall r. String -> Run (NOTIFY_USER + GET_USER_INPUT + r) Int
getIntFromUser prompt =
  recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

recursivelyRunUntilPure :: forall r e a
                         . Show e
                        => Run (NOTIFY_USER + r) (Either e a)
                        -> Run (NOTIFY_USER + r) a
recursivelyRunUntilPure computation = do
  result <- computation
  case result of
    Left e -> do
      notifyUser $ show e <> " Please try again."
      recursivelyRunUntilPure computation
    Right a -> pure a

data InputError = NotAnInt String
instance ies :: Show InputError where
  show (NotAnInt s) = "User inputted a non-integer value: " <> s

inputIsInt :: String -> Either InputError Int
inputIsInt s = case fromString s of
  Just i -> Right i
  Nothing -> Left $ NotAnInt s

runDomain :: forall r
           . Run (NOTIFY_USER +

                  DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES + GEN_RANDOM_INT +
                  MAKE_GUESS +

                  GET_USER_INPUT + CREATE_RANDOM_INT + r)
          ~> Run (NOTIFY_USER +

                  GET_USER_INPUT + CREATE_RANDOM_INT + r)
runDomain = interpret (
  send
    # on _defineBounds defineBoundsToAPI
    # on _defineTotalGuesses defineTotalGuessesToAPI
    # on _makeGuess makeGuessToAPI
    # on _genRandomInt genRandomIntToAPI
  )
