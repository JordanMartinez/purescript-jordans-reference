# Maybe

`Maybe a` is the FP solution to the problem of `null` values. It is essentially `Either Unit a`.

```haskell
data Maybe a
  = Nothing
  | Just a
```

`Maybe a` is the same as `Either unimportantType a`

| Package | Type name | "Plain English" name
| - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/) | `Maybe a` | A full or empty box

| Usage | Values' Representation
| - | -
| Indicates an optional value | <ul><li>`Nothing` - value does not exist</li><li>`Just a` - value does exist</li></ul>
| Used for error-handling when we don't care about the error (replaces `null`) | <ul><li>`Nothing` - An error occurred during computation but the error is irrelevant</li><li>`Just a` - successful computation returned output.</li></ul>

API visualized:

![Maybe API](./assets/maybe.jpg)
