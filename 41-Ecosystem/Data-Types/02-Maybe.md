# Maybe

```purescript
data Maybe a
  = Nothing
  | Just a
```

| Package | Type name | "Plain English" name
| - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box

| Usage | values' Representation
| - | -
| Indicates an optional value | <ul><li>`Nothing` - value does not exist</li><li>`Just a` - value does exist</li></ul>
| Used for error-handling when we don't care about the error (replaces `null`) | <ul><li>`Nothing` - An error occurred during computation</li><li>`Just a` - successful computation returned output.</li></ul>
| Used in library designs to enable end-users to ignore/use values/functions | <ul><li>`Nothing` - end-user doesn't need this optional value/function</li><li>`Just a` - end-user does need the value/function, which causes some other code to run.</li></ul>
