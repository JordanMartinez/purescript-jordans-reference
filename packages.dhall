let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210304/packages.dhall sha256:c88151fe7c05f05290224c9c1ae4a22905060424fb01071b691d3fe2e5bad4ca

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
