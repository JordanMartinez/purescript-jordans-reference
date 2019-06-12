-- | This file will be reused in each application structure's folder.
-- | It will only change slightly in that the `Query` type will change
-- | and the `eval` function will be updated to work with that new `Query` type.
module RandomNumber.Infrastructure.Halogen.Terminal (terminal, Query(..)) where

import Prelude
import Data.Array (snoc)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import RandomNumber.Infrastructure.Halogen.UserInput (calcLikeInput)
import RandomNumber.Infrastructure.Halogen.UserInput as UserInput
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
-- | Due to using MTL, we'll need to define a
-- | Query type for the API parts of AppM
data Query a
  = NotifyUserF String a
  | GetUserInputF String (AVar String) a

-- | No need to raise any messages to listeners outside of this
-- | root component as we'll be emitting messages via AVars.
type Message = Void
type MonadType = Aff

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
        , HH.slot _child unit calcLikeInput avar (const Nothing)
        ]
    Nothing ->
      HH.div_
        [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
        ]

  handleQuery :: forall a. Query a -> H.HalogenM State Action ChildSlots Message MonadType (Maybe a)
  handleQuery = case _ of
    NotifyUserF msg next -> do
      H.modify_ (\state -> state { history = state.history `snoc` msg})
      pure $ Just next
    GetUserInputF prompt callbackAvar next -> do
      -- Again, this is an anti-pattern. Don't do this in real code.
      -- If this same "create avar, pass it into child, and 'block' by
      -- taking from the avar, which won't occur until the child puts a value
      -- into the avar" approach was used in much larger applications,
      -- it would be very difficult to understand the control flow of
      -- the progrma.
      -- I'm including it here, so that I can meka a new release for this
      -- repo and so that one can see an example of what not to do.
      avar <- AffClass.liftAff AVar.empty
      H.modify_ (\state -> state { history = state.history `snoc` prompt
                                 , getInput = Just avar })
      value <- AffClass.liftAff $ AVar.take avar
      H.modify_ (\state -> state { getInput = Nothing })
      AffClass.liftAff $ AVar.put value callbackAvar
      pure $ Just next
