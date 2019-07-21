{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "ignore"
, dependencies =
    [ "avar"
    , "benchotron"
    , "console"
    , "control"
    , "debug"
    , "effect"
    , "free"
    , "halogen"
    , "integers"
    , "node-buffer"
    , "node-fs-aff"
    , "node-http"
    , "node-path"
    , "node-process"
    , "node-readline"
    , "optparse"
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "random"
    , "run"
    , "st"
    , "string-parsers"
    , "stringutils"
    , "transformers"
    , "tree"
    , "unicode"
    , "variant"
    ]
, packages =
    ./packages.dhall
}
