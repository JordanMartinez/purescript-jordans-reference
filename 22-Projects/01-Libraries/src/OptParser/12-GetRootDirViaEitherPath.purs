module Learn.OptParse.GetRootDirViaEitherPath where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.Globals (__dirname)
import Node.Path (FilePath, normalize, sep)
import Options.Applicative (Parser, execParser, fullDesc, help, helper, info, long, metavar, progDesc, short, strOption, switch)

-- The previous file's code works, but using an absolute path is rather verbose.
-- What if we could decide to pass in a relative path based on where we
-- start the program?
main :: Effect Unit
main = do
    rec <- execParser opts
    runApp rec
  where
    opts = info ( helper
               <*> argParser
                )
                ( fullDesc
               <> progDesc "Shows how to pass in either an absolute or relative path \
                           \to this repository's root directory via the OptParse library."
                )

    argParser :: Parser { useRelativePath :: Boolean, pathToDir :: FilePath }
    argParser = ado
      useRelative <- switch ( long "use-relative-path"
                           <> short 'r'
                           <> help "Indicates that the 'rootdir' argument is a relative path."
                            )
      dir <- strOption ( long "rootdir"
                      <> metavar "DIR"
                      <> help "Indicates the root directory for this repository on a local computer."
                       )

      in { useRelativePath: useRelative, pathToDir: dir }

    runApp :: { useRelativePath :: Boolean, pathToDir :: FilePath } -> Effect Unit
    runApp rec = do
      log "The path you chose was:"
      if rec.useRelativePath
        then
          -- Combine the name of the directory from which this program was run
          -- with the passed-in relative path, inserting the OS-specific
          -- file separator character in-between the two.
          --
          -- Then, normalize the path, so that "." and ".." are 'solved'
          log $ normalize (__dirname <> sep <> rec.pathToDir)
        else
          -- Otherwise, assume that path is an absolute path and just print it.
          log rec.pathToDir
