let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210302/packages.dhall sha256:20cc5b89cf15433623ad6f250f112bf7a6bd82b5972363ecff4abf1febb02c50

let additions =
      { benchotron =
        { dependencies =
          [ "arrays"
          , "exists"
          , "profunctor"
          , "strings"
          , "quickcheck"
          , "lcg"
          , "transformers"
          , "foldable-traversable"
          , "exceptions"
          , "node-fs"
          , "node-buffer"
          , "node-readline"
          , "datetime"
          , "now"
          ]
        , repo = "https://github.com/JordanMartinez/purescript-benchotron.git"
        , version = "updateTo0.14"
        }
      }

in  upstream // additions
