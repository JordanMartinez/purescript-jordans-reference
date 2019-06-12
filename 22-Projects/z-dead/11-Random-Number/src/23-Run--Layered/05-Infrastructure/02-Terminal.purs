-- | This is the same code as the Free-based version except for one thing:
-- | - the Query type is a subset of our API language
-- |
-- | This small change means we have to use `case_ # on symbol function`
-- | syntax from `purescript-variant`
module RandomNumber.Run.Layered.Infrastructure.Halogen.Terminal (terminal) where

import Prelude
import Data.Array (snoc)
import Data.Functor.Variant (case_, inj, on)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import RandomNumber.Infrastructure.Halogen.UserInput (calcLikeInput)
import RandomNumber.Infrastructure.Halogen.UserInput as UserInput
import RandomNumber.Run.Layered.HighLevelDomain (NotifyUserF(..), _notifyUser)
import RandomNumber.Run.Layered.LowLevelDomain (GetUserInputF(..), _getUserInput)
import RandomNumber.Run.Layered.API (TerminalQuery)
import Halogen as H
import Halogen.HTML as HH

type Input = Unit
-- | Store the messages that should appear in the terminal (history).
-- | When `getInput == Nothing`, just display the terminal.
-- | When `getInput == Just avar`, display the calculator-like interface
-- | to get the user's input.
type State = { history :: Array String
             , getInput :: Maybe (AVar String)
             }
type Action = Void
-- | Rather than defining a new query language here,
-- | we'll just reuse **a subset** of our API language.
type Query = TerminalQuery

-- | No need to raise any messages to listeners outside of this
-- | root component as we'll be emitting messages via AVars.
type Message = Void
type MonadType = Aff

-- | There's only one child, so this slot type is overkill. Oh well...
type ChildSlots = (child :: UserInput.SelfSlot Unit)

_child :: SProxy "child"
_child = SProxy

terminal :: H.Component HH.HTML Query Input Message MonadType
terminal =
  H.mkComponent
    { initialState: const { history: [], getInput: Nothing }
    , render
    , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery }
    }
  where
  render :: State -> H.ComponentHTML Action ChildSlots MonadType
  render state = case state.getInput of
    Just avar ->
      HH.div_
        [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
        , HH.slot _child calcLikeInput avar (\s -> Just $ inj _notifyUser $ NotifyUserF s unit)
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
  handleQuery :: Query a -> H.HalogenM State Action ChildSlots Message MonadType (Maybe a)
  handleQuery = case _ of
    case_
      # on _notifyUser (\(NotifyUserF msg next) -> do
          H.modify_ (\state -> state { history = state.history `snoc` msg})
          pure $ Just next
        )
      # on _getUserInput (\(GetUserInputF msg reply) -> do
          avar <- AffClass.liftAff AVar.empty
          H.modify_ (\state -> state { history = state.history `snoc` msg
                                     , getInput = Just avar })
          value <- AffClass.liftAff $ AVar.take avar
          H.modify_ (\state -> state { getInput = Nothing })
          pure $ Just $ reply value
        )
