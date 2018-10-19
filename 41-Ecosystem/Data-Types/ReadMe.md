# Data Types

Purescript modulates many things. This makes code reusage better, but makes it harder for new learners to find the things they need, especially if they don't already know what they are looking for.

Some types in this folder are used for multiple purposes. The usages of these types will be explained here rather than explaining them when they need to be explained.

## Philosophical Foundations for FP Data Types

### Principles

FP Data Types tend to adhere to two principles:

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

### Lazy vs Strict

| Term | Definition | Pros | Cons
| - | - | - | - |
| Strict | computes its results immediately | Expensive computations can be run at the most optimum time | Wastes CPU cycles and memory for storing/evaluating expensive compuations that are unneeded/unused |
| Lazy | defers compututation until its needed | Saves CPU cycles and memory: unneeded/unused computations are never computed | When computations will occur every time, this adds unneeded overhead

### Big O Notation

FP data types have `amortized` costs. In other words, most of the time, using a function on a data structure will be quick, but every now and then that function will take longer. Amortized cost is the overall "average" cost of using some function.

These costs can be minimized by making data structures `lazy`, waiting to compute something until absolutely necessary. `Strict` data structures compute everything immediately, whether their results are ultimately needed/used or not.

## Deeper Reading

For a deeper explanation of Purely Functional Data Structures, read through Chris Okasaki's [thesis](https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf) or buy his [book](https://www.amazon.com/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504). Then see the answer to ["What's new in purely functional data structures since Okasaki?"](https://cstheory.stackexchange.com/questions/1539/whats-new-in-purely-functional-data-structures-since-okasaki)


## See Also

An explanation on ["higher-kinded data types"](http://reasonablypolymorphic.com/blog/higher-kinded-data/)
