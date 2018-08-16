# Basic Data Types

Purescript modulates many things. This makes code reusage better, but makes it harder for new learners to find the things they need, especially if they don't already know what they are looking for.

So, before we can get started with Prelude, here are a few common FP data structures that need to be understood as they are used everywhere:

| Package | Type name | "Plain English" name | Usage | Instances & their Usage
| - | - | - | - | - |
| [purescript-tuples](https://pursuit.purescript.org/packages/purescript-tuples/5.0.0) | `Tuple a b` | 2-value Box | Stores two ordered values of the same/different types. Can be used to return or pass in multiple unnamed values from or into a function. | `Tuple a b`
| [purescript-maybe](https://pursuit.purescript.org/packages/purescript-maybe/4.0.0) | `Maybe a` | A full or empty box | Used to indicate an optional value; used for simple error-handling; replaces `null` in most OO languages | <ul><li>`Nothing` - An empty box that indicates there was no such value or an error occurred</li><li>`Just a` - A full box with an `a` value stored inside. Indicates success in computation or that an optioanl value was present.</li></ul>
| [purescript-either](https://pursuit.purescript.org/packages/purescript-either/4.0.0) | `Either a b` | Choice of 2 types | Used to indicate the possibility of one value or another; basic error handing | <ul><li>`Left a` - A box containing a value of type `a`. For error-handling, indicates an error type.</li><li>`Right b` - A box containing a value of type `b`. For error-handling, indicates a successful type.</li></ul>
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable singly-linked list | Stores multiple values of the same type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list and either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
