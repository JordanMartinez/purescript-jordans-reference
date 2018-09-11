# Philosophical Foundations for FP

Functional Programming utilizes functions to create programs and focuses on separating pure functions from impure functions. It also first describes computations before running them instead of executing them immediately.

## Pure vs Impure

### Properties

Pure functions have 3 properties, but the third (marked with `*`) is expanded to show its full weight:

|     | Pure | Pure Example | Impure | Impure Example |
| --- | ---- | ------------ | ------ | -------------- |
| Given an input, will it always return some output? | Always <br> (Total Functions) | `n + m` | Sometimes <br> (Partial Functions) | `4 / 0 == undefined`
| Given the same input, will it always return the same output? | Always <br> (Deterministic Functions) | `1 + 1` always equals `2` | Sometimes <br> (Non-Deterministic Functions) | `random.nextInt()`
| *Does it interact with the real world? | Never |  | Sometimes | `file.getText()` |
| *Does it acces or modify program state | Never | `newList = oldList.removeElemAt(0)`<br>Original list is copied but never modified | Sometimes | `x++`<br>variable `x` is incremented by one.
| *Does it throw exceptions? | Never | | Sometimes | `function (e) { throw Exception("error") }` |

In many OO languages, pure and impure code are mixed everywhere, making it hard to understand what a function does without examining its body. In FP languages, pure and impure code are separated cleanly, making it easier to understand the code without looking at its implementation.

Programs written in an FP language usually have just one entry point via the `main` function. `Main` is an impure function that calls pure code.

Sometimes, FP programmers will still write impure code, but they will restrict the impure code to a small local scope to prevent any of its impurity from leaking. For example, sorting an array's contents by reusing the original array rather than copying its contents into a new array. Again, impure code is not being completely thrown out; rather, it is being clearly distinguished from pure code, so that one can understand the code faster and more easily.

### Graph Reduction

Since FP functions are pure, one can replace the left-hand side (LHS) of a function with its right-hand side (RHS), or the body/implementation of the function:
```purescript
function :: Int -> Int -> Int
function n m = n + m

function 4 3
-- replace LHS with RHS
4 + 3
7

(\arg1 arg2 arg3 -> arg1 + arg2 + arg3) 1 2 3
-- replace LHS with RHS
(\     arg2 arg3 -> 1    + arg2 + arg3)   2 3
(\          arg3 -> 1    +    2 + arg3)     3
(\               -> 1    +    2 +    3)
                    1    +    2 +    3
                    1    +    5
                    6
```

### Looping

In most OO languages, one writes loops using `while` and `for`:
```javascript
// factorial
var count = 0
var fact = 1
while (count != 5) {
  fact = fact * count
  count = count + 1
}
```

Looping in that matter makes it very easy to include impure code. So, in FP languages, one writes loops using recursion, pattern-matching, and tail-call optimization:
```purescript
factorial :: Int -> Int
factorial 1 = 1                       -- base case
factorial x = x * (factorial (x - 1)) -- recursive case

factorial 3
-- reduces via a graph reduction...
3 * (factorial (3 - 1))
3 * (factorial 2)
3 * 2 * (factorial (2 - 1))
3 * 2 * (factorial 1)
3 * 2 * 1
6 * 1
6
```

## Execution vs Description and Interpretation

```purescript
-- Most OO languages
executeCode :: Int
executeCode = 3

-------------------------------

-- FP languages
data Unit = Unit

unit :: Unit
unit = Unit

type ComputationThatReturns a = (Unit -> a))

describeCode :: ComputationThatReturns Int
describeCode = (\_ -> 3)

interpretDescription :: ComputationThatReturns Int -> Int
interpretDescription compute = compute unit
```

In short, FP programs are "descriptions" of what to do (i.e. data structures) that are later "interpreted" (i.e. executed) by a RunTime System (RTS).

## Lazy vs Strict

A computation can either be lazy or strict:
| Term | Definition | Pros | Cons
| - | - | - | - |
| Strict | computes its results immediately | Expensive computations can be run at the most optimum time | Wastes CPU cycles and memory for storing/evaluating expensive compuations that are unneeded/unused |
| Lazy | defers compututation until its needed | Saves CPU cycles and memory: unneeded/unused computations are never computed | When computations will occur every time, this adds unneeded overhead

## Data Types

### Principles

In order to abide by the principle of pure functions, FP Data Types tend to adhere to two principles:

1. Immutable - the data does not change once created. To modify the data, one must create a copy of the original that includes the update.
2. Persistent - Rather than creating the entire structure again when updating, an update should create a new 'version' of a data structure that includes the update

For example...
```purescript
{-
Given a linked-list type where
  "Nil" is a placeholder representing the end of the list
  "←" in "left ← right" is a pointer that points from the
      right element to the left element
  "=" in "list = x" binds the 'x' name to the 'list' value          -}
Nil ← 1 ← 2 ← 3 = x
                                                                    {-
To change x's `2` to `4`, we would create a new 'version' of 'x'
  that includes the unchanged tail (Nil ← 1)
  followed by the new update (← 4) and
  a copy of the rest of the list (← 3).                            -}
Nil ← 1 ← 2 ← 3 = x
      ↑
      4 ← 3 = y

-- At the end of the computation, these are true:
x == x
x /= y

-- x =  [3, 2, 1]
-- y =  [3, 4, 1]
-- index 0  1  2
(indexAt 2 x) isTheSameObjectAs (indexAt 2 y)
```

### Big O Notation

FP data types have `amortized` costs. In other words, most of the time, using a function on a data structure will be quick, but every now and then that function will take longer. Amortized cost is the overall "average" cost of using some function.

These costs can be minimized by making data structures `lazy` or by writing impure code in a specific non-leaking context.

## Type Classes

Type classes abstract general concepts into an "interface" that can be implemented by various data types. They define three things:
1. Functions/Values' type signatures, so that implementations must be able to match those signatures.
2. Laws to which an implementation must adhere.
3. Derived functions, functions that are obtained for free once one implements a type class for a particular data type.

## Why is Learning Functional Programming Hard?

1. Pure functions are more restrictive than impure ones. It takes a while to learn how to do the same thing in FP code that one does in OO code.
2. FP is heavily based on Category Theory (CT), which is very abstract and mathematical, and names its concepts after CT. This implies a lot of unfamiliar jargon that you've never heard of before.
3. Since FP code must work or not compile, debugging a compiler error can be difficult because of using complex types and having type inference work in unexpected ways.
3. CT makes it possible to solve a problem in a number of different ways. It's easy to get lost in it all due to three levels:

On the first-order level...
```purescript
data Either a b
  = Left a
  | Right b
```
A type, `A` (e.g. `Either`), can have one to N different constructors/instances, `B` (e.g. 2 for `Either`), and an implementation for a type class requires implementing its function for all `B` (e.g. for Either, 2 per type class). If there are `C` different type classes, there are `2*C` different ways to use **just** `Either`. Now do that for `D` different data structures and you get `(Ds' Bs) * C` or a lot of different things to know!

On the second-order level... Once you know how to use `A`'s instance of `C`, you can compose it with `D` other data structures' implementation for the same or different type class, `E`. So, now you have `((A's B) * C) * ((Ds' Bs) * E)`, or exponentially more things to know!
``

On the third-order level... A basic library or framework, `L`, that uses a number of approaches from the second-order level expects you to write second-order level code immediately.

FP = Data Types + Type Classes + Understanding the relationships between multiple data types' type class implementations

In short, if you don't understand one foundational concept, you will get lost and confused almost immediately. To add to the difficulty, you often don't know why you don't understand something.

4. Due to number 3, one needs to understand
    - `x`: abstract ideas that are turned into type classes
    - `y`: a number of basic data types (e.g. `Either`) and how they implement various type classes.
Thus, one quickly asks, "What do we teach first: `x` or `y` since teaching one requires the teaching the other two, too?"

If you start with one `x`, it's easy to show how multple `y`'s implement it. However, the new learner quickly becomes one-sided because they cannot write much code without multiple `x`'s.

If you start with multiple `x`'s but only one `y` and its `z`, you can cover a number of type classes, but the new learner is one-sided because they cannot writee much code without multiple `y`'s.

Teaching materials will likely be over balanced in one or the other. To really know and learn, you will have to do both eventually.
