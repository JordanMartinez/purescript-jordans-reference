# Overview

There are type classes that control the flow of the program (e.g. whether the program should do X and then Y or should do X and Y at the same time).

## Functor, Apply, and Bind Type Classes Explained in Pictures

We've linked to an article below that explains these abstract notions in a clear manner using pictures and the `Maybe a` data structure. However, since these concepts are explained in Haskell, which uses different terminology than Purescript, use the following table to `map` Haskell terminology to Purescript terminology:

| Haskell Terminology | Purescript Terminology |
| --- | --- |
| `fmap` (function) | `map` (function) |
| `Applicative` (type class) | `Apply` (type class) |
| `Array`/`[]` (syntax sugar for `List a`) | `List a` |
| `map` (Array function) | see [the implementation in Purescript](#lists-map-function-in-purescript) |
| `IO ()` | `Effect Unit`, which will be explained/used in a later part of this folder |

Here's the link: [Functors, Applicatives, and Monads in Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)

### Lists' Map Function in Purescript

Here's the `map` List function implemented in Purescript:
```haskell
data List a = Nil | Cons a (List a)

instance Functor List where
  map :: forall a b. (a -> b) -> List a -> List b
  map f Nil = Nil
  map f (Cons head tail) = Cons (f head) (map f tail)
```

## Functor, Apply, Applicative, Bind, Monad

### In Short

| Concept | Argument is NOT inside a Box / context | Argument is inside a Box / context | Name
| - | - | - | - |
| 1-arg function application | `function arg` | `function <$> (Box arg)` | `Functor` |
| 2+-arg function application | `function arg1 arg2` | `function <$> (Box arg1) <*> (Box arg2)` | `Applicative` |
| function composition | `aToB >>> bToC` | `aToBoxB >=> bToBoxC` | `Monad` |

### Somewhat longer

These will be covered at a slower and clearer pace in the upcoming files. This is just an overview of them.

| Typeclass | "Plain English" | Function | Infix | Laws | Usage
| -- | -- | -- | -- | -- | -- |
| [Functor](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Functor) | Mappable | `map :: forall a b. (a -> b) -> f a -> f b` | `<$>` <br> (Left 4) | <ul><li>identity: `map (\x -> x) fa == fa`</li><li>composition: `map (f <<< g) = map f <<< map g`</li></ul> | Change a value, `a`, that's currently stored in some box-like type, `f`, using a function, `(a -> b)` |
| [Apply](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Apply) | Boxed Mappable | `apply :: forall a b. f (a -> b) -> f a -> f b` | `<*>` <br> (Left 4) | <ul><li>Associative composition: `(<<<) <$> f <*> g <*> h == f <*> (g <*> h)`</li></ul> | Same as `Functor` except the function is now inside of the same box-like type. |
| [Applicative](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Applicative) | Liftable <hr> Parallel Computation | `pure :: forall a. a -> f a` |  | <ul><li>identity: `(pure (\x -> x) <*> v == v)`</li><li>composition: `pure (<<<) <*> f <*> g <*> h == f <*> (g <*> h)`</li><li>Homomorphism: `(pure f) <*> (pure x) == pure (f x)`</li><li>interchange: `u <*> (pure y) == (pure (_ $ y)) <*> u`</li></ul> | Put a value into a box <hr> Run code in parallel |
| [Bind](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Bind) | Sequential Computation | `bind :: forall m a b. m a -> (a -> m b) -> m b` | `>>=` <br> (Left 1)| Associativity: `(x >>= f) >>= g == x >>= (\x' -> f x' >>= g)` | Given an value of a box-like type, `m`, that contains a value, `a`, extract the `a` from `m`, and create a new `m` value that stores a new value, `b`. <br> Take `m a` and compute it via `bind`/`>>=` to produce a value, `a`. Then, use `a` to describe (but not run) a new computation, `m b`. When `m b` is computed (via a later `bind`/`>>=`), it will return `b`. |
| [Monad](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Monad) | FP Program | | | <ul><li>Left Identity: `pure x >>= f = f x`</li><li>Right Identity: `x >>= pure = x`</li><li>Applicative Superclass: `apply = ap`</li></ul> | The data structure used to run FP programs by executing code line-by-line, function-by-function, etc. |

## Simplest Monad Implementation

```haskell
data Box a = Box a

instance Functor Box where
  map        f  (Box a) = Box (f a)

instance Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance Bind Box where
  bind  (Box a) f       = f a

instance Applicative Box where
  pure a = Box a

instance Monad Box
```

## Function Reduction

In these files, we will "evaluate" functions by using graph reductions: replacing the left-hand side (LHS) of the `=` sign (the function's call signature) with the right-hand side (RHS) of the `=` sign (the function's implementation / body). In other words...
```haskell
someFunction arg1 arg2 arg3 = bodyOfFunction
| call signature (LHS)    | = | body (RHS) |
```
