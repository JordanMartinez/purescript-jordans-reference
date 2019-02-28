module Projects.ToC.API.AppMAgain (AppM_Again(..), runAppM_Again) where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Control.Parallel (class Parallel, parTraverse, parallel)
import Control.Parallel.Class (sequential)
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
import Projects.ToC.Domain.FixedLogic (class Logger, logInfo, class ReadPath, class WriteToFile, class VerifyLink, Env, LogLevel)
import Type.Equality (class TypeEquals, from)

newtype AppM_Again a = AppM_Again (ReaderT Env Aff a)

runAppM_Again :: Env -> AppM_Again ~> Aff
runAppM_Again env (AppM_Again m) = runReaderT m env

instance monadAskAppM_Again :: TypeEquals e Env => MonadAsk e AppM_Again where
  ask = AppM_Again $ asks from

derive newtype instance functorAppM_Again :: Functor AppM_Again
derive newtype instance applicativeAppM_Again :: Applicative AppM_Again
derive newtype instance applyAppM_Again :: Apply AppM_Again
derive newtype instance bindAppM_Again :: Bind AppM_Again
derive newtype instance monadAppM_Again :: Monad AppM_Again
derive newtype instance monadEffectAppM_Again :: MonadEffect AppM_Again
derive newtype instance monadAffAppM_Again :: MonadAff AppM_Again

-- TODO: I'll need to ask someone for help on how to properly
-- implement a Parallel instance for `AppM_Again`
-- derive newtype instance p :: Parallel (ReaderT e Aff) AppM_Again
-- instance parallelAppM_Again :: TypeEquals e Env => Parallel (ReaderT e Aff) AppM_Again where
  -- parallel :: AppM_Again ~> _
  -- parallel (AppM_Again readerT) = parallel readerT
  --
  -- sequential :: _ ~> AppM_Again
  -- sequential = AppM_Again <<< sequential

instance logToConsoleAppM_Again :: Logger AppM_Again where
  log :: LogLevel -> String -> AppM_Again Unit
  log lvl msg =
    ifM (asks (\env -> lvl <= env.logLevel))
        (liftEffect $ Console.log msg)
        (pure unit)

instance readPathAppM_Again :: ReadPath AppM_Again where
  readDir :: FilePath -> AppM_Again (Array FilePath)
  readDir path =
    liftAff do
      FS.readdir path

  readFile :: FilePath -> AppM_Again String
  readFile path =
    liftAff do
      FS.readTextFile UTF8 path

  readPathType :: FilePath -> AppM_Again (Maybe PathType)
  readPathType path =
    liftAff do
      stat <- FS.stat path
      pure $
        if Stats.isDirectory stat
          then Just Dir
        else if Stats.isFile stat
          then Just File
        else Nothing

instance writeToFileAppM_Again :: WriteToFile AppM_Again where
  writeToFile :: String -> AppM_Again Unit
  writeToFile content = do
    env <- ask
    liftAff do
      FS.writeTextFile UTF8 env.outputFile content

instance verifyLinksAppM_Again :: VerifyLink AppM_Again where
  verifyLink :: WebUrl -> AppM_Again Boolean
  verifyLink _ = pure true
    -- let prefixLength = length "https://github.com"
    -- let baseOpts =
    --       method := "GET" <>
    --       protocol := "https:" <>
    --       hostname := "github.com" <>
    --       headers := RequestHeaders ((insert "Keep-Alive" "timeout=4" <<< insert "Connection" "keep-alive") empty)
    -- response <- liftAff $ mkRequestFromOpts $
    --   baseOpts <> path := (drop prefixLength nextLink)
    -- pure $ (statusCode response) == 200

mkRequestFromOpts :: Options RequestOptions -> Aff Response
mkRequestFromOpts opts = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        req <- request opts (raRF <<< Right)
        end (requestAsStream req) (pure unit)
