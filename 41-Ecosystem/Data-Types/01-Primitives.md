# Primitives

This folder documents both additional 'primitive' data types and their utils libraries.

## Miscellaneous but Important

### Identity

```haskell
newtype Identity a = Identity a
```
Compile-time wrapper that wraps any type, `a`, into a higher-kinded type, `Identity a`.

https://pursuit.purescript.org/packages/purescript-identity/4.0.0/docs/Data.Identity

### Globals

- NaN
- Infinity

https://pursuit.purescript.org/packages/purescript-globals/4.0.0/docs/Global

## Number-related

### Int

- fromString (a type-safe `parseInt`)
https://pursuit.purescript.org/packages/purescript-integers/4.0.0

### Math

https://pursuit.purescript.org/packages/purescript-math/2.1.1/docs/Math

### Rationals

Precise Fractions

https://pursuit.purescript.org/packages/purescript-rationals/5.0.0

### Precise

HugeInt (BigInt) + HugeNumber (BigNumber)

https://pursuit.purescript.org/packages/purescript-precise/3.0.1

### Numerics

A combination of other precise number-related libraries under common type signatures

https://pursuit.purescript.org/packages/purescript-numerics/0.1.1

### BigIntegers

https://pursuit.purescript.org/packages/purescript-bigints/4.0.0/docs/Data.BigInt

### Decimals

https://pursuit.purescript.org/packages/purescript-decimals/4.0.0/docs/Data.Decimal

## Strings

- https://pursuit.purescript.org/packages/purescript-strings/4.0.0 (char, string, and regex)
- https://pursuit.purescript.org/packages/purescript-stringutils/0.0.8 (includes some additional functions not in `purescript-strings`; also contains many deprecated functions)

- https://pursuit.purescript.org/packages/purescript-bytestrings/6.0.0
- https://pursuit.purescript.org/packages/purescript-fuzzy/0.2.1/docs/Data.Fuzzy

## Binary (Outdated)

https://pursuit.purescript.org/packages/purescript-binary/0.2.9

## Matrix

Type-Safe-Size Matrices

https://pursuit.purescript.org/packages/purescript-sized-matrices/0.2.1
