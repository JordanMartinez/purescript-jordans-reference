# Why is Learning Functional Programming Hard?

## You aren't familiar with Category Theory

1. FP languages are heavily based on Category Theory (CT), which is a very abstract field of mathematics, and names its concepts after CT. This implies a lot of unfamiliar jargon that you've never heard of before. Moreover, it can be difficult to understand these concepts due to how abstract they can be.
2. Pure functions are more restrictive than impure ones. It takes a while to learn how to do the same thing in FP code that one does in OO code.
3. CT makes it possible to solve a problem in a number of different ways. It's easy to get lost in it all due to three levels:

On the first-order level...

Let's define some terminology to help understand this complexity.

```purescript
data Either a b
  = Left a
  | Right b
```

Let's use `A` to refer to types, such as `Either`.
Let's use `B` to refer to all of `A`'s different constructors/instances. The total number is between 1 and N. For example, `Either`'s `B` is 2
Let's use `C` to refer to all the type class instances an `A` has. For example, `Either` might satisfy up to 10 different type classes.
Let's use `D` to refer to the sum of all the argument cases used in an `A`'s `C`. For example, assuming `Either` has instances for 10 different type classes, and each implementation for a type class only needs to handle two cases (i.e. the `Left` constructor and the `Right` constructor), then `D = C * 2` for `Either`. (Note: This number increases if `Either`'s instance for some type class needs to handle more than 2 cases.)

At the first-order level, there are `D` different ways to use **just** the `Either` type. Other more complicated types might have a small `C` but a large `B` and `D`. Other simpler types might have a small `B` and `D` but have a large `C`. One might search for a function only to realize that a type's implementation for some type class is that exact function.

On the second-order level... Once you know how to use one `C` for `A`, you can use it alongside of `E` other data structures' implementation for the same or different type class, `F`.

On the third-order level... A basic library or framework, `L`, that uses a number of approaches from the second-order level expects you to write second-order level code immediately. Since you are still getting familiar with the first-order level, it often feels confusing and overwhelming.

In short, if you don't understand one foundational concept, you will get lost and confused almost immediately. To add to the difficulty, you often don't know why you don't understand something.

4. Due to number 3, one needs to understand
    - `x`: abstract ideas that are turned into type classes
    - `y`: a number of basic data types (e.g. `Either`) and how they implement various type classes.
Thus, one quickly asks, "What do we teach first: `x` or `y` since teaching one requires the teaching the other, too?"

If you start with one `x`, it's easy to teach multiple `y`'s and show how they implement it. However, the new learner quickly becomes one-sided because they cannot write much code without multiple `x`'s.

If you start with multiple `x`'s but only one `y`, you can cover a number of type classes, but the new learner is one-sided because they cannot write much code without multiple `y`'s.

Teaching materials will likely be over balanced in one or the other. To really know and learn, you will have to do both eventually.

**This learning repo will take the second approach: teaching multiple `x`'s with only one `y` to help you build a foundation before expecting you to learn about the other `y`s.**
