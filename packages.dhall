let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0/packages.dhall sha256:710b53c085a18aa1263474659daa0ae15b7a4f453158c4f60ab448a6b3ed494e

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
      , run =
        { dependencies =
          [ "aff"
          , "console"
          , "control"
          , "effect"
          , "either"
          , "free"
          , "identity"
          , "maybe"
          , "minibench"
          , "newtype"
          , "prelude"
          , "profunctor"
          , "psci-support"
          , "tailrec"
          , "tuples"
          , "type-equality"
          , "unsafe-coerce"
          , "variant"
          ]
        , repo = "https://github.com/natefaubion/purescript-run"
        , version = "master"
        }
      }

in  (upstream // additions)
  with variant =
    { repo = "https://github.com/jordanmartinez/purescript-variant.git"
    , version = "updateTo0.14"
    , dependencies =
      [ "prelude"
      , "tuples"
      , "unsafe-coerce"
      , "partial"
      , "maybe"
      , "lists"
      , "record"
      , "enums"
      ]
    }
  with spec =
    { repo = "https://github.com/fsoikin/purescript-spec.git"
    , version = "purescript-0.14"
    , dependencies =
      [ "avar"
      , "console"
      , "aff"
      , "exceptions"
      , "strings"
      , "prelude"
      , "transformers"
      , "foldable-traversable"
      , "pipes"
      , "ansi"
      , "fork"
      , "now"
      ]
    }
