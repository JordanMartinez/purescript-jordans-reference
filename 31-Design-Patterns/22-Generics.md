# Generics

Have you ever written boilerplate when implementing an instance for a type class (e.g. `Show`) and thought, "Surely, there must be a better/faster way!" Generics is the answer to your problems.

Here's the basic idea behind Generics:
1. You, the end developer, define a data type in your application and use the compiler to derive a `Generic` type class instance.
1. A library developer defines a function that can implement an instance for a given type class (e.g. `Show`, `BoundedEnum`, etc.) for all possible types.
1. You use the library developer's function to implement your data type's instance for a type class.

Great! So how does it work?

The compiler can define two functions, `to` and `from`. `to` converts your data type (i.e. `MyType`) to a new data type (let's say `CompilerRepresentationType` for lack of a better name) that has a different structure than your data type but stores the same information. `from` converts a value of `CompilerRepresentationType` back into a value of `MyType`.
These two functions abide by one law: `(from (to myDataTypeValue)) == myDataTypeValue`

The library developer writes a function that can implement an instance for the desired type class (e.g. `Show`, `BoundedEnum`) that works on `CompilerRepresentationType`. Generics works by first converting your data type into `CompilerRepresentationType`, then uses the library developer's function to implement the instance, and then converts the resulting value of the `CompilerRepresentationType` type back into your original type (i.e. `MyType`).

Put visually, read things from left to right as a timeline of events:
```
MyType --> CompilerRepresentationType ==> CompilerRepresentationType ~~> MyType
```
where
`-->` is where the compiler converts your type into the "same-info, different structure" type via the derived `to` function from the `Generic` type class
`==>` is the library developer's function that implements the instance
`~~>` is where the compiler converts the "same-info, different structure" type back into your type via the derived `from` function from the `Generic` type class

To understand how the compiler produces `CompilerRepresentationType` and how the library developer writes their function, read [@hdgarrood's "Making full use of PureScript's Generic type class"](https://harry.garrood.me/blog/write-your-own-generics/)
