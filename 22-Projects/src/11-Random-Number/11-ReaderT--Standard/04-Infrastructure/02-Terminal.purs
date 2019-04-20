-- | This file will be reused in each application structure's folder.
-- | It will only change slightly in that the `Query` type will change
-- | and the `eval` function will be updated to work with that new `Query` type.
module RandomNumber.Infrastructure.Halogen.Terminal (terminal, Query(..)) where

import Prelude
import Data.Array (snoc)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import RandomNumber.Infrastructure.Halogen.UserInput (Language, calcLikeInput)
import Halogen as H
import Halogen.HTML as HH

-- | Store the messages that should appear in the terminal (history).
-- | When `getInput == Nothing`, just display the terminal.
-- | When `getInput == Just avar`, display the calculator-like interface
-- | to get the user's input.
type State = { history :: Array String
             , getInput :: Maybe (AVar String)
             }

-- | Due to using MTL, we'll need to define a
-- | Query type for the API parts of AppM
data Query a
  = NotifyUserF String a
  | GetUserInputF String (String -> a)

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
        , HH.slot (Slot 1) calcLikeInput avar (\s -> Just $ NotifyUserF s unit)
        ]
    Nothing ->
      HH.div_
        [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
        ]

  eval :: Query ~> H.ParentDSL State Query Language Slot Message Aff
  eval = case _ of
    NotifyUserF msg next -> do
      H.modify_ (\state -> state { history = state.history `snoc` msg})
      pure next
    GetUserInputF prompt reply -> do
      avar <- AffClass.liftAff AVar.empty
      H.modify_ (\state -> state { history = state.history `snoc` prompt
                                 , getInput = Just avar })
      value <- AffClass.liftAff $ AVar.take avar
      H.modify_ (\state -> state { getInput = Nothing })
      pure $ reply value
