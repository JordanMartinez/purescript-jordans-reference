# Bind

## Usage

Short:
- Sequential Computation: do X, and once finished do Y, and once finished do Z

Long:
1. Given a value, `a`, that is stored in a box-like type, `m`
2. Extract the `a` from the box, `m`
3. Pass it into a function, `(a -> m b)`
    - The function uses the value `a` to compute a new value, `b`.
    - The function wraps the new value `b` into the same box-like type, `m`.
    - The function returns a box, `m`, that stores the new value, `b`.
4. Refer to the `b` value as `a` and repeat `Steps 1-3` until we run out of functions
5. The last function returns the final `b` value that is stored in the same box-like type, `m`.

## Definition

See its docs: [Bind](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Bind)

Below, we'll show two instances for `Bind`:
1. A flipped version of bind that shows how it relates to `Functor` and `Apply`
2. The correct version:

```haskell
-- in real definition, 'f' (functor) is really 'm' (monad)
class (Appy f) <= Bind f where
  bind :: forall a b. f a -> (a -> f b) -> f b

infixl 1 bind as >>=

data Box a = Box a

instance Functor Box where
  map :: forall a b.         (a ->     b) -> Box a -> Box  b
  map                         f             (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b.   Box (a ->     b) -> Box a -> Box  b
  apply                 (Box  f         )   (Box a) = Box (f a)

-- Wrong: Flipped order of two args!
instance Bind_ Box where
  bindFlipped :: forall a b. (a -> Box b) -> Box a -> Box  b
  bindFlipped                 f             (Box a) = f a

-- Correct order of args
instance Bind Box where
  bind :: forall a b.  Box a -> (a -> Box b) -> Box b
  bind                (Box a)    f            = f a
```

`bind`'s type signature is weird. How did we ever come up with that? To understand it (and understand why we have the below 'derived functions'), watch [Category Theory 10.1: Monads](https://youtu.be/gHiyzctYqZ0?t=725) and refer to the code below for help in understanding it:
```haskell
-- >=> the "fish operator" is
-- called "composeKleisli"
infix composeKleisli 6 >=>

-- see "(a -> m b)" as the definition
-- of `pure` from the `Applicative` type class.
composeKleisli :: forall m a b c. Functor f => (a -> m b) -> (b -> m c) -> (a -> m c)
composeKleisli f g =
  \a ->
    let mb = f a
    in (bind mb g)

  where
    bind :: m b -> (b -> m c) -> m c
    bind functor function = join (map function functor)

    join :: m (m a) -> m a
    join = -- implementation
```

## Laws

### Associativity

(This law enables "do notation", which we'll explain soon.)

Definition: `(x >>= f) >>= g == x >>= (\x' -> f x' >>= g)`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

## Derived Functions

- If you have nested boxes and need to remove the outer one (`join`):
    - `join (Box (Box a)) == Box a`
- Make chained multiple `aToMB` functions easier to read...
    - going forwards (`composeKleisli`/`>=>`):
        - `ma >=> aToMB >=> bToMC >=> ...`
    - going backwards (`composeKleisliFlipped`/`<=<`):
        - `... <=< bToMC <=< aToMB <=< ma`
- `if computeCondition then truePathComputation else falsePathComputation` (`ifM`)
- If you want `bind`/`>>=` to go in the opposite direction (`bindFlipped`/`=<<`):
    - `ma >>= aToMB == aToMB =<< ma`
