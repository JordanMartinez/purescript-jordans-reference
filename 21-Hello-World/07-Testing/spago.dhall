{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "test/**/*.purs" ]
, name =
    "untitled"
, dependencies =
    [ "console"
    , "effect"
    , "newtype"
    , "prelude"
    , "psci-support"
    , "quickcheck"
    , "quickcheck-laws"
    , "spec"
    , "strings"
    ]
, packages =
    ./packages.dhall
}
