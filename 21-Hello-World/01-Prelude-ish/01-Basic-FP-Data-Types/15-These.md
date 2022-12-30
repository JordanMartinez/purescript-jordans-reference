# These

One type for combining `Either` and `Tuple`. Stores the same information as `Either a (Either b (Tuple a b))`. See [purescript-these](https://pursuit.purescript.org/packages/purescript-these/).

```haskell
data These a b
  = This a      -- Left  a
  | That b      -- Right b
  | Both a b    -- Tuple a b
```
