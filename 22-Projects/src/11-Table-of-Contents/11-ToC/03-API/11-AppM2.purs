module Projects.ToC.API.AppM2 (ParAppM2(..), AppM2(..), runAppM2) where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, ask, asks, runReaderT)
import Control.Parallel (class Parallel, parallel)
import Control.Parallel.Class (sequential)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Options (Options)
import Effect.Aff (Aff, ParAff, makeAff, nonCanceler)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.HTTP.Client (RequestOptions, Response, request, requestAsStream)
import Node.Stream (end)
import Projects.ToC.Core.Paths (PathType(..), FilePath, WebUrl)
import Projects.ToC.Domain.FixedLogic (class Logger, class ReadPath, class VerifyLink, class WriteToFile, Env, LogLevel)
import Type.Equality (class TypeEquals, from)

newtype AppM2 a = AppM2 (ReaderT Env Aff a)

runAppM2 :: Env -> AppM2 ~> Aff
runAppM2 env (AppM2 m) = runReaderT m env

instance monadAskAppM2 :: TypeEquals e Env => MonadAsk e AppM2 where
  ask = AppM2 $ asks from

derive newtype instance functorAppM2 :: Functor AppM2
derive newtype instance applicativeAppM2 :: Applicative AppM2
derive newtype instance applyAppM2 :: Apply AppM2
derive newtype instance bindAppM2 :: Bind AppM2
derive newtype instance monadAppM2 :: Monad AppM2
derive newtype instance monadEffectAppM2 :: MonadEffect AppM2
derive newtype instance monadAffAppM2 :: MonadAff AppM2
instance parallelAppM2 :: Parallel ParAppM2 AppM2 where
  parallel (AppM2 readerT) = ParAppM2 $ parallel readerT

  sequential (ParAppM2 readerT) = AppM2 $ sequential readerT

newtype ParAppM2 a = ParAppM2 (ReaderT Env ParAff a)

derive newtype instance functorParAppM2 :: Functor ParAppM2
derive newtype instance applyParAppM2 :: Apply ParAppM2
derive newtype instance applicativeParAppM2 :: Applicative ParAppM2

instance logToConsoleAppM2 :: Logger AppM2 where
  log :: LogLevel -> String -> AppM2 Unit
  log lvl msg =
    ifM (asks (\env -> lvl <= env.logLevel))
        (liftEffect $ Console.log msg)
        (pure unit)

instance readPathAppM2 :: ReadPath AppM2 where
  readDir :: FilePath -> AppM2 (Array FilePath)
  readDir path =
    liftAff do
      FS.readdir path

  readFile :: FilePath -> AppM2 String
  readFile path =
    liftAff do
      FS.readTextFile UTF8 path

  readPathType :: FilePath -> AppM2 (Maybe PathType)
  readPathType path =
    liftAff do
      stat <- FS.stat path
      pure $
        if Stats.isDirectory stat
          then Just Dir
        else if Stats.isFile stat
          then Just File
        else Nothing

instance writeToFileAppM2 :: WriteToFile AppM2 where
  writeToFile :: String -> AppM2 Unit
  writeToFile content = do
    env <- ask
    liftAff do
      FS.writeTextFile UTF8 env.outputFile content

instance verifyLinksAppM2 :: VerifyLink AppM2 where
  verifyLink :: WebUrl -> AppM2 Boolean
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
