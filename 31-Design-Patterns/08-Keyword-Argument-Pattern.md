# Keyword Argument Pattern

This is used in a number of libraries throughout PureScript. For example:
- Halogen's `H.defaultEval` value
- node-child-process's `pipe` value
- Affjax's `defaultRequest` value

The basic idea is that the library author provides a record that stores default values that do nothing, so that end-users can override only the values they need in a record update:
```purescript
-- Library author writes this...

type Options =
  { directory :: String
  , port :: Int
  , logLevel :: LogLevel
  }

defaultOptions :: Options
defaultOptions =
  { directory: "."
  , port: 8080
  , logLevel: Error
  }

-- User overrides where they need it
foo :: Effect Unit
foo = do
  doSomethingWith $ defaultOptions { port = 2020 }
  doSomethingWith $ defaultOptions { directory = "app/", logLevel: Warn }
```

See [Superpowered keyword args in Haskell - Ben Kovach](https://www.kovach.me/Superpowered_keyword_args_in_Haskell.html)
