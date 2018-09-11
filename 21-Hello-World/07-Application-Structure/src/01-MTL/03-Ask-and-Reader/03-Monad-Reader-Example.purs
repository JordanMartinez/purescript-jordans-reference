module ComputingWithMonads.MonadReader where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Reader.Class (ask, local)
import Control.Monad.Reader (Reader, runReader)

main :: Effect Unit
main = log $ runReader useSettings { editable: true, fontSize: 12 }

type Settings = { editable :: Boolean, fontSize :: Int }

                  --   r                 a
            -- ReaderT Settings Identity String
useSettings :: Reader  Settings          String
useSettings = do
  original <- ask

  output <- local
    -- a function that modifies the read-only value...
    (\settings -> settings { fontSize = 20 })
      -- which is used in only one computation
      ask

  original_ <- ask

  pure (
        "Original: " <> show original <> "\n\
        \Output of computation that uses modified value: " <> show output <> "\n\
        \Back to normal: " <> show original_
        )
