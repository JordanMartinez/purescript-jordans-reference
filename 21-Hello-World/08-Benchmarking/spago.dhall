{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "benchmark/**/*.purs" ]
, name =
    "ignore"
, dependencies =
    [ "prelude"
    , "effect"
    , "foldable-traversable"
    , "newtype"
    , "quickcheck"
    , "benchotron"
    ]
, packages =
    ../../packages.dhall
}
