# Sum and Product Types

There are generally two data types in FP languages. These are otherwise known as Algebraic Data Types (ADTs):
- Sum types (corresponds to addition)
- Product types (corresponds to multiplication)

These are better explained [in this video](https://youtu.be/Up7LcbGZFuo?t=19m8s) as to how they get their names.

The simplest form of them are `Either` and `Tuple`
```haskell
-- sum
data Either a b   -- a value of htis type is an `a` value OR  a `b` value
  = Left a
  | Right b

-- product        -- a value of htis type is an `a` value AND a `b` value
data Tuple a b
  = Tuple a b

-- both           --  a value of this type is one of the following:
data These a b
  = This a        --  - an `a` value
  | That b        --  - a `b` value
  | Both a b      --  - an `a` value AND a `b` value
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

## The Types

### Tuple

```haskell
data Tuple a b = Tuple a b
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-tuples](https://pursuit.purescript.org/packages/purescript-tuples/5.0.0) | `Tuple a b` | 2-value Box

| Usage | Values & their Usage |
| - | - |
| Stores two ordered unnamed values of the same/different types.<br>Can be used to return or pass in multiple unnamed values from or into a function. | `Tuple a b` |

### Record

```haskell
forall r. { a :: A, b :: B, {- ... -} | r } -- open record
          { a :: A, b :: B, {- ... -}     } -- closed record
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [prim](https://pursuit.purescript.org/builtins/docs/Prim#t:Record) | `{ field :: ValueType }` | an N-value Box

| Usage | Values & their Usage |
| - | - |
| Stores N ordered named values of the same/different types.<br>Can be used to return or pass in multiple unnamed values from or into a function. | `{ field :: ValueType }` |

### Either

```haskell
data Either a b
  = Left a
  | Right b
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types

| Usage | Values & their Usage
| - | - |
| Used to indicate one type or a second type | <ul><li>`Left a` - a value of `a`</li><li>`Right b` - a value of `b`</li></ul>
| Error handing (when we care about the error) | <ul><li>`Left a` - the error type that is returned when a computation fails</li><li>`Right b` - the output type when a computation succeeds</li></ul>

## Maybe

```haskell
data Maybe a
  = Nothing
  | Just a
```

`Maybe a` is the same as `Either unimportantType a`

| Package | Type name | "Plain English" name
| - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box

| Usage | Values' Representation
| - | -
| Indicates an optional value | <ul><li>`Nothing` - value does not exist</li><li>`Just a` - value does exist</li></ul>
| Used for error-handling when we don't care about the error (replaces `null`) | <ul><li>`Nothing` - An error occurred during computation</li><li>`Just a` - successful computation returned output.</li></ul>

### Variant

This is an advanced type that will be covered in the `Hello World/Application Structure` folder.

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-variant](https://pursuit.purescript.org/packages/purescript-variant/5.0.0) | `Variant (a :: A, b :: B)` | Choice of N types

| Usage | Values & their Usage
| - | - |
| Used to indicate one type among many types | See docs |

### These

```haskell
data These a b
  = This a      -- Left  a
  | That b      -- Right b
  | Both a b    -- Tuple a b
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-these](https://pursuit.purescript.org/packages/purescript-these/4.0.0) | `These a b` | Same as `Either a (Either b (Tuple a b))`

## Concluding Thoughts

**Performance-wise**, it's generally better to use `Record` instead of `Tuple`, and it's definitely better to use `Record` instead of a nested `Tuple`.

Similarly, it's better to use `Variant` instead of a nested `Either`. However, sometimes `Either` is all one needs and `Variant` is overkill.

For people new to the language and algebraic data types (ADTs) in general, stick with `Tuple`, `Either`, and closed `Record`s.
