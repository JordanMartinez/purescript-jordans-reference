# Applicative

## Usage

- Lift any value/function/etc. into a box-like type, `f`
- Parallel Computation: Do all three simultaneously: X, Y, and Z.

(**Note:** Javascript is currently single-threaded, so this isn't entirely true. If it gets multi-thread support, that will change.)

## Definition

See its docs: [Applicative](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Applicative)

```haskell
class (Apply f) <= Applicative f where
  pure :: forall a. a -> f a

data Box a = Box a

instance Functor Box where
  map :: forall a b.       (a -> b) -> Box a -> Box  b
  map                       f         (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply               (Box  f     )   (Box a) = Box (f a)

instance Applicative Box where
  pure :: forall a. a -> Box a
  pure              a =  Box a
```

## Laws

### Identity

Definition: `(pure (\x -> x) <*> v == v)`

```haskell
-- Start: 'v' == (Box 4)
(pure (\x -> x)) <*> (Box 4)
-- Replace pure call signature with body
( Box (\x -> x)) <*> (Box 4)
-- De-infix <*> to apply
apply (Box (\x -> x)) (Box 4)
-- Replace apply call signature with body
Box (\x -> x) 4)
-- Apply argument by replacing all 'x' with '4'
Box (\4 -> 4)  )
-- Keep body of function
Box (      4)  )
-- Remove whitespace and parenthesis
Box 4
-- Check law
(Box 4) == (Box 4)
-- Law met!
true
```

### Composition

Definition: `pure (<<<) <*> f <*> g <*> h == f <*> (g <*> h)`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

### Homomorphism

Definition: `(pure f) <*> (pure x) == pure (f x)`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

### Interchange

Definition: `u <*> (pure y) == (pure (_ $ y)) <*> u`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

## Derived Functions

- Define an instance of `Apply` and `Applicative` and you get a `Functor` implementation for free!: `liftA1`
- Do a computation...
    - if some condition is true: `when`
    - if some condition is false: `unless`

Note: `when`/`unless` is strict. For a lazy version, see [purescript-call-by-name](https://github.com/natefaubion/purescript-call-by-name)
