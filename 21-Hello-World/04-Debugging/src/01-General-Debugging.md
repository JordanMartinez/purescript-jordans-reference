# General Debugging

The following sections are tips for debugging issues that may arise in a strongly-typed language via the compiler.

## Type Directed Search

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

## Getting the Type of an Expression from the Compiler

This tip comes from cvlad on the Slack channel (I've edited his response below for clarity):
> If you want the type of `something`, a good trick is to assert its type to something random like `Unit`. For example, you could write: `(log "hola") :: Unit`. The compiler will give you an error such as, "Cannot unify `Unit` with `_`", where `_` will be the type of the expression.

## Getting the Type of a Function from the Compiler

There are two possible situations where this idea might help:
- You know how to write the body for a function but aren't sure what it's type signature is
- You're exploring a new unfamiliar library and are still figuring out how to piece things together. So, you attempt to write the body of a function but aren't sure what it's type signature will be.

In such cases, we can completely omit the type signature and the compiler will usually infer what it is for us:
```purescript
-- The following code is completely made up

-- no type signature here, so the compiler will output a warning
-- stating what it inferred it to be
doSomething x y = runK $ repeat 4 $ add 5 \x -> x - 3
```
