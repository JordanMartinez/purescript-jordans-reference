module ToC.ReaderT.API (AppM(..), runAppM) where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Options ((:=))
import Data.String.CodeUnits (length, drop)
import Data.Tree (Tree)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Foreign.Object (insert, empty)
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.HTTP.Client (RequestHeaders(..), headers, hostname, method, path, protocol, statusCode)
import ToC.Core.Paths (PathType(..), FilePath, WebUrl)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.Domain.Types (LogLevel)
import ToC.API (ProductionEnv)
import ToC.Infrastructure.Http (mkRequestFromOpts)
import ToC.ReaderT.Domain (class Logger, class ReadPath, class VerifyLink, class WriteToFile, class FileParser, class Renderer)
import Type.Equality (class TypeEquals, from)


newtype AppM a = AppM (ReaderT ProductionEnv Aff a)

runAppM :: ProductionEnv -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

instance monadAskAppM :: TypeEquals e ProductionEnv => MonadAsk e AppM where
  ask = AppM $ asks from

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

instance logToConsoleAppM :: Logger AppM where
  log :: LogLevel -> String -> AppM Unit
  log lvl msg =
    ifM (asks (\env -> lvl <= env.logLevel))
        (liftEffect $ Console.log msg)
        (pure unit)

instance readPathAppM :: ReadPath AppM where
  readDir :: FilePath -> AppM (Array FilePath)
  readDir path =
    liftAff do
      FS.readdir path

  readFile :: FilePath -> AppM String
  readFile path =
    liftAff do
      FS.readTextFile UTF8 path

  readPathType :: FilePath -> AppM (Maybe PathType)
  readPathType path =
    liftAff do
      stat <- FS.stat path
      pure $
        if Stats.isDirectory stat
          then Just Dir
        else if Stats.isFile stat
          then Just File
        else Nothing

instance parseFileAppM :: FileParser AppM where
  parseFile :: FilePath -> String -> AppM (List (Tree HeaderInfo))
  parseFile path content =
    asks (\e -> e.parseFile path content)

instance rendererAppM :: Renderer AppM where
  renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> AppM String
  renderFile indent url path headers =
    asks (\e -> e.renderFile indent url path headers)

  renderDir :: Int -> FilePath -> Array String -> AppM String
  renderDir indent path childrenContent =
    asks (\e -> e.renderDir indent path childrenContent)

  renderTopLevel :: FilePath -> Array String -> AppM TopLevelContent
  renderTopLevel path childrenContent =
    asks (\e -> e.renderTopLevel path childrenContent)

  renderToC :: Array TopLevelContent -> AppM String
  renderToC allContent =
    asks (\e -> e.renderToC allContent)

instance writeToFileAppM :: WriteToFile AppM where
  writeToFile :: String -> AppM Unit
  writeToFile content = do
    env <- ask
    liftAff do
      FS.writeTextFile UTF8 env.outputFile content

instance verifyLinksAppM :: VerifyLink AppM where
  verifyLink :: WebUrl -> AppM Boolean
  -- uncomment this when wish to disable the URL checking temporarily
  -- verifyLink _ = do
  --   pure true
  verifyLink url = do
    let prefixLength = length "https://github.com"
    let baseOpts =
          method := "GET" <>
          protocol := "https:" <>
          hostname := "github.com" <>
          headers := RequestHeaders ((insert "Keep-Alive" "timeout=4" <<< insert "Connection" "keep-alive") empty)
    response <- liftAff $ mkRequestFromOpts $
      baseOpts <> path := (drop prefixLength url)
    pure $ (statusCode response) == 200
