module RandomNumber.Run.Layered.AddAPITerm where

import Prelude

import Data.Functor.Variant (on)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (runAff_)
import RandomNumber.Core (Bounds, RandomInt, (==#), RemainingGuesses, outOfGuesses, decrement, unRemainingGuesses, GameResult(..))
import RandomNumber.Run.Layered.API (runLowLevelDomainInConsole)
import RandomNumber.Run.Layered.HighLevelDomain (DEFINE_BOUNDS, DEFINE_TOTAL_GUESSES, GEN_RANDOM_INT, MAKE_GUESS, NOTIFY_USER, defineBounds, defineTotalGuesses, game, genRandomInt, makeGuess, notifyUser)
import RandomNumber.Run.Layered.LowLevelDomain (CREATE_RANDOM_INT, GET_USER_INPUT, runHighLevelDomain)
import Node.ReadLine (createConsoleInterface, noCompletion, close)
import Run (FProxy, Run, interpret, lift, send)
import Type.Row (type (+))

-- new High-Level Domain language term

data TellJokeF a = TellJokeF a
derive instance tjf :: Functor TellJokeF

_tellJoke :: SProxy "tellJoke"
_tellJoke = SProxy

type TELL_JOKE r = (tellJoke :: FProxy TellJokeF | r)

tellJoke :: forall r. Run (TELL_JOKE + r) Unit
tellJoke = lift _tellJoke (TellJokeF unit)

-- Algebras

tellJokeToNotifyUser :: forall r. TellJokeF ~> Run (NOTIFY_USER + r)
tellJokeToNotifyUser (TellJokeF next) = do
  notifyUser "Why did the chicken cross the road?"
  -- normally one would wait for the user's response here,
  -- but I'm not going to do so to keep this example simple
  notifyUser "To get to the other slide!"
  notifyUser "What!? What do you mean that's not funny!? \
             \...Well, what did you expect!? :-p"
  pure next

-- Updated 'gameLoop' function

gameLoop :: forall r
          . Bounds -> RandomInt -> RemainingGuesses
         -> Run (NOTIFY_USER + MAKE_GUESS + TELL_JOKE + r) GameResult
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

        -- new code! -----
        when (unRemainingGuesses remaining' (_ == 1)) do
          notifyUser "Oh no! Only 1 guess left!? How about I tell you \
                     \a joke to help you calm down?"
          tellJoke
          notifyUser "That was a fun tangent! Back to the game!"
        -------------

        gameLoop bounds randomInt remaining'

-- Same 'game' code as before, but now 'gameLoop' uses the modified version
-- above. If our game logic wasn't expressed as one entire function, this would
-- take less lines of code to reimplement.
game_2 :: forall r.
        Run ( NOTIFY_USER
            + DEFINE_BOUNDS
            + DEFINE_TOTAL_GUESSES
            + GEN_RANDOM_INT
            + MAKE_GUESS
            + TELL_JOKE
            + r
            ) GameResult
game_2 = do
  -- Unchanged --
  notifyUser "This is a random integer guessing game. \
             \In this game, you must try to guess the random integer \
             \before running out of guesses."

  notifyUser "Before we play the game, the computer needs you to \
             \define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- genRandomInt bounds

  notifyUser $ "Everything is set. You will have " <> show totalGueses <>
               " guesses to guess a number between " <> show bounds <>
               ". Good luck!"
  ---------------

  --- Updated ---
  -- use new `gameLoop` function that includes the `tellJoke` part
  result <- gameLoop bounds randomInt totalGueses
  ---------------

  -- Unchanged --
  case result of
    PlayerWins remaining -> do
      notifyUser "Player won!"
      notifyUser $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt' -> do
      notifyUser "Player lost!"
      notifyUser $ "The number was: " <> show randomInt'

  pure result
  ---------------

-- account for the additional language term
runJoke :: forall r
                    . Run (NOTIFY_USER + TELL_JOKE +

                           GET_USER_INPUT + CREATE_RANDOM_INT + r)
                   ~> Run (NOTIFY_USER +

                           GET_USER_INPUT + CREATE_RANDOM_INT + r)
runJoke = interpret (
  send
    # on _tellJoke tellJokeToNotifyUser
  )

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (game
      # runHighLevelDomain
      # runJoke
      # runLowLevelDomainInConsole interface
    )
