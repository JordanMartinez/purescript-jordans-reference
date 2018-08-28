# Type-Level Programming

## Introduction

### Comparison

In programming, there are usually two terms we use to describe "when" a problem/bug/error can occur:
- Compile-time: Turns source code into machine code. Compiler errors occur due to types not aligning.
- Runtime: Executes machine code. Runtime errors occur due to instances of types not working as verified by the compiler (e.g. you expected an instance of `String` at runtime but got `null`).

### Definition

| Term | Definition | "Runtime"
| - | - | - |
| Value-Level Programming | Writing source code that gets executed during runtime | Node / Browser
| Type-Level Programming | Writing source code that gets executed during compile-time | Type Checker / Type Class Constraint Solver^

^ First heard of this from @natefaubion when he mentioned it in the #purescript Slack channel

### Example

#### A Problem

[Taken from this SO answer (last paragraph)](https://stackoverflow.com/a/24481747), type-level programming can be used to:
> restrict certain behavior at the value-level, manage resource finalization, or store more information about data-structures.

Let's explain a problem that highlights the third point: storing more information about data-structures. Below is one problem that occurs at the runtime that can be fixed with type-level programming.

An `Array` is a very fast data structure, but it's problematic because we never know the exact size of it at compile-time. Functions that operate on `Array` where its length/size is important are "partial functions," functions that may not give you a valid output but may instead throw an error. In other words, all your confidence that your code works as expected is thrown into the trash.

An example is getting an element in an `Array` at index `n`. If the array is empty or of size `n - 1`, the function can only throw an error. If it has `n` or more elements, it can return that element.
```purescript
elemAtIndex :: forall a. Partial => Int -> Array a -> a
elemAtIndex idx [] = Partial.crash "cannot get " <> show idx <> "th element of an empty array"
elemAtIndex index fullArray = unsafePartial $ unsafeIndex fullArray index
```

#### A  Solution

However, what if we could modify the type of `Array`, so that it included the size of that array at compile-time? Then, the type-checker could insure that the "elemAtIndex" function described above only receives correct arguments (i.e. specific types) that make the function "total," meaning the function will always return a valid output and never throw an error. If it receives an invalid argument, it results in a compiler error.

```purescript
-- This entire block of code is pseduo syntax and does not actually work!
-- Use it only to get the idea and don't hold onto any of the syntax used here.
elemAtIndex :: forall a n. HasElemAtIndex n => n -> IndexedArray n a
elemAtIndex index array = -- implementation

elemAtIndex 3 (IndexedArray 3 ["a", "b", "c", "d"]) -- "d"
elemAtIndex 0 (IndexedArray Empty []) -- compiler error!
```
