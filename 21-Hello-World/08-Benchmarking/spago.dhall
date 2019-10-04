{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "benchmark/**/*.purs" ]
, name =
    "ignore"
, dependencies =
    [ "console"
    , "prelude"
    , "effect"
    , "psci-support"
    , "quickcheck"
    , "benchotron"
    ]
, packages =
    ../../packages.dhall
}
