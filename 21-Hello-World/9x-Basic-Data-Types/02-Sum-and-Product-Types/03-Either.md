# Either

```purescript
data Either a b
  = Left a
  | Right b
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types

| Usage | Instances & their Usage
| - | - |
| Used to indicate one type or another | <ul><li>`Left a` - an instance of `a`</li><li>`Right b` - an instance of `b`</li></ul>
| Error handing (when we care about the error) | <ul><li>`Left a` - the error type that is returned when a computation fails</li><li>`Right b` - the output type when a computation succeeds</li></ul>
