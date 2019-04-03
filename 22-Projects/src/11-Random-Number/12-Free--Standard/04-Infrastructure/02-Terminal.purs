-- | The only change to this file (compared to the ReaderT version)
-- | is the Query type.
-- |
-- | Before:
-- | ```
-- | data Query a
-- |    = NotifyUserF String a
-- |    | GetUserInputF String (String -> a)
-- | ```
-- | After:
-- | ```
-- | type Query a = BackendEffectsF a
-- | ```
-- |
-- | This small change means we have to update the `eval` function to
-- | use the different language.
module RandomNumber.Free.Standard.Infrastructure.Halogen.Terminal (terminal) where

import Prelude
import Data.Array (snoc)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AffClass
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import RandomNumber.Infrastructure.Halogen.UserInput (Language, calcLikeInput)
import RandomNumber.Free.Standard.Domain (BackendEffectsF(..))
import Halogen as H
import Halogen.HTML as HH

type State = { history :: Array String
             , getInput :: Maybe (AVar String)
             }

type Query = BackendEffectsF

type Message = Void

newtype Slot = Slot Int
derive newtype instance eqInstance :: Eq Slot
derive newtype instance ordInstance :: Ord Slot

terminal :: H.Component HH.HTML Query Unit Message Aff
terminal =
  H.parentComponent
    { initialState: const { history: [], getInput: Nothing }
    , render
    , eval
    , receiver: const Nothing
    }
  where
    -- same as before
    render :: State -> H.ParentHTML Query Language Slot Aff
    render state = case state.getInput of
      Just avar ->
        HH.div_
          [ HH.div_ $ state.history <#> \msg -> HH.div_ [HH.text msg]
          , HH.slot (Slot 1) calcLikeInput avar (\s -> Just $ Log s unit)
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
