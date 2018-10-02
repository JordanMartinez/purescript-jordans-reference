module Games.RandomNumber.Run.ChangeImplementation where

import Prelude
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, interpret, send, runBaseAff)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (runAff_)
import Node.ReadLine (createConsoleInterface, noCompletion, close)

import Games.RandomNumber.Core (GameResult(..), Bounds, Guess, mkGuess)
import Games.RandomNumber.Run.Core (game)
import Games.RandomNumber.Run.Domain (
  runCore
, NOTIFY_USER, notifyUser
, DEFINE_BOUNDS, _defineBounds
, DEFINE_TOTAL_GUESSES, _defineTotalGuesses
, GEN_RANDOM_INT, _genRandomInt
, MakeGuessF(..), MAKE_GUESS, _makeGuess)
import Games.RandomNumber.Run.API (
  recursivelyRunUntilPure
, GET_USER_INPUT, getUserInput, getIntFromUser
, CREATE_RANDOM_INT
, defineBoundsToAPI, defineTotalGuessesToAPI, genRandomIntToAPI
)

import Games.RandomNumber.Run.Infrastructure (runAPI)

-- | Normally, the user would input their guess and cannot confirm whether
-- | that is the user's final decision. In this interpretation, the user
-- | must confirm their guess or the computer will ask for it again.
makeAndConfirmGuess :: forall r. Bounds -> Run (NOTIFY_USER + GET_USER_INPUT + r) Guess
makeAndConfirmGuess bounds = do
  guess <- recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
  notifyUser $ "You chose '" <> show guess <> "'"
  confirmation <- getUserInput "Are you sure? ('y' = yes; anything else = no): "
  case confirmation of
    "y" -> pure guess
    _ -> do
      notifyUser "You changed your mind. I'll ask again."
      makeAndConfirmGuess bounds

makeGuessToAPI_2 :: forall r. MakeGuessF ~> Run (NOTIFY_USER + GET_USER_INPUT + r)
makeGuessToAPI_2 (MakeGuessF bounds reply) = do
  guess <- makeAndConfirmGuess bounds
  pure (reply guess)

runDomain_2 :: forall r
           . Run (NOTIFY_USER +

                  DEFINE_BOUNDS + DEFINE_TOTAL_GUESSES + GEN_RANDOM_INT +
                  MAKE_GUESS +

                  GET_USER_INPUT + CREATE_RANDOM_INT + r)
          ~> Run (NOTIFY_USER +

                  GET_USER_INPUT + CREATE_RANDOM_INT + r)
runDomain_2 = interpret (
  send
    # on _defineBounds defineBoundsToAPI
    # on _defineTotalGuesses defineTotalGuessesToAPI
    # on _genRandomInt genRandomIntToAPI                              {-

    Before:
    # on _makeGuess makeGuessToAPI

    After:                                                            -}
    # on _makeGuess makeGuessToAPI_2
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
    (runBaseAff $ runAPI interface (runDomain_2 (runCore game)))
