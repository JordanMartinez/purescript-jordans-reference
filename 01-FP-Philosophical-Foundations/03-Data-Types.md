# Data Types

## Principles

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
```
Using a more visual diagram:

![Immutable-Persistent-Via-List](./assets/Immutable-Persistent-via-List.svg)

```purescript
-- At the end of the computation, these are true:
x == x
x /= y

-- x =  [3, 2, 1]
-- y =  [3, 4, 1]
-- index 0  1  2
(indexAt 2 x) isTheSameObjectAs (indexAt 2 y)
```

## Big O Notation

FP data types have `amortized` costs. In other words, most of the time, using a function on a data structure will be quick, but every now and then that function will take longer. Amortized cost is the overall "average" cost of using some function.

These costs can be minimized by making data structures `lazy` or by writing impure code in a way that doesn't "leak" its impurity into the surrounding context.
