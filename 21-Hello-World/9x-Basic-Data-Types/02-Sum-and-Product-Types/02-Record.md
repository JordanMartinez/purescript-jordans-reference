# Record

```purescript
forall r. { a :: A, b :: B, {- ... -} | r } -- open record
          { a :: A, b :: B, {- ... -}     } -- closed record
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [prim](https://pursuit.purescript.org/builtins/docs/Prim#t:Record) | `{ field :: ValueType }` | an N-value Box

| Usage | Instances & their Usage |
| - | - |
| Stores N ordered named values of the same/different types.<br>Can be used to return or pass in multiple unnamed values from or into a function. | `{ field :: ValueType }` |
