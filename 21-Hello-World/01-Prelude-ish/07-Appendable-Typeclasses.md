# Appendable: Semigroup to Monoid

This file will only cover the first two type classes in the type class hierarchy. The rest will be covered later.

These type classes often take two values of a given type and 'append' them into one new value. One could also think of this as 'reducing' two values into one value.

## Semigroup

```haskell
class Semigroup a where
  append :: a -> a -> a

infixr 5 append as <>
```

### Examples

One example is `String`. Two String values can be 'appended/reduced' into one value by concatenating them together: `append "hello " "world" == "hello world"`.

Another example is `Boolean` (although its functions are not defined in this way as there is a better type class for them). Two Boolean values can be 'appended/reduced' into one value via the usual suspects:
- `true && true == true`
- `false || true == true`

A third example is `Int`, which has two possible instances for 'appending/reducing' two values into one value. How? One could
- add them: `1 + 1`
- multiple them: `2 * 2`

A fourth is `List`. One can take two values of `List` and combine them together by putting both lists' elements into one new list.

## Monoid

```haskell
class Semigroup a <= Monoid a where
  mempty :: a
```

`mempty` is the "identity" value. In other words `mempty <> a == a` and `a <> mempty == a`. In some contexts, `mempty` acts like a "default value."

The name, `mempty`, is used rather than `empty` because `empty` is the name of a function that a different but similar type class called `Plus` defines. We won't cover `Plus` here.

Using the same examples above,

| Type | `mempty` value | Example 1 | Example 2
| - | - | - | - |
| `String` | "" | "foo" <> "" == "foo" | "" <> "foo" == "foo"
| `Boolean` (and) | true | x &amp;&amp; true == x | true &amp;&amp; x == x
| `Boolean` (or) | false | x `||` false == x | false `||` x == x
| `Int` (plus) | 0 | x <> 0 == x | 0 <> x == x
| `Int` (multiply) | 1 | x <> 0 == x | 1 <> x == x
| `List` | Nil | x <> Nil == X | Nil <> x == x

## Docs

Some of these type classes also specify specific helper types (sub bullets under a type class) that serve to reduce boilerplate:
- [Semigroup](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Semigroup).
    - When one wants to reduce two values down to one by ignoring the second value and taking the first value, one can use [First](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Semigroup.First)
    - Or vice versa (ignore first, take second), via [Last](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Semigroup.Last)
- [Monoid](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid)
    - When one wants to use `Semiring`'s `add`/`+` and `zero` as the meaning of `<>` and `mempty`, one can use [Additive](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Additive).
    - When one wants to use `Semiring`'s `mul`/`*` and `one` as the meaning of `<>` and `mempty`, one can use [Multiplicative](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Multiplicative)
    - When one wants to use `HeytingAlgebra`'s `conj`/`&&` and `tt` as the meaning of `<>` and `mempty`, one can use [Conj](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Conj)
    - When one wants to use `HeytingAlgebra`'s `disj`/`||` and `ff` as the meaning of `<>` and `mempty`, one can use [Disj](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Disj)
    - When one wants to use `Category`'s `compose`/`<<<` and `identity` as the meaning of `<>` and `mempty`, one can use [Endo](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Endo)
    - When one wants to use `Category`'s `composeFlipped`/`>>>` and `identity` as the meaning of `<>` and `mempty`, one can use [Dual](https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Monoid.Dual)

For derived functions (if any), see the type classes' docs.
