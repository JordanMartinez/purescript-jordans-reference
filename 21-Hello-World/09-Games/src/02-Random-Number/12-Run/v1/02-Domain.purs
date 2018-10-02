module Games.RandomNumber.Run.VOne.Domain
  ( NotifyUserF(..), NOTIFY_USER, _notifyUser, notifyUser
  , DefineBoundsF(..), DEFINE_BOUNDS, _defineBounds, defineBounds
  , DefineTotalGuessesF(..), DEFINE_TOTAL_GUESSES, _defineTotalGuesses, defineTotalGuesses
  , GenRandomIntF(..), GEN_RANDOM_INT, _genRandomInt, genRandomInt
  , MakeGuessF(..), MAKE_GUESS, _makeGuess, makeGuess

  , explainRulesToDomain, setupGameToDomain, playGameToDomain

  , runCore
  ) where

import Prelude
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, FProxy(..), lift, interpret, send)
import Games.RandomNumber.Core ( Bounds, totalPossibleGuesses
                               , RandomInt, Guess, (==#)
                               , RemainingGuesses, outOfGuesses, decrement
                               , GameResult(..)
                               , mkGameInfo
                               )
import Games.RandomNumber.Run.VOne.Core (
  ExplainRulesF(..), _explainRules, EXPLAIN_RULES
, SetupGameF(..), _setupGame, SETUP_GAME
, PlayGameF(..), _playGame, PLAY_GAME
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

-- Algebras

explainRulesToDomain :: forall r. ExplainRulesF ~> Run (NOTIFY_USER + r)
explainRulesToDomain (ExplainRulesF next) = do
  notifyUser "This is a random integer guessing game. \
             \In this game, you must try to guess the random integer \
             \before running out of guesses."

  pure next

setupGameToDomain :: forall r
             . SetupGameF
            ~> Run (NOTIFY_USER +
                    DEFINE_BOUNDS +
                    DEFINE_TOTAL_GUESSES +
                    GEN_RANDOM_INT + r)
setupGameToDomain (SetupGameF reply) = do
  notifyUser "Before we play the game, the computer needs you to \
             \define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- genRandomInt bounds

  notifyUser $ "Everything is set. You will have " <> show totalGueses <>
               " guesses to guess a number between " <> show bounds <>
               ". Good luck!"

  pure (reply $ mkGameInfo bounds randomInt totalGueses)

playGameToDomain :: forall r
             . PlayGameF
            ~> Run (NOTIFY_USER + MAKE_GUESS + r)
playGameToDomain
  (PlayGameF { bound: b, number: n, remaining: remaining } reply) = do
    result <- gameLoop b n remaining

    pure (reply result)

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

runCore :: forall r
         . Run (EXPLAIN_RULES + SETUP_GAME + PLAY_GAME +

                NOTIFY_USER + DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES +
                GEN_RANDOM_INT + MAKE_GUESS + r)
        ~> Run (NOTIFY_USER + DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES +
                GEN_RANDOM_INT + MAKE_GUESS + r)
runCore = interpret (
  send
    # on _explainRules explainRulesToDomain
    # on _setupGame setupGameToDomain
    # on _playGame playGameToDomain
  )

    -- EndGame gameResult next ->
    --   case gameResult of
    --     PlayerWins remaining -> do
    --       log "Player won!"
    --       log $ "Player guessed the random number with " <>
    --         show remaining <> " trie(s) remaining."
    --       pure next
    --     PlayerLoses randomInt -> do
    --       log "Player lost!"
    --       log $ "The number was: " <> show randomInt
    --       pure next
