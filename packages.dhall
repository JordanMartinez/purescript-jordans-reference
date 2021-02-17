let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/prepare-0.14/src/packages.dhall

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

in  (upstream // additions)
      with metadata = upstream.metadata // { version = "v0.14.0-rc5" }
      with variant =
        { repo = "https://github.com/jordanmartinez/purescript-variant.git"
        , version = "updateTo0.14"
        , dependencies =
          ["prelude", "tuples", "unsafe-coerce", "partial", "maybe", "lists", "record", "enums"]
        }
      with benchotron =
        { repo = "https://github.com/jordanmartinez/purescript-benchotron.git"
        , version = "updateTo0.14"
        , dependencies = upstream.benchotron.dependencies
        }
      with spec.dependencies =
        ["exceptions", "console", "fork", "now", "aff", "foldable-traversable", "avar", "prelude", "pipes", "asni", "transformers", "strings"]
