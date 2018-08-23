module ModuleFunctionAliases
  (function, (/=), (===), (>>**>>))
  where

function :: String -> String
function x = "some value"

infixl 0 function as /=

infixr 4 function as ===

infix 9 function as >>**>>
