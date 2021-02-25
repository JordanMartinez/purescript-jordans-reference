# Equational Reasoning

## Graph Reduction

In source code, we can describe the various parts of a function based on which side of the `=` character the content appears:
- Left-Hand Side (LHS): the function name and all of its arguments
- Right-Hand Side (RHS): the body or implementation of the function

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
