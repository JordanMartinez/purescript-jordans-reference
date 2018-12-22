-- | This is the same code used in the Free-based version
module Games.RandomNumber.Run.Standard.Infrastructure.Halogen.UserInput
  ( Language(..)
  , calcLikeInput
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class as AC
import Effect.Aff.AVar (AVar)
import Effect.Aff.AVar as AVar
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

data Language a
  = Add String a  -- adds a number to the input
  | Clear a       -- clears out the input
  | Submit a      -- "submits" the input to the parent

type CalcState = { input :: String      -- the curren tinput
                 , avar :: AVar String
                 }
type Msg_UserInput = String

-- | When rendering, the parent will pass in the avar
-- | that it will block on until this component puts
-- | the user's input into that avar
calcLikeInput :: H.Component HH.HTML Language (AVar String) Msg_UserInput Aff
calcLikeInput =
  H.component
    { initialState: (\avar -> {input: "", avar: avar})
    , render
    , eval
    , receiver: const Nothing
    }
  where
  -- | The interface should look similar to calculator's interface
  render :: CalcState -> H.ComponentHTML Language
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
            , HH.td_ [ HH.button [HE.onClick $ HE.input_ $ Clear] [ HH.text "Clear" ] ]
            , HH.td_ [ HH.button [HE.onClick $ HE.input_ $ Submit] [ HH.text "Submit" ] ]
            ]
          ]
        ]
      ]

  numberCell numText =
    HH.td_
      [ HH.button
          [HE.onClick $ HE.input_ $ Add numText]
          [ HH.text numText ]
      ]

  -- | Change the input based on the user's button clicks
  -- | and submit the final input back to parent once done
  eval :: Language ~> H.ComponentDSL CalcState Language Msg_UserInput Aff
  eval = case _ of
    Add n next -> do
      H.modify_ (\state -> state { input = state.input <> n })
      pure next
    Clear next -> do
      H.modify_ (\s -> s { input = "" })
      pure next
    Submit next -> do
      state <- H.get
      _ <- AC.liftAff $ AVar.put state.input state.avar
      pure next
