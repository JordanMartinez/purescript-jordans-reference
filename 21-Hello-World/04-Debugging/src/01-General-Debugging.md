# General Debugging

The following sections are tips for debugging issues that may arise in a strongly-typed language via the compiler.

## Type Directed Search

Otherwise known as "typed holes."

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
If we want to know what the type will be for `doX`, we can rewrite that entity using a type direction search, `?doX`, and see what the compiler outputs:
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

This is known as "typed wildcards".

In a function body, wrapping some term with `(term :: _)` will cause the compiler to infer the type for you.

```purescript
main :: Effect Unit
main = do
  a <- computeA
  b <- computeB
  c <- (\w x -> ((doX x) :: _)) <$> box a) <$> (Box 5) <*> (Box 8)
```

## Getting the Type of a Function from the Compiler

There are two possible situations where this idea might help:
- You know how to write the body for a function but aren't sure what it's type signature is
- You're exploring a new unfamiliar library and are still figuring out how to piece things together. So, you attempt to write the body of a function but aren't sure what it's type signature will be.

In such cases, we can completely omit the type signature and the compiler will usually infer what it is for us:
```purescript
-- no type signature here for `f`,
-- so the compiler will output a warning
-- stating what its inferred type is
f = (\a -> (\c -> doX c) <$> box a) <$> (Box 5) <*> (Box 8)
```

However, the above is not always useful when one only wants to know what the type of either an argument or the return type. In such situations, one can use typed wildcards from above in the type signature:
```purescript
doesX :: String -> _ -> Int
doesX str anotherString = length (concat str anotherString)
```
