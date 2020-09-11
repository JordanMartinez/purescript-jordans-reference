# PureScript Filterable

The following type classes come from [`purescript-filterable`](https://pursuit.purescript.org/packages/purescript-filterable).

## Compactable

[`Compactable`](https://pursuit.purescript.org/packages/purescript-filterable/docs/Data.Compactable#t:Compactable)

```haskell
class Compactable f where
  compact :: forall a.    f (Maybe a)    ->           f a

  separate :: forall l r. f (Either l r) -> { left :: f l, right :: f r }
```

[`catMaybes`](https://pursuit.purescript.org/packages/purescript-arrays/docs/Data.Array#v:catMaybes) is a function that removes all `Nothing`s in an `Array`. `compact` and `separate` generalize this idea to work across more `f` types and works for both `Maybe` and `Either`:
```haskell
catMaybes [Just 1, Nothing] == [1]

compact [Just 1, Nothing] == [1]
compact (Just 1 : Just 2 : Nothing : Nil) == 1 : 2 : Nil

separate [Left 1, Left 2, Right 3, Right 4] == { left: [1, 2], right: [3, 4] }
```

## Filterable

[`Filterable`](https://pursuit.purescript.org/packages/purescript-filterable/docs/Data.Filterable#t:Filterable) generalizes the concept of [`Array.filter`](https://pursuit.purescript.org/packages/purescript-arrays/docs/Data.Array#v:filter) and [`Array.partition`](https://pursuit.purescript.org/packages/purescript-arrays/docs/Data.Array#v:partition) to work arcross more `f` types.

```haskell
class (Compactable f, Functor f) <= Filterable f where
  filter :: forall a.
    (a -> Boolean)    -> f a ->         f a

  filterMap :: forall a b.
    (a -> Maybe b)    -> f a ->         f b

  partition :: forall a.
    (a -> Boolean)    -> f a -> { no :: f a, yes :: f a }

  partitionMap :: forall a l r.
    (a -> Either l r) -> f a -> { left :: f l, right :: f r }
```

## Witherable

[`Witherable`](https://pursuit.purescript.org/packages/purescript-filterable/docs/Data.Witherable) is the same as `Traversable`'s `traverse` but either removes the resulting `Nothing`s like `compact` or distinguishes the `Left`s and the `Rights` like `separate`.

```haskell
-- traverse :: forall a b m. Applicative m =>
--  (a -> m b           ) -> t a -> m          (t b)

class (Filterable t, Traversable t) <= Witherable t where
  wither :: forall m a b. Applicative m =>
    (a -> m (Maybe b)   ) -> t a -> m          (t b)

  wilt :: forall m a l r. Applicative m =>
    (a -> m (Either l r)) -> t a -> m { left :: t l, right :: t r }
```

Its derived functions, `wilted` and `withered`, use `sequence` instead of `traverse`.
```haskell
-- sequence :: forall a m. Applicative m =>
--  t (m a           ) -> m          (t a)

withered :: forall t m x. Witherable t => Applicative m =>
    t (m (Maybe x)   ) -> m          (t x)

wilted :: forall t m l r. Witherable t => Applicative m =>
    t (m (Either l r)) -> m { left :: t l, right :: t r }
```
