# Appendable

These type classes often take two instances of a given type and 'append' them into one instance. In other words:
```purescript
append :: forall a. a -> a -> a
append a1 a2 = --definition
```
The definition of "appending" depends on the context and the type. One could also think of these type classes as "reducing" two instances of the same type down into one instance of the same type.

## Examples

One example is String. Two String instances can be 'appended/reduced' into one instance by
- concatting them together: `append "hello " "world" == "hello world"`

Another example is Boolean. Two Boolean instances can be 'appended/reduced' into one instance via the usual suspects:
- `true && true == true`
- `false || true == true`

A third examlpe is Int. Two instances of `Int` can be 'appended/reduced' into one instance. How? One could
- add them: `1 + 1`
- multiple them: `2 * 2`
- subtract them: `3 - 1`
- divide them: `4 / 2`

Semigroup and Monoid handle addition/multiplication whereas Semiring and its sub type classes handle subtraction and division.

## Semigroup and Monoid

Since the documentation for these type classes are clear, we will redirect you to them instead of repeating them here. These type classes also specify specific helper types to indicate how to implement them. They serve to reduce boilerplate:
- [Semigroup](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup).
    - When one wants to reduce two values down to one by ignoring the second value and taking the first value, one can use [First](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.First)
    - Or vice versa (ignore first, take second), via [Last](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Semigroup.Last)
- [Monoid](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Eq)
    - Monoid has some special classes here, but since they require explaining type classes that we aren't ready to explain yet, they will be postponed until later.


These type classes do not define any derived functions.
