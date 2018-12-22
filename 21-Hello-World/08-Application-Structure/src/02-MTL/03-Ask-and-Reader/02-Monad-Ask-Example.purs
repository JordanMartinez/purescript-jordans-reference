module ComputingWithMonads.MonadAsk where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Reader.Class (ask, asks)
import Control.Monad.Reader (Reader, runReader)

main :: Effect Unit
main = log $ runReader useSettings { editable: true, fontSize: 12 }

type Settings = { editable :: Boolean, fontSize :: Int }

                  --   r                 a
            -- ReaderT Settings Identity String
useSettings :: Reader  Settings          String
useSettings = do
  entireSettingsObject <- ask
  specificField <- asks (_.fontSize)

  pure ("Entire Settings Object: " <> show entireSettingsObject <> "\n\
        \Specific Field: " <> show specificField)
