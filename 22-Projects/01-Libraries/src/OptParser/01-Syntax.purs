module Learn.OptParse where


import Prelude

import Data.Foldable (fold)
import Effect (Effect)
import Effect.Console (logShow)
import ExitCodes (ExitCode(..))
import Options.Applicative (Parser, execParser, failureCode, flag, footer, fullDesc, header, help, helper, info, int, long, metavar, number, option, progDesc, short, showDefault, showDefaultWith, str, strOption, switch, value)

type Sample =
  { text1 :: String
  , text2 :: String
  , text3 :: String
  , flag :: String
  , someBool :: Boolean
  , someInt :: Int
  , someNumber :: Number
  }

main :: Effect Unit
main = do
    sampleValue <- execParser opts
    logShow sampleValue
  where
    opts = info (  helper  -- adds the `--help` option (this should probably
                           -- always be included)
               <*> sample2 -- our command line parser
                )
            ( fullDesc -- `fullDesc` shows all help text whereas
                       -- `briefDesc` shows only help text of those that
                       -- do not have the `hidden` modifier
           <> header "A message that only appears when the '--help' \
                     \flag is present. It appears above everything else."
           <> progDesc "Explains what the program does. Appears below the \
                       \usage summary of the program"
           <> footer "A message that only appears when the '--help' \
                     \flag is present. It appears below everything else."
           <> failureCode Error -- if the parser fails, it will exit with this code
           )

sample2 :: Parser Sample
sample2 = ado
  -- we'll show all options using String values first
  helloText <- strOption ( long "long-name" -- hyphens need to be included between words
                                            -- if this was `long words`, you'd have a problem
                        <> short 'l' -- single character alias
                        <> metavar "APPEARS_AFTERWARDS_IN_HELP_TEXT"
                        <> help "Explains what the option does"

                        <> value "Default value when none is specified otherwise. \
                                 \If this did not appear, the command would be \
                                 \required."

                        -- When a default value is specified, one can display
                        -- what it is in the help text for the corresponding
                        -- option. There are two ways to do that.
                        -- We'll show the first way here and the second way
                        -- in the next option
                        --  1) showDefault - use the type's Show instance
                        <> showDefault
                         )
  otherText <- strOption ( long "long-name2"
                        <> help "Shows how 'showDefaultWith' works"
                        <> value "Default value"
                        -- The second way to render the default value
                        -- to the console is via
                        --  2) showDefaultWith - manually convert the value
                        --                       into a String
                        <> showDefaultWith (\str -> str <> ", duh!")
                         )
  thirdText <- option str ( long "long-name3"
                         <> help "shows that `strOption` is an abbreviation for \
                                 \`option str`"
                         -- no default value specified here
                         -- this option requires an argument to be given to it
                          )

  -- Now that we have an idea for how this works,
  -- we can show the other values we can parse
  -- Also, since each modifier is a Monoid, we can use
  -- `fold [ mod1, mod2, mod3 ]` instead of `( mod1 <> mod2 <> mod3 )`
  someValue <- flag "value when flag is not present" "value when flag is present"
                $ fold [ long "flag-name"
                       , short 'f'
                       , help "Shows what occurs when the flag is and is not present"
                       ]
  booleanValue <- switch $ fold
                    [ long "switch"
                    , short 's'
                    , help "Shows what occurs when the flag is and is not present"
                    ]
  intValue <- option int $ fold
                    [ long "int-name"
                    , short 'i'
                    , help "An option that provides an integer value."
                    , value 4
                    , showDefault
                    ]
  numberValue <- option number $ fold
                    [ long "number-name"
                    , short 'n'
                    , help "An option that provides a number value."
                    , value 4.0
                    , showDefault
                    ]
  in { text1: helloText
     , text2: otherText
     , text3: thirdText
     , flag: someValue
     , someBool: booleanValue
     , someInt: intValue
     , someNumber: numberValue
     }
