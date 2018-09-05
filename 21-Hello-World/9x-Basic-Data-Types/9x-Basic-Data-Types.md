# Basic Data Types

| Package | Type name | "Plain English" name | Usage | Instances & their Usage
| - | - | - | - | - |
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable singly-linked list | Stores multiple values of the same type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list and either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>

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
