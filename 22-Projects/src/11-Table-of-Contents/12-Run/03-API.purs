module ToC.Run.API (runDomain) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Data.String.CodeUnits (length, drop)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Foreign.Object (insert, empty)
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.HTTP.Client (RequestHeaders(..), RequestOptions, Response, headers, hostname, method, path, protocol, request, requestAsStream, statusCode)
import Node.Stream (end)
import Run (Run, case_, interpret, on)
import Run.Reader (READER, runReader)
import ToC.Core.Paths (PathType(..), FilePath)
import ToC.Domain.Types (Env, LogLevel)
import ToC.Run.Domain (ReadPathF(..), _readPath, READ_PATH, WriteToFileF(..), _writeToFile, WRITE_TO_FILE, LoggerF(..), _logger, LOGGER, VerifyLinkF(..), _verifyLink, VERIFY_LINK)
import Type.Row (type (+))

runDomain :: Env ->
              Run ( reader :: READER Env
                  | READ_PATH
                  + WRITE_TO_FILE
                  + VERIFY_LINK
                  + LOGGER
                  + ()
                  )
              ~> Aff
runDomain env program =
  program
    -- use "runX" for MTL effects
    # runReader env

    -- use "interpret" and "case_" for capabilities
    # interpret (
        case_
          # on _readPath readPathAlgebra
          # on _writeToFile (writeToFileAlgebra env.outputFile)
          # on _verifyLink verifyLinkAlgebra
          # on _logger (loggerAlgebra env.logLevel)
      )

  where
    readPathAlgebra :: ReadPathF ~> Aff
    readPathAlgebra = case _ of
      ReadDir path reply -> do
        children <- FS.readdir path
        pure (reply children)
      ReadFile path reply -> do
        content <- FS.readTextFile UTF8 path
        pure (reply content)
      ReadPathType path reply -> do
        stat <- FS.stat path
        pure $ reply $
          if Stats.isDirectory stat
            then Just Dir
          else if Stats.isFile stat
            then Just File
          else Nothing

    writeToFileAlgebra :: FilePath -> WriteToFileF ~> Aff
    writeToFileAlgebra outputFile (WriteToFile content next) = do
      FS.writeTextFile UTF8 outputFile content
      pure next

    verifyLinkAlgebra :: VerifyLinkF ~> Aff
    verifyLinkAlgebra (VerifyLink url reply) = do
      let prefixLength = length "https://github.com"
      let baseOpts =
            method := "GET" <>
            protocol := "https:" <>
            hostname := "github.com" <>
            headers := RequestHeaders ((insert "Keep-Alive" "timeout=4" <<< insert "Connection" "keep-alive") empty)
      response <- liftAff $ mkRequestFromOpts $
        baseOpts <> path := (drop prefixLength url)
      pure $ reply $ (statusCode response) == 200

    loggerAlgebra :: LogLevel -> LoggerF ~> Aff
    loggerAlgebra envLvl (Log level msg next) = do
      when (level <= envLvl) do
        liftEffect $ Console.log msg
      pure next

mkRequestFromOpts :: Options RequestOptions -> Aff Response
mkRequestFromOpts opts = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        req <- request opts (raRF <<< Right)
        end (requestAsStream req) (pure unit)
