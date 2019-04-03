module Learn.Http.Syntax where

import Prelude

import Data.Either (Either(..))
import Data.Options (Options, options, (:=))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Foreign.Object (empty, insert)
import Node.HTTP.Client (RequestHeaders(..), RequestOptions, Response, request, requestAsStream, responseCookies, responseHeaders, statusCode)
import Node.HTTP.Client as Client
import Node.Stream (end)
import Unsafe.Coerce (unsafeCoerce)

main :: Effect Unit
main = launchAff_ do
  -- uses requestFromURI, which does not allow modifying its headers by the looks of it...
  printUriResponse "https://www.google.com"
  printUriResponse "https://www.github.com"
  printUriResponse "https://github.com/JordanMartinez/\
  \purescript-jordans-reference/blob/development/00-Getting-Started/ReadMe.md"

  liftEffect $ log $ "------------"

  -- uses request, which allows modification of headers
  --   (such as 'Connection: keep-alive' to speed-up response times)
  -- but requires uri to be broken up into smaller chunks
  printOptsResponse $ requestOpts "github.com" "/JordanMartinez"
  printOptsResponse $ requestOpts "google.com" ""

  where
    requestOpts domain path =
      Client.method := "GET" <>
      Client.protocol := "https:" <>
      Client.hostname := domain <>
      Client.path := path <>
      Client.headers := RequestHeaders ((insert "Keep-Alive" "timeout=4" <<< insert "Connection" "keep-alive") empty)

printUriResponse :: String -> Aff Unit
printUriResponse uri = do
  liftEffect $ log $ "Uri: " <> uri
  response <- mkRequestFromUri uri
  liftEffect do
    logResponse response

printOptsResponse :: Options RequestOptions -> Aff Unit
printOptsResponse opts = do
  liftEffect do
    log $ optsR.method <> " " <> optsR.protocol <> "//" <> optsR.hostname <> ":" <> optsR.port <> optsR.path <> ":"
  response <- mkRequestFromOpts opts
  liftEffect do
    logResponse response
  where
    optsR = unsafeCoerce $ options opts

-- | Note: this is taken from the test code in purescript-node-http
logResponse :: Response -> Effect Unit
logResponse response = void do
  log "Headers:"
  logShow $ responseHeaders response
  log "Cookies:"
  logShow $ responseCookies response
  log "Status code:"
  logShow $ statusCode response

mkRequestFromUri :: String -> Aff Response
mkRequestFromUri uri = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        request <- Client.requestFromURI uri (raRF <<< Right)
        end (Client.requestAsStream request) (pure unit)

mkRequestFromOpts :: Options RequestOptions -> Aff Response
mkRequestFromOpts opts = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        -- make the initial request
        request <- request opts (raRF <<< Right)
        -- write its response to a stream
        end (requestAsStream request) (pure unit)
