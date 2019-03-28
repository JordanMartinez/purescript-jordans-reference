# Either and Tuple

There are generally two data types in FP languages:
- Sum types
- Product types

These are better explained [in this video](https://youtu.be/Up7LcbGZFuo?t=19m8s) as to how they get their names.

The simplest form of them are `Either` and `Tuple`
```purescript
-- sum
data Either a b   -- is an `a` value OR  a `b` value
  = Left a
  | Right b

-- product        -- wraps an `a` value AND a `b` value
data Tuple a b
  = Tuple a b
```

These types are 'closed' (to see what open/closed sum/product types mean, see "Ecosystem/Data-Types/Sum-and-Product-Types.md"):

## Either

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types

| Usage | Values & their Usage
| - | - |
| Used to indicate one type or a second type | <ul><li>`Left a` - an value of `a`</li><li>`Right b` - an value of `b`</li></ul>
| Error handing (when we care about the error) | <ul><li>`Left ErrorType` - the error type that is returned when a computation fails</li><li>`Right OutputType` - the output type when a computation succeeds</li></ul>

## Tuple

```purescript
data Tuple a b = Tuple a b
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-tuples](https://pursuit.purescript.org/packages/purescript-tuples/5.0.0) | `Tuple a b` | 2-value Box

| Usage | Values & their Usage |
| - | - |
| Stores two ordered unnamed values of the same/different types.<br>Can be used to return or pass in multiple unnamed values from or into a function. | `Tuple a b` |
