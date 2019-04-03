module Games.RandomNumber.Free.Standard.Infrastructure.Halogen.Terminal (terminal) where

import Prelude
import Data.Array (snoc)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Free.Standard.Domain (API_F(..))
import Games.RandomNumber.Infrastructure.Halogen.UserInput (Language, calcLikeInput)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen (liftEffect)

-- Rather than defining our query language
-- for this component, we'll just re-use the API language

-- | Store the messages that should appear in the terminal (history).
-- | When `getInput == Nothing`, just display the terminal.
-- | When `getInput == Just avar`, display the calculator-like interface
-- | to get the user's input.
type State = { history :: Array String
             , getInput :: Maybe (AVar String)
             }

-- | Rather than defining a new query language here,
-- | we'll just reuse the API_F one.
type Query = API_F

-- | No need to raise any messages to listeners outside of this
-- | root component as we'll be emitting messages via AVars.
type Message = Void

-- | There's only one child, so this slot type is overkill. Oh well...
newtype Slot = Slot Int
derive newtype instance e :: Eq Slot
derive newtype instance s :: Ord Slot

-- |
terminal :: H.Component HH.HTML Query Unit Message Aff
terminal =
  H.parentComponent
    { initialState: const { history: [], getInput: Nothing }
    , render
    , eval
    , receiver: const Nothing
    }
  where
  render :: State -> H.ParentHTML Query Language Slot Aff
  render state = case state.getInput of
    Just avar ->
      HH.div_
        [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
        , HH.slot (Slot 1) calcLikeInput avar (HE.input Log)
        ]
    Nothing ->
      HH.div_
        [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
        ]

  -- | Log: Our game's business logic outside this
  -- |   component will send a query into this root component
  -- |   to add the message to the terminal
  -- | GetUserInput: Our game's business logic outside this
  -- |   component will send a query into this root component
  -- |   to get the user's input. This component will re-render
  -- |   itself with the calculator-like interface,
  -- |   so that user can submit their input. Evaluation will block
  -- |   until user submits their input. Once received, this component
  -- |   will re-render so that the interface disappears.
  -- |   and then return the user's input to the game logic code outside.
  -- | GenRandomInt: We don't need to use the UI to generate a random int.
  -- |   However, because this instance is part of the `API_F` type,
  -- |   we need to account for it, so that we have a total function.
  eval :: Query ~> H.ParentDSL State Query Language Slot Message Aff
  eval = case _ of
    Log msg next -> do
      H.modify_ (\state -> state { history = state.history `snoc` msg})
      pure next
    GetUserInput msg reply -> do
      avar <- AffClass.liftAff AVar.empty
      H.modify_ (\state -> state { history = state.history `snoc` msg
                                 , getInput = Just avar })
      value <- AffClass.liftAff $ AVar.take avar
      H.modify_ (\state -> state { getInput = Nothing })
      pure $ reply value
    GenRandomInt bounds reply -> do
      random <- unBounds bounds (\l u -> liftEffect $ randomInt l u)

      pure (reply random)
