{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources = [ "src/**/*.purs" ]
, name = "untitled"
, dependencies =
  [ "newtype"
  , "partial"
  , "prelude"
  , "unsafe-coerce"
  , "safe-coerce"
  ]
, packages = ../../packages.dhall
}
