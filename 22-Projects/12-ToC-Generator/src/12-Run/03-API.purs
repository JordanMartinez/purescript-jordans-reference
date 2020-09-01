module ToC.Run.API (runDomain) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Options ((:=))
import Data.String.CodeUnits (length, drop)
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Foreign.Object (insert, empty)
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.HTTP.Client (RequestHeaders(..), headers, hostname, method, path, protocol, statusCode)
import Run (Run, case_, interpret, on)
import Run.Reader (READER, runReader)
import ToC.API (ProductionEnv)
import ToC.Core.Paths (PathType(..))
import ToC.Infrastructure.Http (mkRequestFromOpts)
import ToC.Run.Domain (FILE_PARSER, FileParserF(..), LOGGER, LoggerF(..), READ_PATH, ReadPathF(..), RENDERER, RendererF(..), VERIFY_LINK, VerifyLinkF(..), WRITE_TO_FILE, WriteToFileF(..), _logger, _fileParser, _readPath, _renderer, _verifyLink, _writeToFile)
import Type.Row (type (+))

runDomain :: ProductionEnv ->
              Run ( reader :: READER ProductionEnv
                  | READ_PATH
                  + FILE_PARSER
                  + RENDERER
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
          # on _fileParser fileParserAlgebra
          # on _renderer rendererAlgebra
          # on _writeToFile writeToFileAlgebra
          # on _verifyLink verifyLinkAlgebra
          # on _logger loggerAlgebra
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

    fileParserAlgebra :: FileParserF ~> Aff
    fileParserAlgebra (ParseFile path content reply) = do
      pure $ reply $ env.parseFile path content

    rendererAlgebra :: RendererF ~> Aff
    rendererAlgebra = case _ of
      RenderFile indent url path headers reply -> do
        pure $ reply $ env.renderFile indent url path headers
      RenderDir indent path renderedChildren reply -> do
        pure $ reply $ env.renderDir indent path renderedChildren
      RenderTopLevel path renderedChildren reply -> do
        pure $ reply $ env.renderTopLevel path renderedChildren
      RenderToC allContent reply -> do
        pure $ reply $ env.renderToC allContent

    writeToFileAlgebra :: WriteToFileF ~> Aff
    writeToFileAlgebra (WriteToFile content next) = do
      FS.writeTextFile UTF8 env.outputFile content
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

    loggerAlgebra :: LoggerF ~> Aff
    loggerAlgebra (Log level msg next) = do
      when (level <= env.logLevel) do
        liftEffect $ Console.log msg
      pure next
