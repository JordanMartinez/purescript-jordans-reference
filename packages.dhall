let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200724/packages.dhall sha256:bb941d30820a49345a0e88937094d2b9983d939c9fd3a46969b85ce44953d7d9

let overrides =
  { node-fs = upstream.node-fs // { repo = "https://github.com/JordanMartinez/purescript-node-fs", version = "addCopyFile"}
  , node-fs-aff = upstream.node-fs-aff // { repo = "https://github.com/JordanMartinez/purescript-node-fs-aff", version = "addCopyFile" }
  }

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
        , version = "v8.0.0"
        }
      }

in  upstream // overrides // additions
