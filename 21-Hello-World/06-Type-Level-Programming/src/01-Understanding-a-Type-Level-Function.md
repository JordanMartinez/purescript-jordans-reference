# Understanding a Type-Level Function

## Tips on Rows

Rows in particular are where type-level programming gets interesting and fun.

First, there is a long and short way to write `Record rowType`:
```haskell
long :: forall r. Record r

short :: forall r. { | r }
```
Since the left part of `{ | r}` does not contain any rows, this reduces to `Record r`.

Second, there is syntax sugar via [`RowApply`](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row#t:RowApply)/[`+`](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row#t:type%20(+)) for adding additional rows:
```haskell
type EmptyRow = ()
type ClosedRow1 = (a :: Int)
type OpenRow1 r = (b :: String | r)
type OpenRow2 r = (OpenRow1 + r)
type ClosedRow2 = (OpenRow2 + ClosedRow1)
type MixedRow r = (a :: Int | OpenRow1 + r)

type Row1 r = (x :: Int | r)
type Row2 r = (y :: Int | r)
type Row3 r = (z :: Int | r)
type SuperMixedOpenRow r = (a :: Int, b :: Int, c :: Int | Row1 + Row2 + Row3 + r)
```

Third, we sometimes need to close the "open" row type by using the empty row, `()`:
```haskell
-- Example 1
type Row1 r = (a :: Int | r)
type Row2 r = (b :: Int | r)
type Row3 r = (c :: Int | r)
type Rows1To3__Open r = (Row1 + Row2 + Row3 + r )
type Rows1To3__Closed = (Row1 + Row2 + Row3 + ())

-- Example 2
type OpenRecord r = Record (name :: String, age :: Int | r)

-- If we want to compute something using OpenRecord,
-- we might need to close it by making the `r` an empty row:
finalEval :: OpenRecord () -> Output
```

Rows can make our life easier in a number of ways. We'll see some examples before finishing this "Hello World" folder.

## Reading a Type-Level Function

1. Ignore the type class constraints and look solely at the function's arguments. Now you know what the starting "inputs" and final "outputs" of the function are.
2. Ignore the `IsKind` (e.g. `IsSymbol`/`IsOrdering`) type class constraints and look at the type class constraints that actually compute something (e.g. `Add`, `Append`, `Compare`, `Cons`, etc.) Now you have an understanding of what the type-level function does.
3. Look at the `IsKind` constraints and any `Proxy` types to see how the function type checks.

For example, look at [Prim.Row](https://pursuit.purescript.org/builtins/docs/Prim.Row) to understand the relationships used below and then use the above guidelines to understand this type-level computation:
```haskell
f :: forall row1 row2 row1And2 row1And2PlusAge nubbedRow1And2PlusAge finalRow.
  Union row1 row2 row1And2 =>
  Cons "age" Int row1And2 row1And2PlusAge =>
  Nub row1And2PlusAge nubbedRow1And2PlusAge =>
  Union nubbedRow1And2PlusAge (otherField :: String) finalRow =>

  RProxy row1 -> RProxy row2 -> RProxy finalRow
f _ _ = RProxy
```
What is `finalRow` when `row1` is `(name :: String, age :: Int)` and `row2` is `(pets :: Array Pet)`?

## Writing a Type-Level Function

There are generally five stages when writing a type-level expression:
1. Write the needed type-level function's type signature without any proxies, type class constraints, forall syntax, etc.
2. Add constraints to "compute" specific values in the type-level expression
3. Wrap the types in their `Proxy` types where needed
4. Add the `forall` syntax
5. Write the value-level code that makes it work/compile
    - add `IsKind` constraints when needed
    - use `unsafeCoerce` when needed (explained more in next section)

For example, let's say we were trying to write a simple expression using `Symbol`. Our goal is to append two symbols together. The following code block demonstrates the process one might go through in writing the function:
```haskell
-- we want to append two symbols together into one
-- It's the type-level expression of: "some string" <> "another string"

-- given this type-level relationship:
class Append (left :: Symbol) (right :: Symbol) (appended :: Symbol)
  | left  right    -> appended
  , right appended -> left
  , left  appended -> right

-- 1. Write the function's type signature
combineSymbol :: left -> right -> combination
combineSymbol l r = -- TODO

-- 2. Add the type class constraints to compute type-level values
combineSymbol :: Append left right combination
              => left -> right -> combination
combineSymbol l r = -- TODO

-- 3. Add in the `Proxy` types
combineSymbol :: Append left right combination
              => Proxy left -> Proxy right -> Proxy combination
combineSymbol l r = -- TODO

-- 4. Add the `forall` syntax
combineSymbol :: forall left right combination
               . Append left right combination
              => Proxy left -> Proxy right -> Proxy combination
combineSymbol l r = -- TODO

-- 5. Implement the value-level code
combineSymbol :: forall left right combination
               . Append left right combination
              => Proxy left -> Proxy right -> Proxy combination
combineSymbol _ _ = Proxy
```

### UnsafeCoerce

In a Javascript backend, [unsafeCoerce](https://pursuit.purescript.org/packages/purescript-unsafe-coerce/3.0.0/docs/Unsafe.Coerce#v:unsafeCoerce) is just the [identity function](https://github.com/purescript/purescript-unsafe-coerce/blob/v4.0.0/src/Unsafe/Coerce.js). This is sometimes the only way to get type-level expressions to compile/work in certain cases; however, things can also go wrong if one uses this incorrectly, so any code should be proven to work via tests.

For example, the library, `purescript-variant`, uses `unsafeCoerce` to coerce a runtime representation type to a more user-friendly compile-time type as seen here:
- [VariantRep](https://pursuit.purescript.org/packages/purescript-variant/5.0.0/docs/Data.Variant.Internal#t:VariantRep)
- [Variant and two functions](https://github.com/natefaubion/purescript-variant/blob/v5.0.0/src/Data/Variant.purs#L34-L67)
- the [on function](https://github.com/natefaubion/purescript-variant/blob/v5.0.0/src/Data/Variant.purs#L69-L90)
