# Maybe

```haskell
data Maybe a
  = Nothing
  | Just a
```

| Package | Type name | "Plain English" name
| - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box

| Usage | Values' Representation
| - | -
| Indicates an optional value | <ul><li>`Nothing` - value does not exist</li><li>`Just a` - value does exist</li></ul>
| Used for error-handling when we don't care about the error (replaces `null`) | <ul><li>`Nothing` - An error occurred during computation</li><li>`Just a` - successful computation returned output.</li></ul>
