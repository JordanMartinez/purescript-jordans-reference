# Basic Data Types

| Package | Type name | "Plain English" name | Usage | Instances & their Usage
| - | - | - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box | Used to indicate an optional value; used for simple error-handling; replaces `null` in most OO languages | <ul><li>`Nothing` - An empty box that indicates there was no such value or an error occurred</li><li>`Just a` - A full box with an `a` value stored inside. Indicates success in computation or that an optioanl value was present.</li></ul>
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable singly-linked list | Stores multiple values of the same type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list and either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>

## A note on Tuple and Either

There are generally two data types in FP languages:
- Sum type
- Product type

These are better explained [in this video](https://youtu.be/Up7LcbGZFuo?t=19m8s) as to how they get their names.

The simplest form of them are Either and Tuple
```purescript
-- sum
data Either a b
  = Left a
  | Right b

-- product
data Tuple a b = Tuple a b
```

Using the table format above, we could define them as so:

| Package | Type name | "Plain English" name | Usage | Instances & their Usage
| - | - | - | - | - |
| [purescript-tuples](https://pursuit.purescript.org/packages/purescript-tuples/5.0.0) | `Tuple a b` | 2-value Box | Stores two ordered values of the same/different types. Can be used to return or pass in multiple unnamed values from or into a function. | `Tuple a b` |
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types | Used to indicate the possibility of one value or another; basic error handing | <ul><li>`Left a` - A box containing a value of type `a`. For error-handling, indicates an error type.</li><li>`Right b` - A box containing a value of type `b`. For error-handling, indicates a successful type.</li></ul> |

However, these types can also be 'open' or 'closed':

| | Sum | Product |
| - | - | - |
| Closed | `Either a b` | `Tuple a b`
| Open | `Variant` | `Record` (e.g. `{ fst :: a, snd :: b }` )

In other words:
```purescript
Tuple a b
-- is the same as
{ fst :: a, snd :: b}
-- but the record version comes with the option (and advantage)
--   of being 'open' (and sometimes has better performance)
```

## What does 'Open' mean?

Using this example from the Syntax folder...
```purescript
-- the 'r' means, 'all other fields in the record'
function :: forall r. { fst :: String, snd :: String | r } -> String
function record = record.fst <> record.snd

-- so calling the function with both record arguments
--   below works
function { fst: "hello", snd: "world" }                    -- closed record
function { fst: "hello", snd: "world", unrelatedField: 0 } -- open record
-- If this function used Tuple instead of Record,
--    the first argument would work, but not the second one.
```

Keep in mind that records **can be but do not necessarily have to be** open. If we changed the above function's type signature to remove the `r`, it would restrict its arguments to a type of Record that is equivalent to a Tuple, but just in the Record type:
```purescript
closed :: { fst :: String, snd :: String } -> String
closed record = record.fst <> record.snd

closed { fst: "hello", snd: "world" } -- compiles
closed { fst: "hello", snd: "world", unrelatedField: 0 } -- compiler error
```

Using this understanding, the same can be said for `Either` (closed) and `Variant` (openable). Whereas `Either` is a "2-choice box", `Variant` is an "n-choice box" where only m of those choices are needed for a function to work.

In short, it's generally better to use `Record` instead of `Tuple`

## Summary

Putting all of them together now:

| Package | Type name | "Plain English" name | Usage | Instances & their Usage
| - | - | - | - | - |
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box | Used to indicate an optional value; used for simple error-handling; replaces `null` in most OO languages | <ul><li>`Nothing` - An empty box that indicates there was no such value or an error occurred</li><li>`Just a` - A full box with an `a` value stored inside. Indicates success in computation or that an optioanl value was present.</li></ul>
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable singly-linked list | Stores multiple values of the same type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list and either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
| [prim](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0) (imported by default) | `Record` | "openable" unordered n-value Box | Should be used in most cases over `Tuple` (performance, flexibility). Stores 1+ named unordered values of the same/different types. Can be used to return or pass in multiple named values from or into a function. | `{ field1: value1, ... fieldN: valueN }` |
| [purescript-tuples](https://pursuit.purescript.org/packages/purescript-tuples/5.0.0) | `Tuple a b` | "closed" ordered 2-value Box | Shouldn't be used in most cases as Record should be used. Stores two unnamed ordered values of the same/different types. Can be used to return or pass in multiple unnamed values from or into a function. | `Tuple a b` |
| [purescript-variant](https://pursuit.purescript.org/packages/purescript-variant/5.0.0) | "openable" n-choice Type | Used to indicate the possibility of one value among many | TODO | TODO |
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types | Used to indicate the possibility of one value or another; basic error handing | <ul><li>`Left a` - A box containing a value of type `a`. For error-handling, indicates an error type.</li><li>`Right b` - A box containing a value of type `b`. For error-handling, indicates a successful type.</li></ul> |
