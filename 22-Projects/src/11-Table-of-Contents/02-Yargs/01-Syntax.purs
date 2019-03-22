module Learn.Yargs.Syntax where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)

-- This module provides an easier interface to Yargs
import Node.Yargs.Applicative (flag, yarg, runY)

-- For any bindings or custom things you need outside of the basic
-- things that the above module provides, you'll need to use
-- Node.Yargs.Setup
import Node.Yargs.Setup (example, usage, version)

-- Syntax and better names for types
type KeyNameAndDefaultArgumentName = String
type KeyAlias = String
type Description = String
type DefaultValue = Unit
type ErrorMessageIfRequired = String
type Required = Boolean

newtype Y_ a = Y_ a   -- simiulates "Y" type in Node.Yargs.Applicative module

-- main function to use to
yarg_ :: KeyNameAndDefaultArgumentName ->
         Array KeyAlias ->
         Maybe Description ->
         Either DefaultValue ErrorMessageIfRequired ->
         Required ->
         Y_ String
yarg_ _ _ _ _ _ = Y_ "returned value"

-- same as "yarg" but specifies some of the types for you
flag_ :: KeyNameAndDefaultArgumentName ->
         Array KeyAlias ->
         Maybe Description ->
         Boolean
flag_ _ _ _ = true

{-
Run the following code using this command to see the difference:
- Shows what error message / help looks like:
    $> spago bundle -m Learn.Yargs -t dist/table-of-contents/learnYargs.js
    $> node dist/table-of-contents/learnYargs.js
- Shows what actual 'program' using values looks like
    $> spago bundle -m Learn.Yargs -t dist/table-of-contents/learnYargs.js
    $> node dist/table-of-contents/learnYargs.js -c "test" -d "test"       -}
main :: Effect Unit
main = do
  -- Note: only one example works at a time. So, if you copied the below code,
  -- modified it slightly, and tried running it after the
  -- 'syntaxAndArgsExplained' code, it will not work.
  syntaxAndArgsExplained

syntaxAndArgsExplained :: Effect Unit
syntaxAndArgsExplained = do
  -- These commands come from the Node.Yargs.Setup module
  -- to combine them, use Semigroup's append/<>
  let onlySetupAndUsage =
              usage "This line appears at the top of the program's output.\n\
                     \use it to explain what your CLI program does.\n\n\
                     \'$0' is a special character sequence that will be replaced\
                     \ by the command name."
           <> version "version" "prints the version to the screen" "v0.2.1"
           <> example "Provides an example of the command." "An explanation of what that command does."
           <> example "program -arg value -arg2 value2." "Runs a program by passing in two values."

  -- These commands come from the Node.Yargs.Applicative module
  -- It provides a better interface for the Node.Yargs.Setup module functions
  -- but does not cover everything. It's only used for simple CLI arguments
  runY onlySetupAndUsage $ applicationWhichTakes6Args
    <$> yarg "keyName" ["alias1", "alias2"]
          (Just "A description of what the command does")
          (Left "Default value if none is given. Note: this argument does not take an associated value.")
          false -- this parameter does not require an argument / associated value
    <*> flag "x" ["scare"] (Just "'x' does some stuff")
    <*> flag "t" ["try-again"] (Just "'t' does some stuff")
    <*> yarg "keyName2" ["singleAlias"]
          Nothing -- no description given for what command does. Thus, it will not appear in the list of commands.
          (Left "If you see this, you did not specify anything here...")
          false -- this parameter does not require an argument / associated value
    <*> yarg "c" ["create"]
          (Just "notice how this single-letter keyname uses only one '-' instead of '--' before the keyname")
          (Right "This error message is displayed on the screen when this required argument is not specified.")
          true -- this parameter requires an argument / associated value
    <*> yarg "d" ["delete"]
          (Just "A description of what the command does")
          (Right "You need to include the 'keyName4' argument to make this program run!")
          true -- this parameter requires an argument / associated value

  where
  -- In real CLI programs, this is how we'd setup the environment values for
  -- our program before running the business logic via ReaderT/Free/Run
  applicationWhichTakes6Args :: String -> Boolean -> Boolean -> String -> String -> String -> Effect Unit
  applicationWhichTakes6Args keyName x t keyName2 c d = log $
    "keyName: " <> keyName <> "\n\
    \x: " <> show x <> "\n\
    \t: " <> show t <> "\n\
    \keyname2: " <> keyName2 <> "\n\
    \c: " <> c <> "\n\
    \d: " <> d
