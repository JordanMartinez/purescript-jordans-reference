{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs" ]
, name =
    "untitled"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "either"
    , "js-timers"
    , "node-readline"
    , "now"
    , "prelude"
    , "psci-support"
    , "random"
    , "refs"
    , "st"
    ]
, packages =
    ../../packages.dhall
}
