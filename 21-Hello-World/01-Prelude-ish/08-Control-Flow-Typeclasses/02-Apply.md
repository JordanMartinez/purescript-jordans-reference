# Apply

## Usage

Shorter: Same as `Functor`, but the function is also in the box-like type, `f`.

Longer:
```
Change a value, `a`,
  that's currently stored in some box-like type, `f`,
into `b`
  using a function, `(a -> b)`,
    that is also stored in the same box-like type, `f`.
```

## Definition

See its docs: [Apply](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Apply)

```haskell
class (Functor f) <= Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b

infixl 4 apply as <*>

data Box a = Box a

instance Functor Box where
  map :: forall a b.       (a -> b) -> Box a -> Box  b
  map                       f         (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply               (Box  f     )   (Box a) = Box (f a)
```

Put differently, `Apply` solves a problem that occurs when using `Functor`. If I have a function of type `(a -> b -> c)`, I can use `Functor`'s `map`/`<$>` to lift that function into a Box-like type as before....
```haskell
mapResult :: Box (Int -> Int)
mapResult = map (\first second -> first + second) (Box 1)
```

However, the resulting value stored in that Box-like type is a function. In other words, `mapResult == Box (\second -> 1 + second)`. `Functor`'s `map` only works if the function takes only one argument. If it takes 2+ arguments, `map` will return a function stored in a `Box`.

This is where `Apply` comes to the rescue. We can continue to apply boxed arguments to that function until we eventually get a Box with a value in it:
```haskell
finalResult :: Box Int
finalResult =
  apply mapResult (Box 2)                                 {-

  ...which is the same as...
  Box ((\second -> 1 + second) 2)
  Box ((\2      -> 1 + 2     )  )
  Box ((           3         )  )
  Box 3                                                   -}
```
Thus, `map` lifts functions that take `n`-many arguments into a Box-like type, and `Apply`'s `apply`/`<*>` continues to pass `n-1`-many boxed arguments into that function until the function executes.

## Laws

### Associative Composition

Definition: `(<<<) <$> f <*> g <*> h == f <*> (g <*> h)`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

## Derived Functions

- Do two computations, but only return...
    - the first: `applyFirst` / `<*`
    - the second: `applySecond` / `*>`
- `liftN` is explained below:

### LiftN Notation

Let's rename that `Functor`'s `map` function to `lift1`:
```haskell
{-
map   (\oneArg -> doStuffWith oneArg) (Box 4) -}
lift1 (\oneArg -> doStuffWith oneArg) (Box 4)
```
This function can only take one arg. What if want to take two args? We should call it `lift2`:
```haskell
lift2 (\arg1 arg2 -> andThen (doStuffWith arg1) arg2) (Box 4) (Box 4)
```
That works, but we could also write it:
```haskell
(\arg1 arg2 -> andThen (doStuffWith arg1) arg2) <$> (Box 4) <*> (Box 4)
```
Using meta-language
```haskell
function_NotInBox_takes_n_args <$> boxedArg1 <*> boxedArg2 -- <*> boxedArgN ...
```
