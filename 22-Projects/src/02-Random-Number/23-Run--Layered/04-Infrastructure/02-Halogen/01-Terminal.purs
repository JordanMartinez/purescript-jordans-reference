-- | This is the same code as the Free-based version except for one thing:
-- | - the Query type is a subset of our API language
-- |
-- | This small change means we have to use `case_ # on symbol function`
-- | syntax from `purescript-variant`
module Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Terminal (terminal) where

import Prelude
import Data.Array (snoc)
import Data.Functor.Variant (VariantF, on, inj, case_)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import Games.RandomNumber.Infrastructure.Halogen.UserInput (Language, calcLikeInput)
import Games.RandomNumber.Run.Layered.Domain (NotifyUserF(..), _notifyUser, NOTIFY_USER)
import Games.RandomNumber.Run.Layered.API (GetUserInputF(..), _getUserInput, GET_USER_INPUT)
import Halogen as H
import Halogen.HTML as HH
import Type.Row (type (+))

-- | Store the messages that should appear in the terminal (history).
-- | When `getInput == Nothing`, just display the terminal.
-- | When `getInput == Just avar`, display the calculator-like interface
-- | to get the user's input.
type State = { history :: Array String
             , getInput :: Maybe (AVar String)
             }

-- | Rather than defining a new query language here,
-- | we'll just reuse **a subset** of our API language.
type Query = VariantF (NOTIFY_USER + GET_USER_INPUT + ())

-- | No need to raise any messages to listeners outside of this
-- | root component as we'll be emitting messages via AVars.
type Message = Void

-- | There's only one child, so this slot type is overkill. Oh well...
newtype Slot = Slot Int
derive newtype instance eqInstance :: Eq Slot
derive newtype instance ordInstance :: Ord Slot

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
        , HH.slot (Slot 1) calcLikeInput avar (\s -> Just $ inj _notifyUser $ NotifyUserF s unit)
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
  eval :: Query ~> H.ParentDSL State Query Language Slot Message Aff
  eval =
    case_
      # on _notifyUser (\(NotifyUserF msg next) -> do
          H.modify_ (\state -> state { history = state.history `snoc` msg})
          pure next
        )
      # on _getUserInput (\(GetUserInputF msg reply) -> do
          avar <- AffClass.liftAff AVar.empty
          H.modify_ (\state -> state { history = state.history `snoc` msg
                                     , getInput = Just avar })
          value <- AffClass.liftAff $ AVar.take avar
          H.modify_ (\state -> state { getInput = Nothing })
          pure $ reply value
        )
