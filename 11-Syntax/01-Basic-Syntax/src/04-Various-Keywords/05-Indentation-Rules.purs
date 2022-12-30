module Syntax.Basic.IndentationRules where

import Prelude

-- Indentation Rules:

function_normal :: String -> String
function_normal a = bodyOfFunction

-- This shows valid and invalid indentations.
-- PureScript usually indents things by 2 spaces.
function_body_indented :: String -> String
function_body_indented a = {- 
wrongIndentation -}
 validButNotConventional <>
  validAndConventional <>
   validButNotConventional <>
    validAndConventional {-
      and so forth... -}

-- Same example as above but with only using conventional indentation:
function_body_indented_conventional :: String -> String
function_body_indented_conventional a =
  validAndConventional <>
    validAndConventional

whereFunction1 :: String -> String
whereFunction1 a = validFunctionPosition1 <> validFunctionPosition2 <> validValuePosition
  -- Conventional
  where
  validFunctionPosition1 :: TypeSignature
  validFunctionPosition1 = "a"

  validFunctionPosition2 :: TypeSignature
  validFunctionPosition2 = "b"

  validValuePosition :: TypeSignature
  validValuePosition = "c"

whereFunction2 :: String -> String
whereFunction2 a = validFunctionPosition1 <> validFunctionPosition2 <> validValuePosition
  -- Haskell's convention
  where
    validFunctionPosition1 :: TypeSignature
    validFunctionPosition1 = "a"

    validFunctionPosition2 :: TypeSignature
    validFunctionPosition2 = "b"

    validValuePosition :: TypeSignature
    validValuePosition = "c"

letInFunction1 :: String -> String
letInFunction1 expression =
  -- this format makes it harder to add a new binding if more are needed
  let binding = expression
  in bodyOfFunctionThatUses binding

letInFunction2 :: String -> String
letInFunction2 expression =
  -- this format makes it easy to add a new binding
  let
    binding = expression                                                    {-
    binding2 = some other expression                                        -}
  in
    bodyOfFunctionThatUses binding

-- For more context,
-- see https://discourse.purescript.org/t/peculiar-indentation-rules-for-let-in-do-block/3192/2
--
-- The indentation of the expression for a `let` or `where` binding matters.
-- It must be at least one character to the right of the start of the binding name.
bindingExpressionIndentation1 :: String -> String
bindingExpressionIndentation1 expression =
  let binding =                                                             {-
      | the expression must be to the right of this pipe character
invalid
 invalid
   invalid
    invalid
     invalid
      invalid 
      |                                                                      -}
       valid <>
        valid <>
         valid
  in
    bodyOfFunctionThatUses binding

bindingExpressionIndentation2 :: String -> String
bindingExpressionIndentation2 expression =
  let
    binding =                                                             {-
    | the expression must be to the right of this pipe character
invalid
 invalid
   invalid
    invalid
    |                                                                      -}
     valid <>
        valid <>
         valid
  in
    bodyOfFunctionThatUses binding

-- See the `do` notation syntax for how to use `let` properly there

-- Necessary to make this file compile
type TypeSignature = String

bodyOfFunctionThatUses :: String -> String
bodyOfFunctionThatUses x = x

bodyOfFunction :: String
bodyOfFunction = ""

validAndConventional :: String
validAndConventional = ""

validButNotConventional :: String
validButNotConventional = ""

valid :: String
valid = ""
