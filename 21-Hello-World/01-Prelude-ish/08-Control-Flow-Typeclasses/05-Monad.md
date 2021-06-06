# Monad

## Usage

Monad = Sequential Computation (`Bind`) + Lift a Value/Function into Box-like Type (`Applicative`)

## Definition

See its docs: [Monad](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Monad)

```haskell
class (Applicative m, Bind m) <= Monad m

data Box a = Box a

instance Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box  b
  map f (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply (Box f) (Box a) = Box (f a)

instance Bind Box where
  bind :: forall a b. Box a -> (a -> Box b) -> Box b
  bind (Box a) f = f a

instance Applicative Box where
  pure :: forall a. a -> Box a
  pure a =  Box a

instance Monad Box
```

## Laws

### Unofficial

Taken from [this slide in this YouTube video](https://youtu.be/EoJ9xnzG76M?t=7m9s), here's an "unofficial" but clearer way to understand the laws for Monad by comparing them to a Function:
```haskell
-- Recall: `identity a == (\x -> x) a`

-- Given a function whose type signature is...
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c
(aToMB >=> bToMC) a = (aToMB a) >>= (\b -> bToMC b)

-- ... Monad could be defined by these laws:
-- 1a. Function's identity law
(function >>> identity) a == function a
 aToMB    >=> pure        == aToMB

-- 1b. its inverse
(identity >>> f)        a == f a
 pure     >=> f           == f

-- 2. Function Composition
f >>> (g >>> h) == (f >>> g) >>> h
f >=> (g >=> h) == (f >=> g) >=> h
```

### Official

#### Identity

Definition (left) : `pure x >>= f = f x`

```haskell
-- start
pure x  >>= f
-- replace call signature with body
(Box x) >>= f
-- de-infix `>>=` to `bind`
bind (Box x) f
-- replace call signature with body
f x
-- check LHS with RHS
f x == f x
-- Law met!
true
```

Definition (right): `x >>= pure = x`

#### Applicative Superclass

Definition: `apply = ap` (where `ap` is a derived function)

## Derived Functions

- Define an instance of `Applicative`, `Bind`, and `Monad` and...
    - you get a `Functor` implementation for free!: `liftM1`
    - you get an `Apply` implementation for free!: `ap`
- Do a computation...
    - if some condition is true: `whenM`
    - if some condition is false: `unlessM`
