# Introduction

## Comparison

In programming, there are usually two terms we use to describe what occurs when:
- Compile-time: Converts our source code into machine code and insures that types are correct. If not, it throws a compiler error.
- Runtime: Runs the program by executing the machine code.

Let's give an example:
```purescript
"""I am a string value that is written at the source level and
which exists at runtime. During runtime, you can manipulate me by
doing things like prepending or appending additional String instances
to me or by getting a specific character somewhere within me.

However, you cannot do any of this during compile-time.
All of this happens during the runtime.
"""
```

## Definition

Programming usually refers to writing code at the source-level to run a program during runtime. "Type-Level Programming" means writing code at the source-level to run a "program" during compile-time.

## An Example Problem

Let's explain a problem that occurs at the runtime that can be fixed with type-level programming.

An `Array` is a very fast data structure, but it's problematic because we never know the exact size of it. In other words, functions that operate on `Array` where its length/size is important are "partial functions."
An example is getting the first element in an `Array`. If it's empty, the function can only throw an error. If it has at least one element, it can return that element. This is why we have to use the `Partial` type class in Purescript. It's also why many functional languages use the "List a" type because the "Nil" constructor makes all of their functions total and type-safe.

However, what if we could modify the type of `Array`, so that it included the size of that array at the compile-time? If we could, we could then use the type-checker to insure that the "firstElement" function described above only receives arguments of the made-up type `NonEmptyArray`. It would guarantee that an array function is total because it can only take a specific `Array` type that works.

Stated differently, "Type-Level Programming" allows us to add additional information to our types to guarantee correct code via the type-checker.

There are a few libraries in Purescript that add support for type-level programming:

| Name | Usage |
| - | - |
| [purescript-prelude](https://pursuit.purescript.org/packages/purescript-prelude/) | TODO
| [purescript-proxy](https://pursuit.purescript.org/packages/purescript-proxy/) | TODO
| [purescript-typelevel-equality](https://pursuit.purescript.org/packages/purescript-type-equality/) | Type equality constraints
| [purescript-typelevel-prelude](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/) | Types and Kinds for basic type-level programming
| [purescript-typelevel-eval](https://pursuit.purescript.org/packages/purescript-typelevel-eval/) | Higher-order functional programming in the type system

Real-World examples
- [purescript-trout](https://github.com/owickstrom/purescript-hypertrout) -  Type-Level Routing. Used in [purescript-hypertrout](https://github.com/owickstrom/purescript-hypertrout).
