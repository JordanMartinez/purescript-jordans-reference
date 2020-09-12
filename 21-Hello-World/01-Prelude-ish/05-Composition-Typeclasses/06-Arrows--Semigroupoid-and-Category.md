# Arrows

We'll explain this idea before `Control Flow`-related type classes so that you understand a notation we'll use in them.

## Cleaner Function Notation

Let's say I have two functions:
```haskell
(\x -> x + 1)
(\y -> y * 10)
```

If we want to apply an argument to the first and pass its output into the second, we would have to write something ugly-looking:
```haskell
(\x -> (\y -> y * 10) (x + 1) )
```

What we mean is something like this
```haskell
f = (\x -> x + 1)
g = (\y -> y * 10)

expression = (\arg -> g (f arg))
```

We have just defined function composition, which can be written in such a way to reduce "noise:"
```haskell
-- The arrow determines where the output goes
(\a -> g (f a)) == (g <<< f)
(\a -> g (f a)) == (f >>> g)
```

Moreover, sometimes we want a function that returns the input:
```haskell
(\x -> x)
-- so that we can use it like...
(\x -> x) 4 == 4
```
We call this function, `identity`:
```haskell
(\x -> x) == identity
-- same thing
identity 4 == 4
```

## Generalizing to More Types

To summarize...

| Name | Meaning | Shortcut |
| - | - | - |
| compose | `(\a -> g (f a))` | `(g <<< f)`
| composeFlipped | `(\a -> g (f a))` | `(f >>> g)`
| identity | `(\x -> x) a` | `identity a`

If we were to turn `compose` into a function, it would appear with the type signature below:
```haskell
compose :: forall a b c. (b -> c)     -> (a -> b)     -> (a -> c)
-- However, "->" is just sugar syntax for Function:
compose :: forall a b c. Function b c -> Function a c -> Function a c
-- Notice that Function appears to be just another data structure.
-- If it works for that data structure, why not generalize it for any data structure?
compose :: forall f a b c. f b c -> f a b -> f a c

-- Let's rename our generics, so that it starts with `a` rather than `f`:
compose :: forall a b c d. a c d -> a b c -> a b d

-- We'll line up the types for easier reading:
compose :: forall a b c.           (b -> c) ->         (a -> b) ->         (a -> c)

compose :: forall a b c.   Function b    c  -> Function a    b  -> Function a    c

compose :: forall f a b c. f        b    c  -> f        a    b  -> f        a    c

compose :: forall a b c d. a        c    d  -> a        b    c  -> a        b    d

-- We've now just defined the function `compose` for Semigroupoid:

class Semigroupoid a where
  compose :: forall b c d. a c d -> a b c -> a b d

-- Doing the same for identity is trivial:
identity :: forall a.            a -> a

identity :: forall a.   Function a    a

identity :: forall f a. f        a    a

identity :: forall a b. a        b    b

class (Semigroupoid a) <= Category a where
  -- we'll use 't' instead of 'b'
  identity :: forall t. a t t
```

Here's the docs. You likely won't be using these that often (unless perhaps you're designing a library), but it's good to know of them:
- [Semigroupoid](https://pursuit.purescript.org/packages/purescript-prelude/docs/Control.Semigroupoid#t:Semigroupoid) generalizes compose
- [Category](https://pursuit.purescript.org/packages/purescript-prelude/docs/Control.Category) generalizes identity

You will see `g <<< g` or its flipped version `g >>> f` a lot and we'll use it in the upcoming files.
