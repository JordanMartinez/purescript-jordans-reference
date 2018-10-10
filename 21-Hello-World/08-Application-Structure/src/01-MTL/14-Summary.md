# Summary

What follows is my general understanding of what is true by this point in my learning process. It might be inaccurate or misleading, so take it with a grain of salt.

What did we gain by doing this? Let's give an overview:
- A program that is one pure function composed of many smaller pure functions.
- Since we're using `newtype`s everywhere, the code we're writing doesn't incur any runtime overhead from boxing/unboxing a monad via bind. If it is slower than OO code, the compiler may not be doing as many optimizations as it could be, or that might be the cost of using immutable data structures.
- Since the same input will always produce the same output, it makes our program easier to test and debug.
- Refactoring our code should be trivial.

I'm not sure how accurate this table is, but it's a pattern I noticed after finishing this folder.

| A basic concept... | ...becomes a monad transformer via |
| - | - |
| Either e a | ExceptT
| Tuple a b | WriterT
| Maybe a | MaybeT
| List a | ListT
| f $ arg | ContT
| state manipulation | StateT
