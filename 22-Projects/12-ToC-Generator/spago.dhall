{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "toc-generator"
, dependencies =
    [ "benchotron"
    , "console"
    , "control"
    , "debug"
    , "effect"
    , "node-fs-aff"
    , "node-http"
    , "node-path"
    , "node-readline"
    , "optparse"
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "run"
    , "st"
    , "string-parsers"
    , "stringutils"
    , "transformers"
    , "tree-rose"
    , "unicode"
    , "variant"
    ]
, packages =
    ../../packages.dhall
}
