# Type Directed Search

If you recall in `Syntax/Basic Syntax/src/Data-and-Functions/Type-Directed-Search.md`, we can use type-directed search to
1. help us determine what an entity's type is
2. guide us in how to implement something
3. see better ways to code something via type classes

As an example, let's say we have a really complicated function or type
```purescript
main :: Effect Unit
main = do
  a <- computeA
  b <- computeB
  c <- (\a -> (\c -> doX c) <$> box a) <$> (Box 5) <*> (Box 8)
```
If we want to know what the type will be for `doX`, we can rewrite this function to below and see what the compiler outputs:
```purescript
main :: Effect Unit
main = do
  a <- computeA
  b <- computeB
  c <- (\a -> (\c -> ?doX c) <$> box a) <$> (Box 5) <*> (Box 8)
```
If we're not sure what type a function outputs, we can precede the function with our search using `?name $ function`:
```purescript
main :: Effect Unit
main = do
  a <- computeA
  b <- computeB
  c <- (\a -> (\c -> ?help $ doX c) <$> box a) <$> (Box 5) <*> (Box 8)
```

If you encounter a problem or need help, this should be one of the first things you use.

## Getting the Type from the Compiler

This tip comes from cvlad on the Slack channel (I've edited his response below for clarity):
> If you want the type of `something`, a good trick is to assert its type to something random like `Unit`. For example, you could write: `(log "hola") :: Unit`. The compiler will give you an error such as, "Cannot unify `Unit` with `_`", where `_` will be the type of the expression.
