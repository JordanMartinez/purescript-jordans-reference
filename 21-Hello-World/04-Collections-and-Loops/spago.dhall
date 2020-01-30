{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "filterable"
    , "foldable-traversable"
    , "psci-support"
    , "unfoldable"
    ]
, packages = ../../packages.dhall
, sources = [ "src/**/*.purs" ]
}
