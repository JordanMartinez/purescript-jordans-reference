module Games.RandomNumber.API (API_F(..)) where

import Games.RandomNumber.Core (Bounds)

data API_F a
  = Log String a
  | GetUserInput String (String -> a)
  | GenRandomInt Bounds (Int -> a)
