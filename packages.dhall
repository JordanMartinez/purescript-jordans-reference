let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.0-20220503/packages.dhall
        sha256:847d49acea4803c3d42ef46114053561e91840e35ede29f0a8014d09d47cd8df

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
        , version = "update-to-0.15"
        }
      }

in  upstream // additions
