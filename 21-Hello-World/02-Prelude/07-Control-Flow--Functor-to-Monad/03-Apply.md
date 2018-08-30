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

See its docs: [Apply](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Apply)

```purescript
class (Functor f) <= Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b

infixl 4 apply as <*>

data Box a = Box a

instance f :: Functor Box where
  map :: forall a b.       (a -> b) -> Box a -> Box  b
  map                       f         (Box a) = Box (f a)

instance apply :: Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply               (Box  f     )   (Box a) = Box (f a)
```

## Laws

### Associative Composition

Definition: `(<<<) <$> f <*> g <*> h == f <*> (g <*> h)`

TODO: prove the above law using `Box` (a lot of work, so ignoring for now...)

## Derived Functions

- Do two computations, but only return...
    - the first: `applyFirst` / `<*`
    - the second: `applySecond` / `*>`

Let's rename that `Functor`'s `map` function to `lift1`:
```purescript
lift1 (\oneArg -> doStuffWith oneArg) (Box 4)
```
This function can only take one arg. What if want to take two args? We should call it `lift2`:
```purescript
lift2 (\arg1 arg2 -> andThen (doStuffWith arg1) arg2) (Box 4) (Box 4)
```
That works, but we could also write it:
```purescript
(\arg1 arg2 -> andThen (doStuffWith arg1) arg2) <$> (Box 4) <*> (Box 4)
```
Using meta-language
```purescript
function_NotInBox_takes_n_args <$> boxedArg1 <*> boxedArg2 -- <*> boxedArgN ...
```
