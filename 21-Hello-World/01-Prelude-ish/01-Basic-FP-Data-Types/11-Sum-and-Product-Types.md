# Sum and Product Types

There are generally two data types in FP languages. These are otherwise known as Algebraic Data Types (ADTs):
- Sum types
  - Counts like addition: the total number of possible values for a sum type `A+B` is the number of possible values for type `A` added to the number of possible values for type `B`.
  - Works like a logical OR
- Product types
  - Counts like multiplication: the total number of possible values for a product type `A*B` is the number of possible values for type `A` multiplied by the number of possible values for type `B`.
  - Works like a logical AND

These are better explained [in this video](https://youtu.be/Up7LcbGZFuo?t=19m8s) as to how they get their names.

The simplest form of them are `Either` and `Tuple`
```haskell
-- sum
data Either a b   -- a value of this type is an `a` value OR  a `b` value
  = Left a
  | Right b

-- product        -- a value of this type is an `a` value AND a `b` value
data Tuple a b
  = Tuple a b

-- both           --  a value of this type is one of the following:
data These a b
  = This a        --  - an `a` value
  | That b        --  - a `b` value
  | Both a b      --  - an `a` value AND a `b` value

-- For example, These could be rewritten to
-- use a combination of Either and Tuple:
type These_ a b = Either a (Either b (Tuple a b))
```

However, these types can also be 'open' or 'closed':

| | Sum | Product | Sum and Product
| - | - | - | - |
| Closed | `Either a b`<br><br>`Variant (a :: A, b :: B)` | `Tuple a b`<br><br>`Record (a :: A, b :: B)`<br>(e.g. `{ a :: A, b :: B }` | `These a b`
| Open | <code>Variant (a :: A &#124; allOtherRows)</code> | <code>Record (a :: A &#124; allOtherRows)</code><br>(e.g. <code>{ a :: b &#124; allOtherRows }</code>) | - |

## What does 'Open' mean?

Using this example from the Syntax folder...
```haskell
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

```haskell
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
```haskell
closed :: { fst :: String, snd :: String } -> String
closed record = record.fst <> record.snd

closed { fst: "hello", snd: "world" } -- compiles
closed { fst: "hello", snd: "world", unrelatedField: 0 } -- compiler error
```

## Concluding Thoughts

The next few pages will cover the above types in a bit more depth. However, **performance-wise**, it's generally better to use `Record` instead of `Tuple`, and it's definitely better to use `Record` instead of a nested `Tuple`.

Similarly, it's better to use `Variant` instead of a nested `Either`. However, sometimes `Either` is all one needs and `Variant` is overkill.

For people new to the language and algebraic data types (ADTs) in general, stick with `Tuple`, `Either`, and closed `Record`s.
