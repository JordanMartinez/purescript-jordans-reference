{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "test/**/*.purs" ]
, name =
    "untitled"
, dependencies =
    [ "aff"
    , "arrays"
    , "console"
    , "effect"
    , "enums"
    , "exceptions"
    , "foldable-traversable"
    , "integers"
    , "maybe"
    , "partial"
    , "prelude"
    , "quickcheck"
    , "quickcheck-laws"
    , "spec"
    , "strings"
    , "tuples"
    ]
, packages =
    ../../packages.dhall
}
