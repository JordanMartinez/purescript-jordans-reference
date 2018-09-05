# Sum and Product Types

There are generally two data types in FP languages:
- Sum types
- Product types

These are better explained [in this video](https://youtu.be/Up7LcbGZFuo?t=19m8s) as to how they get their names.

The simplest form of them are `Either` and `Tuple`
```purescript
-- sum
data Either a b   -- is an `a` instance OR  a `b` instance
  = Left a
  | Right b

-- product        -- is an `a` instance AND a `b` instance
data Tuple a b
  = Tuple a b
```

However, these types can also be 'open' or 'closed':

| | Sum | Product |
| - | - | - |
| Closed | `Either a b` | `Tuple a b`
| Open | `Variant (a :: A, b :: B)` | `Record (a :: A, b :: B)`<br>(e.g. `{ a :: A, b :: B }` )

## What does 'Open' mean?

Using this example from the Syntax folder...
```purescript
-- the 'r' means, 'all other fields in the record'
function :: forall r. { fst :: String, snd :: String | r } -> String
function record = record.fst <> record.snd

-- so calling the function with both record arguments below works
function { fst: "hello", snd: "world" }
function { fst: "hello", snd: "world", unrelatedField: 0 } -- works!
-- If this function used Tuple instead of Record,
--    the first argument would work, but not the second one.
```

Here's another way to think about this:
- `Record`s are 'nested `Tuple`s'
- `Variant`s are 'nested `Either`s'

```purescript
-- We could write
Tuple a (Tuple b (Tuple c (Tuple d e)))
-- or we could write
{ a :: A, b :: B, c :: C, d :: D, e :: E }
-- which desugars to
Record ( a :: A, b :: B, c :: C, d :: D, e :: E )

-- We could write
Either a (Either b (Either c (Either d e)))
-- or we could write
Variant ( a :: A, b :: B, c :: C, d :: D, e :: E)
```

Keep in mind that records/variants **can be but do not necessarily have to be** open. If we changed the above function's type signature to remove the `r`, it would restrict its arguments to a closed Record:
```purescript
closed :: { fst :: String, snd :: String } -> String
closed record = record.fst <> record.snd

closed { fst: "hello", snd: "world" } -- compiles
closed { fst: "hello", snd: "world", unrelatedField: 0 } -- compiler error
```

## Concluding Thoughts

**Performance-wise**, it's generally better to use `Record` instead of `Tuple`, and it's definitely better to use `Record` instead of a nested `Tuple`.

Similarly, it's better to use `Variant` instead of a nested `Either`. However, sometimes `Either` is all one needs and `Variant` is overkill.
