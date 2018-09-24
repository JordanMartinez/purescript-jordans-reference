# Foldable

## Usage

Plain English names:
- Summarizeable
- Reducible

```
  Given a box-like type, `f`,
    that stores one or more `a` values
return a single value of
  either the same `a` type
  or a new type, `b`, such as
         a concrete type (e.g. String)
      or a higher-kinded type (e.g. List)
    by using a `Semigroup`/`Monoid`-like function
      either to recursively combine the `a`s into one `a`
      or to first map the `a` to `b` and then recursively combining them.
```

It enables:
- a way to reduce a `List` of `String`s into one `String` (the combination of all the `String`s)
- a way to reduce a `List` of `Int`s into one `Int` (the sum/product of all the ints)
- a way to take a `List Int` and create a `Map String Int` (each value is an `Int` from the list and its key is the output of `show int`)
- a way to take a `List Int` and double each `Int` in the list.

## Definition

See its docs: [Foldable](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Foldable#t:Foldable)

```purescript
class (Functor f) => Foldable f where
  foldMap :: forall a m. Monoid m => (a -> m) -> f a -> m

  foldr :: forall a b. (a -> b -> b) -> b -> f a -> b
  foldl :: forall a b. (b -> a -> b) -> b -> f a -> b

data Box a = Box a

instance f :: Foldable Box where
  -- Box doesn't really show the difference between foldl and foldr
  -- but List will
  foldl :: forall a b. (b -> a -> b) -> b -> Box a -> b
  foldl reduceToB initialB (Box a) = reduceToB initialB a

  foldr :: forall a b. (a -> b -> b) -> b -> Box a -> b
  foldr reduceToB initialB (Box a) = reduceToB a initialB

  foldMap :: forall a m. Monoid m => (a -> m) -> Box a -> m
  foldMap putIntoMonoid (Box a) = putIntoMonoid a

-- Cons 1 (Cons 2 Nil)
-- 1 : (Cons 2 Nil)
-- 1 : 2 : Nil
-- same as [1, 2]
instance l :: Foldable List where

  -- This function....
  foldl :: forall a b. (b -> a -> b) -> b -> List a -> b
  foldl _         accumB   Nil           = accumB
  foldl reduceToB initialB (head : tail) =
    foldl reduceToB (reduceToB initialB head) tail
  -- is the same as...
  -- intialB <> firstElem <> secondElem <> thirdElem <> ... <> lastElem

  -- This function...
  foldr :: forall a b. (a -> b -> b) -> b -> List a -> b
  foldr reduceToB accumB   Nil           = accumB
  foldr reduceToB initialB (head : tail) =
    reduceToB (head (foldl reduceToB initialB tail))
  -- ... is the same as...
  -- firstElem <> secondElem <> thirdElem <> ... <> lastElem <> initialB

  foldMap :: forall a m. Monoid m => (a -> m) -> List a -> m
  foldMap putIntoMonoid list = foldl putIntoMonoid mempty list

instance fL :: Functor List where
  map f list = foldr (\a b -> (f a) : b) Nil list
```

## Laws

None

## Derived Functions

[A lot!](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Foldable#v:fold). So we won't be covering them all here.
