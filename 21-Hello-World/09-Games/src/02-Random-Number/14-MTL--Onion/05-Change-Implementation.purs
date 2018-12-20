module Games.RandomNumber.MTL.ChangeImplementation
  ( makeAndConfirmGuess
  , main
  )
  where

import Prelude
import Effect.Random (randomInt)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff (Aff, runAff_)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Type.Equality (class TypeEquals, from)

import Games.RandomNumber.Core (Bounds, unBounds, RandomInt, Guess, RemainingGuesses, mkGuess)
import Games.RandomNumber.MTL.Core (
  game
, class ExplainRules, class SetupGame, class PlayGame
)
import Games.RandomNumber.MTL.Domain (
  class NotifyUser, notifyUser
, class DefineBounds
, class DefineTotalGuesses
, class GenerateRandomInt
, class MakeGuess
, explainRulesToDomain, setupGameToDomain, playGameToDomain
)
import Games.RandomNumber.MTL.API (
  class GetUserInput, getUserInput
, class CreateRandomInt
, defineBoundsToAPI, defineTotalGuessesToAPI, generateRandomIntToAPI
, getIntFromUser, recursivelyRunUntilPure
)
import Games.RandomNumber.MTL.Infrastructure (Environment, question)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface game)

-- | Normally, the user would input their guess and cannot confirm whether
-- | that is the user's final decision. In this interpretation, the user
-- | must confirm their guess or the computer will ask for it again.
makeAndConfirmGuess :: forall m.
                       NotifyUser m =>
                       GetUserInput m =>
                       Bounds -> m Guess
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

-- Since `makeGuess` is used in the original `AppM`'s type class instance for
-- MakeGuess, we will need to re-implement the entire `AppM` type under
-- a different name that implements `MakeGuess` with the new function above.

newtype AppWithChange a = AppWithChange (ReaderT Environment Aff a)

runAppWithChange :: Environment -> AppWithChange ~> Aff
runAppWithChange env (AppWithChange m) = runReaderT m env

derive newtype instance a1 :: Functor AppWithChange
derive newtype instance a2 :: Applicative AppWithChange
derive newtype instance a3 :: Apply AppWithChange
derive newtype instance a4 :: Bind AppWithChange
derive newtype instance a5 :: Monad AppWithChange
derive newtype instance a6 :: MonadEffect AppWithChange
derive newtype instance a7 :: MonadAff AppWithChange

instance monadAskAppWithChange :: TypeEquals e Environment => MonadAsk e AppWithChange where
  ask = AppWithChange $ asks from

--------------------------------

-- Similarly, we will need to re-implement runAPI to use
-- the new `AppWithChange` type
runAPI :: Interface -> AppWithChange ~> Aff
runAPI iface =
  runAppWithChange
          { notifyUser: liftEffect <<< log
          , getUserInput: question iface
          , createRandomInt: (\l u -> liftEffect $ randomInt l u)
          }

-- Algebras

--------------------------------
-- runCore

instance explainRules :: ExplainRules AppWithChange where
  explainRules :: AppWithChange Unit
  explainRules = explainRulesToDomain

instance setupGame :: SetupGame AppWithChange where
  setupGame = setupGameToDomain

instance playgame :: PlayGame AppWithChange where
  playGame = playGameToDomain

--------------------------------
-- runDomain

instance defineBounds :: DefineBounds AppWithChange where
  defineBounds :: AppWithChange Bounds
  defineBounds = defineBoundsToAPI

instance defineTotalGueses :: DefineTotalGuesses AppWithChange where
  defineTotalGuesses :: Bounds -> AppWithChange RemainingGuesses
  defineTotalGuesses = defineTotalGuessesToAPI

instance generateRandomInt :: GenerateRandomInt AppWithChange where
  generateRandomInt :: Bounds -> AppWithChange RandomInt
  generateRandomInt = generateRandomIntToAPI

-- Here's where we use a different function instead
instance makeGuess :: MakeGuess AppWithChange where
  makeGuess :: Bounds -> AppWithChange Guess  {-
  ... Before:
  makeGuess = makeGuessToAPI
  ... After:                                  -}
  makeGuess = makeAndConfirmGuess

--------------------------------
-- runAPI

instance notifyUser :: NotifyUser AppWithChange where
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

instance getUserInputToInfrastructure :: GetUserInput AppWithChange where
  getUserInput :: String -> AppWithChange String
  getUserInput prompt = do
    env <- ask
    liftAff $ env.getUserInput prompt

instance createRandomIntToInfrastructure :: CreateRandomInt AppWithChange where
  createRandomInt :: Bounds -> AppWithChange Int
  createRandomInt bounds = do
    env <- ask
    liftAff $ unBounds bounds (\l u -> env.createRandomInt l u)
