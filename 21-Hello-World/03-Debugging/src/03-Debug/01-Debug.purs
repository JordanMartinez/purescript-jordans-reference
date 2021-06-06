-- When you compile this file, it will output compiler warnings.
-- If you wish to remove that noise, comment out everything below
-- the "module" declaration.
module Debugging.Debug where

-- Comment out everything below this line to prevent compiler warning.
----------------------------------------------------------------------

import Prelude
import Effect (Effect)
import Effect.Console  (log)
import Debug (spy, trace, traceM)

-- Given a simple Box Monad
data Box a = Box a
-- all type class instances are at the end of the file

-- And a way to convert a Box computation into an Effect computation
runBox :: Box ~> Effect
runBox (Box a) = pure a

boxed4 :: Box Int
boxed4 = Box 4

printAndReturnTheValue :: Int -> Int
printAndReturnTheValue x = spy "x" x

printMessageThenRunComputation :: String -> (Unit -> Int) -> Int
printMessageThenRunComputation msg x = trace msg x

-- When running this, you'll notice that the debug messages
-- are outputted in a font color different than the normal output.
main :: Effect Unit
main = do
  -- spy
  log $ show $ printAndReturnTheValue 5

  -- another way to do this
  let _ = spy "four" 4

  -- trace
  log $ show $ printMessageThenRunComputation "before computation" (\_ -> 10)

  log "Right now we are inside of the Effect monad context, \
      \which means we CAN use the `log` function here."
  value <- runBox do

    four <- boxed4
    -- now we are inside of the Box monad context,
    -- which means we CANNOT use `log` here since
    -- it returns `Effect Unit`, not `Box Unit`

    -- Instead, we'll use traceM
    traceM ("Four is: " <> show four)

    pure (four + 8)

  log $ "Value is: " <> show value

-- Box's type class instances
instance Functor Box where
  map f (Box a) = Box (f a)

instance Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance Applicative Box where
  pure a = Box a

instance Bind Box where
  bind (Box a) f = f a

instance Monad Box
