module ComputingWithMonads.MonadCont where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Cont.Trans (ContT(..), runContT)

-- The sum type example we mentioned beforehand got long
-- and introduces a lot of noise. So, we'll do a very simple
-- example using Effect and `log` instead.
main :: Effect Unit
main = do
  runContT (exampleCallCC 5) log
  log "\n\n"
  runContT (exampleCallCC 20) (\s -> do
    log $ "Indenting the string"
    log $ "\t\t" <> s
    )

exampleCallCC :: Int -> ContT Unit Effect String
exampleCallCC arg = ContT $ \k -> do
  log "do some computations here..."
  k $ "callback with arg: " <> show arg
  log "do some other computations here..."
  k $ "callback with arg: " <> show 1.5
  log "do some other computations here..."
