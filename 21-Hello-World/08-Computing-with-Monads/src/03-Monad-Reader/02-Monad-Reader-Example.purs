module ComputingWithMonads.Example.MonadReader where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Identity (Identity(..))
import Control.Monad.Reader.Class (
    ask, asks
  , local
  )
import Control.Monad.Reader (Reader, runReader)

data Difficulty = Easy | Medium | Hard
instance s :: Show Difficulty where
  show Easy   = "Easy"
  show Medium = "Medium"
  show Hard   = "Hard"

type Settings = { editable :: Boolean, fontSize :: Int }

main :: Effect Unit
main = log $ runReader useSettings { editable: true, fontSize: 12 }

                  --   r                 a
            -- ReaderT Settings Identity String
useSettings :: Reader  Settings          String
useSettings = do
  original <- ask
  modified <- local (_ { fontSize = 20 }) ask
  original_ <- ask

  pure (
        "Original: " <> show original <> "\n\
        \Modified for one computation: " <> show modified <> "\n\
        \Back to normal: " <> show original_
        )
