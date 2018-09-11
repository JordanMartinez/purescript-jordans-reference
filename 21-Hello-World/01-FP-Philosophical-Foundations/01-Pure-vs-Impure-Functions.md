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
