module Learn.OptParse.GetRootDirViaAbsolutePath where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Options.Applicative (Parser, execParser, fullDesc, help, helper, info, long, metavar, progDesc, strOption)

-- Since the path to this repository will change depending on which
-- local computer runs this program, we'll ask the user to
-- pass in the absolute path to this repository via a command line argument
-- via OptParse and then run the program based on that file path.
main :: Effect Unit
main = do
  rootDir <- execParser opts

  showRootDir rootDir
  where
    showRootDir :: String -> Effect Unit
    showRootDir rootDir = do
      log "The path you chose was:"
      log rootDir

    opts = info ( helper
               <*> rootDirOption
                )
                ( fullDesc
               <> progDesc "Shows how to pass in an absolute path to this repository's\
                           \root directory via the OptParse library."
                )

    rootDirOption :: Parser String
    rootDirOption = strOption ( long "rootDir"
                             <> metavar "ROOT_DIR"
                             <> help "Indicates the root directory for this repository on a local computer."
                             )
