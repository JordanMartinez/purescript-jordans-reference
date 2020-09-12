module ToC.API (AppM(..), runAppM) where

import Prelude

import Control.Monad.Reader.Trans (class MonadAsk, ReaderT, asks, runReaderT)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import ToC.Core.Paths (PathType(..), FilePath, PathRec, parentPath, fullPath)
import ToC.Core.Env (ProductionEnv, LogLevel)
import ToC.Domain (class Logger, class ReadPath, class WriteToFile, class Renderer, readFile, writeToFile, mkDir)
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

  exists :: FilePath -> AppM Boolean
  exists path =
    liftAff do
      FS.exists path

instance rendererAppM :: Renderer AppM where
  renderFile :: Int -> FilePath -> PathRec -> AppM String
  renderFile indent linkText urlPathRec =
    asks (\e -> e.renderFile indent linkText urlPathRec)

instance writeToFileAppM :: WriteToFile AppM where
  writeToFile :: FilePath -> String -> AppM Unit
  writeToFile filePath content = do
    liftAff do
      FS.writeTextFile UTF8 filePath content

  copyFile :: PathRec -> PathRec -> AppM Unit
  copyFile fromRec toRec = do
    mkDir (parentPath toRec)

    -- really inefficient, but gets the job done due to FFI lacking in
    -- corresponding repo...
    content <- readFile (fullPath fromRec)
    writeToFile (fullPath toRec) content

  mkDir :: FilePath -> AppM Unit
  mkDir filePath = do
    liftAff do
      FS.mkdirRecursive filePath
