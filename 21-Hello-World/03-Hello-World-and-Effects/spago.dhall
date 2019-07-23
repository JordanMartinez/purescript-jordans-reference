{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "untitled"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "js-timers"
    , "node-readline"
    , "now"
    , "prelude"
    , "psci-support"
    , "random"
    ]
, packages =
    ./packages.dhall
}
