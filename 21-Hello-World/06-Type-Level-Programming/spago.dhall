{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs" ]
, name =
    "untitled"
, dependencies =
    [ "console"
    , "effect"
    , "prelude"
    , "psci-support"
    , "tuples"
    , "typelevel-prelude"
    ]
, packages =
    ./packages.dhall
}
