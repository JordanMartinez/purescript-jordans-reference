-- | This is the same code used in the Run-based version
module RandomNumber.Infrastructure.Halogen.UserInput
  ( calcLikeInput
  , SelfSlot
  , QueryType
  , Message
  ) where

import Prelude
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AC
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- | This is the way we'll block the parent's computation until
-- | the user submits their answer.
type Input = AVar String
type State = { input :: String      -- the current input
             , avar :: AVar String
             }
data Action
  = Add String  -- adds a number to the input
  | Clear       -- clears out the input
  | Submit      -- "submits" the input to the parent

type QueryType = Const Void
type Message = Void
type MonadType = Aff
type SelfSlot index = H.Slot QueryType Message index
type ChildSlots = ()

-- | When rendering, the parent will pass in the avar
-- | that it will block on until this component puts
-- | the user's input into that avar
calcLikeInput :: H.Component HH.HTML QueryType Input Message MonadType
calcLikeInput =
  H.mkComponent
    { initialState: (\avar -> {input: "", avar: avar})
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  -- | The interface should look similar to calculator's interface
  render :: State -> H.ComponentHTML Action ChildSlots MonadType
  render state =
    HH.div_
      [ HH.div_ [ HH.text $ state.input ]
      , HH.table_
        [ HH.tbody_
          [ HH.tr_ [ numberCell "1", numberCell "2", numberCell "3"]
          , HH.tr_ [ numberCell "4", numberCell "5", numberCell "6"]
          , HH.tr_ [ numberCell "7", numberCell "8", numberCell "9"]
          , HH.tr_
            [ numberCell "0"
            , HH.td_ [ HH.button [HE.onClick $ (\_ -> Just Clear)] [ HH.text "Clear" ] ]
            , HH.td_ [ HH.button [HE.onClick $ (\_ -> Just Submit)] [ HH.text "Submit" ] ]
            ]
          ]
        ]
      ]

  numberCell numText =
    HH.td_
      [ HH.button
          [HE.onClick $ (\_ -> Just $ Add numText) ]
          [ HH.text numText ]
      ]

  -- | Change the input based on the user's button clicks
  -- | and submit the final input back to parent once done
  handleAction :: Action -> H.HalogenM State Action ChildSlots Message MonadType Unit
  handleAction = case _ of
    Add n -> do
      H.modify_ (\state -> state { input = state.input <> n })
    Clear -> do
      H.modify_ (\s -> s { input = "" })
    Submit -> do
      state <- H.get
      void $ AC.liftAff $ AVar.put state.input state.avar
