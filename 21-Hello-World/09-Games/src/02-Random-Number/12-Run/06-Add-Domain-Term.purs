module Games.RandomNumber.Run.AddDomainTerm where

import Prelude
import Data.Symbol (SProxy(..))
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Node.ReadLine (createConsoleInterface, noCompletion, close)
import Effect.Aff (runAff_)
import Run (Run, lift, FProxy, interpret, send, runBaseAff)
import Games.RandomNumber.Core ( Bounds
                               , RandomInt, (==#)
                               , RemainingGuesses, outOfGuesses, decrement
                               , unRemainingGuesses
                               , GameResult(..)
                               )
import Games.RandomNumber.Run.Core (
  _explainRules, EXPLAIN_RULES
, _setupGame, SETUP_GAME
, PlayGameF(..), _playGame, PLAY_GAME
, game
)
import Games.RandomNumber.Run.Domain (
  NOTIFY_USER, notifyUser
, DEFINE_BOUNDS, _defineBounds
, DEFINE_TOTAL_GUESSES, _defineTotalGuesses
, GEN_RANDOM_INT, _genRandomInt
, MAKE_GUESS, _makeGuess, makeGuess
, explainRulesToDomain, setupGameToDomain
)
import Games.RandomNumber.Run.API (
  GET_USER_INPUT, CREATE_RANDOM_INT
, defineBoundsToAPI, defineTotalGuessesToAPI, makeGuessToAPI, genRandomIntToAPI)

import Games.RandomNumber.Run.Infrastructure (runAPI)

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

playGameToDomain_2 :: forall r
                    . PlayGameF
                   ~> Run (NOTIFY_USER + MAKE_GUESS + TELL_JOKE + r)
playGameToDomain_2
  (PlayGameF { bound: b, number: n, remaining: remaining } reply) = do
    result <- gameLoop b n remaining

    pure (reply result)

-- Code

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

runCore_2 :: forall r
         . Run (EXPLAIN_RULES + SETUP_GAME + PLAY_GAME +

                -- new code ---
                TELL_JOKE +
                ---------------

                NOTIFY_USER + DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES +
                GEN_RANDOM_INT + MAKE_GUESS + r)
        ~> Run (TELL_JOKE +

                NOTIFY_USER + DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES +
                GEN_RANDOM_INT + MAKE_GUESS + r)
runCore_2 = interpret (
  send
    # on _explainRules explainRulesToDomain
    # on _setupGame setupGameToDomain
    # on _playGame playGameToDomain_2
  )

runDomain :: forall r
           . Run (NOTIFY_USER + TELL_JOKE +

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
    # on _tellJoke tellJokeToNotifyUser
  )

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (case _ of
      Left _ -> close interface
      Right gameResult -> case gameResult of
        PlayerWins remaining -> do
          log "Player won!"
          log $ "Player guessed the random number with " <>
            show remaining <> " trie(s) remaining."
          close interface
        PlayerLoses randomInt -> do
          log "Player lost!"
          log $ "The number was: " <> show randomInt
          close interface
    )
    (runBaseAff $ runAPI interface (runDomain (runCore_2 game)))
