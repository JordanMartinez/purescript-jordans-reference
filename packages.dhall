let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20221229/packages.dhall
        sha256:a6af1091425f806ec0da34934bb6c0ab0ac1598620bbcbb60a7d463354e7d87c

let additions =
      { benchotron =
        { dependencies =
          [ "ansi"
          , "arrays"
          , "datetime"
          , "effect"
          , "exceptions"
          , "exists"
          , "foldable-traversable"
          , "formatters"
          , "identity"
          , "integers"
          , "js-date"
          , "lcg"
          , "lists"
          , "maybe"
          , "node-buffer"
          , "node-fs"
          , "node-process"
          , "node-readline"
          , "node-streams"
          , "now"
          , "ordered-collections"
          , "partial"
          , "prelude"
          , "profunctor"
          , "quickcheck"
          , "strings"
          , "transformers"
          , "tuples"
          , "unfoldable"
          ]
        , repo = "https://github.com/JordanMartinez/purescript-benchotron.git"
        , version = "0c5342db5caf4608e4c0eb199ec2de3cb95b7d4e"
        }
      }

in  upstream // additions
