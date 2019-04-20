{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
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
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "random"
    , "run"
    , "st"
    , "string-parsers"
    , "string-utils"
    , "transformers"
    , "tree"
    , "unicode"
    , "variant"
    , "yargs"
    ]
, packages =
    ./packages.dhall
}
