# Type-Level Programming

This folder assumes you have read through and are familiar with `Type Level Syntax`. If you aren't, go and read through that first.

## Example

### A Problem

[Taken from this SO answer (last paragraph)](https://stackoverflow.com/a/24481747), type-level programming can be used to:
> restrict certain behavior at the value-level, manage resource finalization, or store more information about data-structures.

Let's explain a problem that highlights the third point: storing more information about data-structures. Below is one problem that occurs at the runtime that can be fixed with type-level programming.

An `Array` is a very fast data structure, but it's problematic because we never know its exact size at compile-time. In other words, we don't get a compiler error if we reference an invalid spot in the array, and we won't know about the bug until it occurs when running the program. In short, this kind of function will always be a partial function.

Here's an example in code. If the array is empty or has fewer than `n - 1` elements, the function can only throw an error when we try to reference a non-existent element at index `n`. If the array has `n - 1` or more elements, it can return that element.
```haskell
elemAtIndex :: forall a. Partial => Int -> Array a -> a
elemAtIndex idx [] = Partial.crash "cannot get " <> show idx <> "th element of an empty array"
elemAtIndex index fullArray = unsafePartial $ unsafeIndex fullArray index
```

### A Solution

What if we could modify the type of `Array`, so that it included the size of that array at compile-time? Then, the type-checker could ensure that the "elemAtIndex" function described above only receives correct arguments (i.e. specific types) that make the function "total," meaning the function will always return a valid output and never throw an error. If it receives an invalid argument, it results in a compiler error and we can fix the bug before shipping the code to customers.

```haskell
-- This entire block of code is pseduo syntax and does not actually work!
-- Use it only to get the idea and don't hold onto any of the syntax used here.
elemAtIndex :: forall a n. HasElemAtIndex n => n -> IndexedArray n a
elemAtIndex index array = -- implementation

elemAtIndex 3 (IndexedArray 3 [0, 1, 2, 3]) -- 3
elemAtIndex 3 (IndexedArray 3 [0, 1]) -- compiler error!
elemAtIndex 0 (IndexedArray Empty []) -- compiler error!
```

This is exactly what the library [sized-vectors](https://pursuit.purescript.org/packages/purescript-sized-vectors/3.1.0/docs/Data.Vec#t:Vec) does.

## Issues with Type-Level Programming

- When using type-level programming, the compiler has to do more work. Thus, it will increase the time it takes to compile your program.
- Creating a type-level value for a kind can get really tedious and boilerplatey. Either reuse ones that exist in libraries or publish your own library for the benefit of the entire community.

## Other Learning Sources

Consider purchasing the `Thinking with Types` book mentioned in `ROOT_FOLDER/Syntax/Type-Level Programming Syntax/ReadMe.md`

## Compilation Instructions

```bash
spago run -m TLP.SymbolExample.Proxy
spago run -m TLP.SymbolExample.VTAs
spago run -m TLP.IntegerExample.Proxy
spago run -m TLP.IntegerExample.VTAs
spago run -m TLP.RowExample.Proxy
spago run -m TLP.RowExample.VTAs
```
