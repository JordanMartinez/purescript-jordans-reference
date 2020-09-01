module ToC.Infrastructure.Http (mkRequestFromOpts) where

import Prelude

import Data.Either (Either(..))
import Data.Options (Options)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Node.HTTP.Client (RequestOptions, Response, request, requestAsStream)
import Node.Stream (end)


mkRequestFromOpts :: Options RequestOptions -> Aff Response
mkRequestFromOpts opts = makeAff go
  where
  go :: _
  go raRF = nonCanceler <$ do
        req <- request opts (raRF <<< Right)
        end (requestAsStream req) (pure unit)
