# Why is Learning Functional Programming Hard?

1. Pure functions are more restrictive than impure ones. It takes a while to learn how to do the same thing in FP code that one does in OO code.
2. FP is heavily based on Category Theory (CT), which is very abstract and mathematical, and names its concepts after CT. This implies a lot of unfamiliar jargon that you've never heard of before.
3. Since FP code must work or not compile, debugging a compiler error can be difficult because of using complex types and having type inference work in unexpected ways.
4. CT makes it possible to solve a problem in a number of different ways. It's easy to get lost in it all due to three levels:

On the first-order level...
```purescript
data Either a b
  = Left a
  | Right b
```
A type, `A` (e.g. `Either`), can have one to N different constructors/instances, `B` (e.g. 2 for `Either`), and an implementation for a type class requires implementing its function for all of `B` (e.g. for `Either`, both `Left` and `Right` per type class). If `Either` can implement `C` different type classes, there are `2*C` different ways to use **just** `Either`. Now do that for `D` different data structures and you get `(All Ds' B constructors) * C` or a lot of different things to know!

On the second-order level... Once you know how to use `A`'s instance of `C`, you can compose it with `D` other data structures' implementation for the same or different type class, `E`. So, now you have `((A's B) * C) * ((Ds' Bs) * E)`, or exponentially more things to know!

On the third-order level... A basic library or framework, `L`, that uses a number of approaches from the second-order level expects you to write second-order level code immediately. It's confusing and you feel overwhelmed because you are still getting comfortable with the first-order level.

FP = Data Types + Type Classes + Understanding the relationships between multiple data types' implementations of said type classes

In short, if you don't understand one foundational concept, you will get lost and confused almost immediately. To add to the difficulty, you often don't know why you don't understand something.

4. Due to number 3, one needs to understand
    - `x`: abstract ideas that are turned into type classes
    - `y`: a number of basic data types (e.g. `Either`) and how they implement various type classes.
Thus, one quickly asks, "What do we teach first: `x` or `y` since teaching one requires the teaching the other, too?"

If you start with one `x`, it's easy to teach multiple `y`'s and show how they implement it. However, the new learner quickly becomes one-sided because they cannot write much code without multiple `x`'s.

If you start with multiple `x`'s but only one `y`, you can cover a number of type classes, but the new learner is one-sided because they cannot write much code without multiple `y`'s.

Teaching materials will likely be over balanced in one or the other. To really know and learn, you will have to do both eventually.

**This learning repo will take the second approach: teaching multiple `x`'s with only one `y` to help you build a foundation before expecting you to learn about the other `y`s.**
