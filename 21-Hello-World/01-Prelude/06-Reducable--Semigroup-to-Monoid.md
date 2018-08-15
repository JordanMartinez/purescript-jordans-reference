# Reducible

These type classes often take two instances of a given type and 'reduce' them down into one instance. Sometimes, this is by "appending" the two together, but what "appending" means depends on the context and the type.

## Semigroup and Monoid

Since the documentation for these type classes are clear, we will redirect you to them instead of repeating them here:
- [Semigroup](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup).
    - When one wants to reduce two values down to one by ignoring the second value and taking the first value, one can use [First](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.First)
    - Or vice versa (ignore first, take second), via [Last](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.Last)
- [Monoid](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Eq)
    - Monoid has some special classes here, but since they require explaining type classes that we aren't ready to explain yet, they will be postponed until later.

## Useful Derived Functions

None for these type classes, though there will be ones when we get more advanced.
