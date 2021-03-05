# Equational Reasoning

Functions in FP languages often work like equations: the left-hand side can be replaced by the right-hand side. We'll cover this idea more in the graph reduction section. This idea enables a developer to solve a problem using a simple but not performant solution that can be easily refactored to a much more performant version of the solution. We'll cover this in the "Optimizing Functions" section.

## Graph Reduction: Running a Function

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

## Optimizing Functions: From Simplicity to Performant

This section summarizes the main ideas explained in **Algorithm Design with Haskell** ([Cambridge](https://www.cambridge.org/us/academic/subjects/computer-science/algorithmics-complexity-computer-algebra-and-computational-g/algorithm-design-haskell?format=HB), [Amazon](https://www.amazon.com/Algorithm-Design-Haskell-Richard-Bird/dp/1108491618)).

Above, we showed that functions are "run" by using graph reduction: the left-hand side is replaced with the right-hand side. However, this idea also applies when we refactor code, enabling the following developer workflow:
1. Solve a programming problem by composing multiple high-level functions together. Initially, this version of the solution will not be performant.
1. "Decompose" the high-level functions by replacing their call site (i.e. left-hand side) with their implementations (i.e. right-hand side)
1. Use laws to refactor how those implementations compose to reduce unneeded work.

Typically, the 'laws' above are from type classes. When we see that a function "decomposes" to `map function1 (map function 2)`, which iterates through some collection twice, we can rewrite it to `map (\arg -> function1 (function2 arg))`, which iterates through some collection once but still produces the same output.

Following this workflow makes it easier to solve all programming problems. In particular, this workflow helps when writing a greedy algorithm or a dynamic programming algorithm.

Let's provide two other examples of this idea. To keep things simple for those who don't understand PureScript's syntax, we'll not use laws to guide refactoring.

### Example 1

As a very simple example, consider the following programming problem:
> Given an array of integers, `arr`, that will have 0 - 20 elements, define a function, `countTwoFourSum`, that calculates how often a 2 or 4 appears in the array (i.e. its count) and sums the resulting counts together. For example
>
>> countTwoFourSum([1, 2, 3, 4]) == 2
>> countTwoFourSum([1, 3, 5, 7]) == 0
>> countTwoFourSum([2, 2, 3, 6]) == 2
>> countTwoFourSum([2, 2, 3, 4]) == 3

Using Step 1 above, the simplest solution would be to write something like this:
```javascript
var countTwoFourSum = function(arr) {
  return count(arr, 2) + count(arr, 4);
};
var count = function (arr, value) {
  var accumulatedValue = 0;
  for (var i = 0; i < arr.length; i++) {
    var nextElem = arr[i];
    if (nextElem == value) {
      accumulatedValue = accumulatedValue + 1;
    }
  }
  return accumulatedValue;
};
```
Translating that to PureScript, we would write:
```purescript
countTwoFourSum :: Array Int -> Int
countTwoFourSum arr =
  (count arr 2) + (count arr 4)

count :: Array Int -> Int -> Int
count arr value = foldl countIfValue initialAccumulatedValue arr
  where
  initialAccumulatedValue = 0

  countIfValue accumulatedValue nextElem =
    if nextElem == value then accumulatedValue + 1 else accumulatedValue
```

While it is easy to think of the solution to this code by writing it in this way, it's not performant because we loop through the array twice.

In step 2, we can replace the original function, `count`, with its implementation.
```purescript
countTwoFourSum :: Array Int -> Int
countTwoFourSum arr =
  (foldl countIfTwo initialAccumulatedValue arr) +
  (foldl countIfFour initialAccumulatedValue arr)
  where
  initialAccumulatedValue = 0

  countIfTwo accumulatedValue nextElem =
    if nextElem == 2 then accumulatedValue + 1 else accumulatedValue

  countIfFour accumulatedValue nextElem =
    if nextElem == 4 then accumulatedValue + 1 else accumulatedValue
```

In step 3, we refactor the resulting computation to be more performant. Below, we iterate through the array once rather than twice by using only one `foldl`.
```purescript
countTwoFourSum :: Array Int -> Int
countTwoFourSum arr =
  let finalCount = foldl countIfValues initialAccumulatedValue arr
  in finalCount.twoCount + finalCount.fourCount
  where
  initialAccumulatedValue = {twoCount: 0, fourCount: 0}

  countIfValues {twoCount, fourCount} nextElem =
    { twoCount: if nextElem == 2 then twoCount + 1 else twoCount
    , fourCount: if nextElem == 4 then fourCount + 1 else fourCount
    }
```

### Example 2

The above example illustrates this workflow but isn't the most impressive example. Here's a slightly more complex example. Let's say a programmer is reading through a description of a problem and its desired output. Piece by piece, she types out the below code as a solution to each part of the problem:
```purescript
map fromString stringArray -- 1. convert each string element into
                           --       an integer (if possible)
 # catMaybes               -- 2. remove elements where the string wasn't an integer
 # map (_ + 1)             -- 3. add one to each integer
 # sum                     -- 4. sum all the resulting integers into a value
```
While the above code solves the problem, it is not performant. It iterates through an array multiple times and creates multiple intermediate arrays. By using equational reasoning (not shown below), we can speed this up to a single iteration:
```purescript
foldl f init stringArray
where
  init = 0
  f acc next =
    case fromString next of
      Nothing -> acc
      Just i -> acc + i + 1
```

Crucially, our first focus was on writing a correct solution and then on making it performant.
