let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.3-20210808/packages.dhall sha256:dbc06803c031113d3f9e001f8d95629e48da720d2bfe45d8bbe2c0cffcef293d

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
