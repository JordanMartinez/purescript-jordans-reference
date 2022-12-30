# Void

A type with no values. This is NOT the C or Java-style `void` type.

It is useful for proving that a type can never exist or a computation path can never occur.

```haskell
-- Data.Void (Void, absurd)

newtype Void = Void Void

-- needed when one needs to refer to void
absurd :: forall a. Void -> a

-- for example...
data Either a b
  = Left a
  | Right b

-- if this function compiles, it asserts that
-- only the `Right i` path is ever taken
function :: Either Void Int -> Int
function Left v  = absurd v
function Right i = i
```
