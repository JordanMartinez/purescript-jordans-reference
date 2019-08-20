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
    , "debug"
    , "effect"
    , "either"
    , "node-readline"
    , "partial"
    , "prelude"
    , "psci-support"
    , "random"
    , "refs"
    , "st"
    , "typelevel-prelude"
    ]
, packages =
    ./packages.dhall
}
