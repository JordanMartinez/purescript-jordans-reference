{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "ignore"
, dependencies =
    [ "avar"
    , "halogen"
    , "quickcheck"
    , "integers"
    , "node-readline"
    , "random"
    , "run"
    , "variant"
    , "free"
    , "debug"
    , "psci-support"
    , "console"
    , "effect"
    , "prelude"
    , "transformers"
    , "yargs"
    , "node-fs-aff"
    , "node-buffer"
    , "node-path"
    , "node-process"
    , "node-http"
    , "st"
    , "control"
    , "string-parsers"
    , "debug"

    , "benchotron"
    , "tree"
    , "string-utils"
    ]
, packages =
    ./packages.dhall
}
