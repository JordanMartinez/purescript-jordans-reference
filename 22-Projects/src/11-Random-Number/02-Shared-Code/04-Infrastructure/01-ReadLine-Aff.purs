module RandomNumber.Infrastructure.ReadLineAff (question) where

import Prelude
import Data.Either (Either(..))
import Effect.Aff (Aff, makeAff)
import Node.ReadLine (Interface)
import Node.ReadLine as NR

question :: Interface -> String -> Aff String
question interface message = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty
