let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/9f4d289897cdb16e193097b1cb009714366cebe2/src/packages.dhall

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

in  (upstream // additions)
      with variant =
        { repo = "https://github.com/jordanmartinez/purescript-variant.git"
        , version = "updateTo0.14"
        , dependencies =
          ["prelude", "tuples", "unsafe-coerce", "partial", "maybe", "lists", "record", "enums"]
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
