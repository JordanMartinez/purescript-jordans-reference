{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs" ]
, name =
    "library-guides"
, dependencies =
    [ "console"
    , "effect"
    , "integers"
    , "node-fs-aff"
    , "node-http"
    , "node-path"
    , "node-readline"
    , "optparse"
    , "parallel"
    , "prelude"
    , "psci-support"
    , "random"
    , "st"
    , "string-parsers"
    , "stringutils"
    , "transformers"
    , "tree-rose"
    , "unicode"
    ]
, packages =
    ../../packages.dhall
}
