# Type Classes

## What Problem Do Type Classes Solve?

Their primary use is to make writing some code more convenient / less boilerplatey. Rather than writing the same code 25 different times where it differs in only one way each time, we can write code once and "parameterize it" in 25+ different ways.

To see a bottom-up explanation of this idea, read through the bullet points below and then watch the video.
- This video is a recording of a presentation given by Nathan Faubion, a core contributor to PureScript.
- This video finishes explaining what type classes are around 22:54.
- The parts that follow are more advanced concepts. They explain how to make "real world code" easily testable via type classes and interpreters. You might not understand those explanations until you are more familiar with PureScript syntax.
- The presentation ends at 1:03:58. Nate starts answering people's questions after that.
- Nate's answers to various questions ends at 1:13:12 and the rest of the video are people talking about various PureScript things.
- While Nate explains that type classe enable "code reuse," one could use an approach called "scrap your type classes" (SYTC) to accomplish that goal. SYTC will be covered later in this file.

Video: [Code Reuse in PureScript: Functions, Type Classes, and Interpreters](https://youtu.be/GlUcCPmH8wI?t=24) (actual video title on YouTube: "PS Unscripted - Code Reuse in PS: Fns, Classes, and Interpreters")

## Where Do Type Classes Come From?

Type classes are usually "encodings" of various concepts from mathematics.

Type classes make developers productive. They enable programmers...
    - to write 1 line of code that is the equivalent of writing 100s of lines of code.
    - to define complicated control flows that highlight the important parts and minimize the irrelevant boilerplatey parts (e.g. nested "if then else" statements)
    - to use (in general) 5 ["dumb reusable data types"](https://www.youtube.com/embed/hIZxTQP1ifo?start=1225&end=1334) to solve most of our problems:
      - Maybe - a box that is either empty or has a value.
      - Either - a sum type: either has a Left value or a Right value
      - Tuple - a product type: has both an A value and a B value
      - List - self-explanatory
      - Tree - self-explanatory

## Type Classes as Encodings of Mathematical Concepts

Type classes often encode ideas that are true regardless of what we call them (i.e. "necessary" concepts), but functional programmers will refer to them via jargon (i.e "arbitrary" names like `Functor`). (For more context on the usage of "necessary" and "arbitrary" as terms, see [Arbitrary and Necessary Part 1: a Way of Viewing the Mathematics Curriculum](https://flm-journal.org/Articles/2D02A71022192F96A5A92F55B04AB0.pdf)).

Putting it differently, if `Some type` can implement some `function(s)/value(s) with a specified type signature` in such a way that the implementation adheres to `specific laws`, one can say it **has** an instance of the given type class. Some types cannot satisfy a given type class' conditions; others can satisfy them in only one way; and still others can satisfy them in multiple ways. Thus, one does not say "`Type X` **is** an instance of &lt;some type class&gt;." Rather, one says "`Type X` **has** an instance of &lt;some type class&gt;." To see this concept in a clearer way and using pictures, see https://www.youtube.com/watch?v=iJ7V1KXJpsE

Thus, type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 2-3 things:

1. (Always) The definition of type signatures for one or more functions/values.
    - Functions may be put into infix notation using symbolic aliases (e.g. `<$>`) to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
    - **Laws cannot be enforced by the compiler.** For example, one could define a type class' instance for some type which satisfies the type signature. However, the implementation of that instance might not satisfy the type class' law(s). The compiler can verify that the type signature is correct, but not the implementation. Thus, one will need to insure an instance's lawfulness via tests, (usually by using a testing library called `quickcheck-laws`, which is covered later in this repo)
3. (Frequently) The additional functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.

### Examples

Here are some examples that demonstrate the combination of the 2-3 elements from above:
- The `Eq` type class.
    - Required type signatures:
      - `eq :: a -> a -> Boolean` (Note: `a == b` is the same as `eq a b`)
    - Laws
      - Reflexivity: `x == x`
      - Symmetry: if `x == y`, then `y == x`
      - Transitivity: if `x == y` and `y == z`, then `x == z`
    - Derived Functions
      - `notEq`, which inverts the result of `eq`: `notEq a b = not (a == b)`
- The `Monoid` type class
    - Required type signatures:
      - `append :: a -> a -> a` (Note: `a <> b` is the same as `append a b`)
      - `mempty :: a`
    - Laws
      - Left unit: `(mempty <> x) == x` (Note: `0 + 1 == 1` is an example of this idea)
      - Right unit: `(x <> mempty) == x` (Note: `"hello" <> "" == "hello"` is an example of this idea)
    - Derived Functions
      - `power :: a -> Int -> a`: append a value to itself N times (e.g. `power "a" 4 == "aaaa"`)
      - `guard :: Boolean -> a -> a`: return either the `a` or `mempty` (e.g. `guard false "a" == ""` and `guard true "a" == "a"`)

## Similarities and Dual Relationships Among Type Classes

Some type classes have a corresponding "dual". While there are better ways to explain duals, the basic idea is that the "direction" of the function's arrow gets flipped. When this happens, we usually prefix them with "Co". For example, if we have a type class called `Monad`, the dual of it is called `Comonad`. If `Monad` has laws `A` and `B`, then it's likely that `Comonad` will have laws `A'` (pronounced "A-prime") and `B'` (pronounced "B-prime"), which are "flipped" version of `A` and `B`.

For example, a function like `toB` would have its arrow flipped to produce `toA`::

```haskell
-- original
toB :: a -> b
toB = -- function's implementation
                                                                              {-
-- 1. Drop the implementation
toB :: a <- b
toB =

-- 2. Flip the arrow
toB :: a <- b
toB =

-- 3. Reorder the arguments so that arrow is pointing to the right:
toB :: b -> a
toB =

-- 4. Rename the function
toA :: b -> a
toA =                                                                         -}

-- Dual version
toA :: b -> a
toA = -- function's implementation
```
