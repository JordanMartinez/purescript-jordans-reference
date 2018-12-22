# Appendable

These type classes often take two instances of a given type and 'append' them into one instance. In other words:
```purescript
append :: forall a. a -> a -> a
append a1 a2 = --definition
```
The definition of "appending" depends on the context and the type. One could also think of these type classes as "reducing" two instances of the same type down into one instance of the same type.

## Examples

One example is `String`. Two String instances can be 'appended/reduced' into one instance by
- concatting them together: `append "hello " "world" == "hello world"`

Another example is `Boolean`. Two Boolean instances can be 'appended/reduced' into one instance via the usual suspects:
- `true && true == true`
- `false || true == true`

A third example is `Int`. Two instances of `Int` can be 'appended/reduced' into one instance. How? One could
- add them: `1 + 1`
- multiple them: `2 * 2`

## Numeric Hierarchy Overview

Semigroup and Monoid are used frequently in FP. The above examples illustrate enough for one to understand how they work in principle. However, the rest of PureScript's Numeric type classes (e.g. `Semiring`, `Ring`, etc.) and all the mathematical notations they use are very clearly explained elsewhere in [hdgarrood's Numeric Hierarchy Overview](https://a-guide-to-the-purescript-numeric-hierarchy.readthedocs.io/en/latest/introduction.html).

Once one finishes reading it, be sure to check out [his full-screen cheatsheet](https://harry.garrood.me/numeric-hierarchy-overview/) and [his overview of PureScript's numberic types](https://a-guide-to-the-purescript-numeric-hierarchy.readthedocs.io/en/latest/appendix/purescript-impls.html)

## Docs

Some of these type classes also specify specific helper types (sub bullets under a type class) that serve to reduce boilerplate:
- [Semigroup](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup).
    - When one wants to reduce two values down to one by ignoring the second value and taking the first value, one can use [First](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.First)
    - Or vice versa (ignore first, take second), via [Last](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.Last)
- [Monoid](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid)
    - [Additive](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Additive)
    - [Multiplicative](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Multiplicative)
    - [Conj](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Conj)
    - [Disj](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Disj)
    - [Dual](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Dual)
    - [Endo](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Monoid.Endo)
- [Semigring](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semiring)
- [Ring](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Ring)
- [CommutativeRing](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.CommutativeRing)
- [EuclideanRing](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.EuclideanRing)
- [DivisionRing](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.DivisionRing)
- [Field](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Field)


These type classes do not define any derived functions.
