module Games.RandomNumber.Run.Domain
  ( NotifyUserF(..), NOTIFY_USER, _notifyUser, notifyUser
  , DefineBoundsF(..), DEFINE_BOUNDS, _defineBounds, defineBounds
  , DefineTotalGuessesF(..), DEFINE_TOTAL_GUESSES, _defineTotalGuesses, defineTotalGuesses
  , GenRandomIntF(..), GEN_RANDOM_INT, _genRandomInt, genRandomInt
  , MakeGuessF(..), MAKE_GUESS, _makeGuess, makeGuess

  , game
  ) where

import Prelude
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Run (Run, FProxy, lift)
import Games.RandomNumber.Core ( Bounds
                               , RandomInt, Guess, (==#)
                               , RemainingGuesses, outOfGuesses, decrement
                               , GameResult(..)
                               )

{-
data DomainLanguage a
  = NotifyUser String a
  | DefineBounds (Bounds -> a)
  | DefineTotalGuesses Bounds (RemainingGuesses -> a)
  | GenerateRandomInt Bounds (RandomInt -> a)
  | MakeGuess Bounds (Guess -> a)
-}

data NotifyUserF a = NotifyUserF String a
derive instance nuf :: Functor NotifyUserF

_notifyUser :: SProxy "notifyUser"
_notifyUser = SProxy

type NOTIFY_USER r = (notifyUser :: FProxy NotifyUserF | r)

notifyUser :: forall r. String -> Run (NOTIFY_USER + r) Unit
notifyUser msg = lift _notifyUser (NotifyUserF msg unit)

---

data DefineBoundsF a = DefineBoundsF (Bounds -> a)
derive instance dbf :: Functor DefineBoundsF

_defineBounds :: SProxy "defineBounds"
_defineBounds = SProxy

type DEFINE_BOUNDS r = (defineBounds :: FProxy DefineBoundsF | r)

defineBounds :: forall r. Run (DEFINE_BOUNDS + r) Bounds
defineBounds = lift _defineBounds (DefineBoundsF identity)

---

data DefineTotalGuessesF a = DefineTotalGuessesF Bounds (RemainingGuesses -> a)
derive instance dtf :: Functor DefineTotalGuessesF

_defineTotalGuesses :: SProxy "defineTotalGuesses"
_defineTotalGuesses = SProxy

type DEFINE_TOTAL_GUESSES r = (defineTotalGuesses :: FProxy DefineTotalGuessesF | r)

defineTotalGuesses :: forall r. Bounds -> Run (DEFINE_TOTAL_GUESSES + r) RemainingGuesses
defineTotalGuesses bounds =
  lift _defineTotalGuesses (DefineTotalGuessesF bounds identity)

---

data GenRandomIntF a = GenRandomIntF Bounds (RandomInt -> a)
derive instance grif :: Functor GenRandomIntF

_genRandomInt :: SProxy "genRandomInt"
_genRandomInt = SProxy

type GEN_RANDOM_INT r = (genRandomInt :: FProxy GenRandomIntF | r)

genRandomInt :: forall r. Bounds -> Run (GEN_RANDOM_INT + r) RandomInt
genRandomInt bounds = lift _genRandomInt (GenRandomIntF bounds identity)

---

data MakeGuessF a = MakeGuessF Bounds (Guess -> a)
derive instance mgf :: Functor MakeGuessF

_makeGuess :: SProxy "makeGuess"
_makeGuess = SProxy

type MAKE_GUESS r = (makeGuess :: FProxy MakeGuessF | r)

makeGuess :: forall r. Bounds -> Run (MAKE_GUESS + r) Guess
makeGuess bounds = lift _makeGuess (MakeGuessF bounds identity)

-- Code

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
-- | MonadRec is not used here because `Aff` is stack-safe
gameLoop :: forall r
          . Bounds -> RandomInt -> RemainingGuesses
         -> Run (NOTIFY_USER + MAKE_GUESS + r) GameResult
gameLoop bounds randomInt remaining
  | outOfGuesses remaining = pure $ PlayerLoses randomInt
  | otherwise = do
    let remaining' = decrement remaining
    guess <- makeGuess bounds
    if guess ==# randomInt
      then pure $ PlayerWins remaining'
      else do
        notifyUser $ "Incorrect. You have " <> show remaining'
          <> " guesses remaining."
        gameLoop bounds randomInt remaining'

-- game
game :: forall r.
        Run ( NOTIFY_USER
            + DEFINE_BOUNDS
            + DEFINE_TOTAL_GUESSES
            + GEN_RANDOM_INT
            + MAKE_GUESS
            + r
            ) GameResult
game = do
  -- explain rules
  notifyUser "This is a random integer guessing game. \
             \In this game, you must try to guess the random integer \
             \before running out of guesses."

  -- setup game
  notifyUser "Before we play the game, the computer needs you to \
             \define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- genRandomInt bounds

  notifyUser $ "Everything is set. You will have " <> show totalGueses <>
               " guesses to guess a number between " <> show bounds <>
               ". Good luck!"

  -- play game
  result <- gameLoop bounds randomInt totalGueses

  case result of
    PlayerWins remaining -> do
      notifyUser "Player won!"
      notifyUser $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt' -> do
      notifyUser "Player lost!"
      notifyUser $ "The number was: " <> show randomInt'

  pure result
