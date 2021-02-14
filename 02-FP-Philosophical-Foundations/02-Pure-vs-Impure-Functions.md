# Pure vs Impure Functions

## Visual Overview

![Pure and Impure Functions](./assets/Pure-and-Impure-Functions.svg)

Functional Programming utilizes functions to create programs and focuses on separating pure functions from impure functions. It also first describes computations before running them instead of executing them immediately.

## General Overview

### Properties

<hr>
The following table that shows a comparison of pure and impure functions is licensed under CC BY-SA 4.0:

- Original Credit: Sam Halliday - ["Functional Programming for Mortals with Scalaz"](https://leanpub.com/fpmortals)
- License: [legal code](https://creativecommons.org/licenses/by-sa/4.0/legalcode) & [legal deed](https://creativecommons.org/licenses/by-sa/4.0/)
- Changes made
    - Converted idea into a table that compares pure functions with impure functions
    - Further expand on "does it interact with the real world" idea with more examples from the original work

Pure functions have 3 properties, but the third (marked with `*`) is expanded to show its full weight:

|     | Pure | Pure Example | Impure | Impure Example |
| --- | ---- | ------------ | ------ | -------------- |
| Given an input, will it always return some output? | Always <br> (Total Functions) | `n + m` | Sometimes <br> (Partial Functions) | `4 / 0 == undefined`
| Given the same input, will it always return the same output? | Always <br> (Deterministic Functions) | `1 + 1` always equals `2` | Sometimes <br> (Non-Deterministic Functions) | `random.nextInt()`
| *Does it interact with the real world? | Never |  | Sometimes | `file.getText()` |
| *Does it access or modify program state | Never | `newList = oldList.removeElemAt(0)`<br>Original list is copied but never modified | Sometimes | `x++`<br>variable `x` is incremented by one.
| *Does it throw exceptions? | Never | | Sometimes | `function (e) { throw Exception("error") }` |

<hr>

In many OO languages, pure and impure code are mixed everywhere, making it hard to understand what a function does without examining its body. In FP languages, pure and impure code are separated cleanly, making it easier to understand what the code does without looking at its implementation.

Programs written in an FP language usually have just one entry point via the `main` function. `Main` is an impure function that calls pure code.

Sometimes, FP programmers will still write impure code, but they will restrict the impure code to a small local scope to prevent any of its impurity from leaking. For example, sorting an array's contents by reusing the original array rather than copying its contents into a new array. Again, impure code is not being completely thrown out; rather, it is being clearly distinguished from pure code, so that one can understand the code faster and more easily.

### Graph Reduction

In source code, we can describe the various parts of a function based on which side of the `=` character the content appears:
- Left-Hand Side (LHS): the function name and all of its arguments
- Right-Hand Side (RHS): the body or implementation of the function\

```haskell
|         LHS         |    |     RHS     |
functionName int1 int2   =   int1 + int2
```

When using pure functions, one can replace the LHS with the RHS, and the program will still work the same. This concept is known as **referential transparency**:
```haskell
functionName 4 3
-- replace LHS with RHS
4 + 3
-- reduce into final form
7
-- Calling `function 4 3` could be removed and replaced
-- with `7` and the program would work the same

-- Similarly, the below function (a longer form syntactically) and its arguments
-- could be replaced with `6` and the program would work fine.
(\arg1 arg2 arg3 -> arg1 + arg2 + arg3) 1 2 3
-- replace LHS with RHS
(\     arg2 arg3 ->    1 + arg2 + arg3)   2 3
(\          arg3 ->    1 +    2 + arg3)     3
(\               ->    1 +    2 +    3)
                       1 +    2 +    3
                       1 +    5
                       6
```

Although the above examples are very simple functions, imagine if one's entire program was one function that exhibited this behavior. If so, it would be very easy to understand and reason one's way through such a program.

## Execution vs Description and Interpretation

```haskell
-- Most OO languages
executeCode :: Int
executeCode = 3

-------------------------------

-- FP languages
-- a type with only one value, Unit
data Unit = Unit

-- Rather than write "Unit", we can now write 'unit' to refer to that value.
unit :: Unit
unit = Unit

-- A function that takes a 'unit' as an input type and returns a 'someValue' type
-- The type of 'someValue' will be defined later.
type ComputationThatReturns someValue = (Unit -> someValue)

describeCode :: ComputationThatReturns Int
describeCode unitValue__neverUsed = 3

interpretDescription :: ComputationThatReturns Int -> Int
interpretDescription compute = compute unit
-- using a graph reduction, this ends up looking like:
--
-- compute unit
-- (\unitValue__neverUsed -> 3) unit
-- (                      -> 3)
--                           3
-- 3
```

In short, FP programs are "descriptions" of what to do that are later "interpreted" (i.e. executed) by a RunTime System (RTS).
