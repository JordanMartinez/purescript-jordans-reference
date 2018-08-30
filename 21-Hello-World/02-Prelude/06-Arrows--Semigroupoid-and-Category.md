# Arrows

## Cleaner Function Notation

Let's say I have two functions:
```purescript
(\x -> x + 1)
(\y -> y * 10)
```

If we want to apply an argument to the first and pass its output into the second, we would have to write something ugly-looking:
```purescript
(\x -> (\y -> y * 10) (x + 1) )
```

What we mean is something like this
```purescript
f = (\x -> x + 1)
g = (\y -> y * 10)

expression = (\arg -> f (g arg))
```

We have just defined function composition, which can be written in such a way to reduce "noise:"
```purescript
(\a -> f (g a)) == (f <<< g)
```

Moreover, sometimes we want a function that returns the input:
```purescript
(\x -> x)
(\x -> x) 4 == 4
```
We call this function, `identity`:
```purescript
(\x -> x) == identity

identity 4 == 4
```

## Generalizing to More Types

When we see the below two laws for functions, they make sense:
- composition: `(\a -> f (g a)) == (f <<< g)`
- identity: `a == (\x -> x) == identity a`

If we were to turn the `composition` law into a function, it would appear with the type signature below:
```purescript
composition :: forall a b c. (b -> c)     -> (a -> b)     -> (a -> c)
-- However, "->" is just sugar syntax for Function:
composition :: forall a b c. Function b c -> Function a c -> Function a c
-- Notice that Function appears to be just another data structure.
-- If it works for that data structure, why not generalize it for any data structure?
composition :: forall f a b c. f b c -> f a b -> f a c

-- Let's rename our generics, so that it starts with `a` rather than `f`:
composition :: forall a b c d. a c d -> a b c -> a b d

-- We'll put them side by side for easier reading:
composition :: forall a b c.           (b -> c) ->         (a -> b) ->         (a -> c)

composition :: forall a b c.   Function b    c  -> Function a    b  -> Function a    c

composition :: forall f a b c. f        b    c  -> f        a    b  -> f        a    c

composition :: forall a b c d. a        c    d  -> a        b    c  -> a        b    d

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
- [Semigroupoid](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Semigroupoid#t:Semigroupoid) generalizes composition
- [Category](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Category) generalizes identity
