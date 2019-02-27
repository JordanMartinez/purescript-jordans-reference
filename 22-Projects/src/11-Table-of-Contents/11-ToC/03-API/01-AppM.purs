module Projects.ToC.API.AppM (AppM(..), runAppM) where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Control.Parallel (class Parallel, parTraverse)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.List (List(..), catMaybes, (:))
import Data.Maybe (Maybe(..))
import Data.Options (Options, (:=))
import Data.String.CodeUnits (length, drop)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Foreign.Object (empty, insert, singleton)
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.HTTP.Client (Response, RequestOptions, RequestHeaders(..), request, requestAsStream, statusCode, method, protocol, hostname, path, headers)
import Node.Stream (end)
import Projects.ToC.Core.Paths (PathType(..), FilePath, WebUrl)
import Projects.ToC.Domain.BusinessLogic (class LogToConsole, logInfo, class ReadPath, class WriteToFile, class VerifyLinks, Env, LogLevel)
import Type.Equality (class TypeEquals, from)

newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM
-- derive newtype instance parallelAppM :: Parallel List AppM

instance logToConsoleAppM :: LogToConsole AppM where
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

instance writeToFileAppM :: WriteToFile AppM where
  writeToFile :: String -> AppM Unit
  writeToFile content = do
    env <- ask
    liftAff do
      FS.writeTextFile UTF8 env.outputFile content

instance verifyLinksAppM :: VerifyLinks AppM where
  verifyLinks :: List WebUrl -> AppM (List WebUrl)
  verifyLinks list = do
    let prefixLength = length "https://github.com"
    let baseOpts =
          method := "GET" <>
          protocol := "https:" <>
          hostname := "github.com" <>
          headers := RequestHeaders ((insert "Keep-Alive" "timeout=4" <<< insert "Connection" "keep-alive") empty)
    liftAff $ do
      catMaybes <$> (list # parTraverse \nextLink -> do
        response <- mkRequestFromOpts $
          baseOpts <> path := (drop prefixLength nextLink)
        liftEffect $ Console.log $ "Checking link: " <> nextLink
        if (statusCode response) == 200
          then pure Nothing
          else pure $ Just nextLink
      )

mkRequestFromOpts :: Options RequestOptions -> Aff Response
mkRequestFromOpts opts = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        req <- request opts (raRF <<< Right)
        end (requestAsStream req) (pure unit)
