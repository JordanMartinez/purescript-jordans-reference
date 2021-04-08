let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210406/packages.dhall sha256:7b6af643c2f61d936878f58b613fade6f3cb39f2b4a310f6095784c7b5285879

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
