module Syntax.Basic.IndentationRules where

import Prelude

-- Indentation Rules:

function_normal :: String -> String
function_normal a = bodyOfFunction

function_body_indented :: String -> String
function_body_indented a = {- this shows valid and invalid indentation:
wrongIndentation -}
  validAndConventional <>
    validButNotConventional {-
      and so forth... -}

whereFunction1 :: String -> String
whereFunction1 a = validFunctionPosition1 <> validFunctionPosition2 <> validValuePosition
  where
  validFunctionPosition1 :: TypeSignature
  validFunctionPosition1 = "a"

  validFunctionPosition2 :: TypeSignature
  validFunctionPosition2 = "b"

  validValuePosition :: TypeSignature
  validValuePosition = "c"

whereFunction2 :: String -> String
whereFunction2 a = validFunctionPosition1 <> validFunctionPosition2 <> validValuePosition
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
