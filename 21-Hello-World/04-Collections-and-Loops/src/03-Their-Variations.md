# Their Variations

Once you get how `Foldable` and `Traversable` works, the following variations should be pretty easy to grasp

## Variants that include the `a` value's index

The same as their base type classes, but an additional `Int` argument represent the `a`'s index in `f` is included in the `map`/`fold`/`traverse` functions.

- [`FunctorWithIndex`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.FunctorWithIndex)
- [`FoldableWithIndex`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.FoldableWithIndex)
- [`TraversableWithIndex`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.TraversableWithIndex)

## Variants where the `f` cannot be empty

The same as their base type classes, but the `f` type must always have at least 1 `a` value. As a result, the `Applicative` requirement in the type class' functions can be downgraded to just `Apply`:
- [`Foldable1`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Semigroup.Foldable)
- [`Traversable1`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Semigroup.Traversable)

## Variants where the `f` can have 2 types

The same as their base type classes, but as though it was `f (Tuple a b)` rather than `f a`:
- [`Bifoldable`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Bifoldable)
- [`Bitraversable`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Bitraversable)

Note: as of `0.15.7`, a type class instance for `BiFoldable` and `BiTraversable` can be derived by the compiler.
