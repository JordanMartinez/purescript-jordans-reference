# Seeing and Solving the Problem in FP Code

> The goal is to define a data type by cases, where
> 1. one can add new cases to the data type and
> 2. (one can add) new functions over the data type,
> 3. without recompiling existing code, and
> 4. while retaining static type safety.

## A Very Simple Example of The Problem

Given this code
```haskell
data Fruit
  = Apple
  | Banana

showFruit :: Fruit -> String
showFruit Apple = "apple"
showFruit Banana = "banana"
```
We can easily add a new function to our code without needing to recompile our existing code
```haskell
-- in another file...
intFruit :: Fruit -> Int
intFruit Apple = 0
intFruit Banana = 1
```
However, if we want to add another data constructor to `Fruit`, we can only do so by updating `Fruit` to include `Orange` **and then** updating all of our functions to include `Orange` as well:
```haskell
data Fruit
  = Apple
  | Banana
  | Orange

showFruit :: Fruit -> String
showFruit Apple = "apple"
showFruit Banana = "banana"
showFruit Orange = "orange"
```
Since `Fruit` has already been compiled, we will need to recompile our code with the updated version of `Fruit`. Moreover, if we do not update `showFruit`/`intFruit`, then we no longer have an exhaustive pattern match. Thus, these functions are no longer pure but are now partial functions.

## The Solution

The solution, then, is to be able to define data types in such a way that they "compose". The best way to compose data types is to group two types into one type via a type wrapper:
```haskell
-- original file
data Fruit
  = Apple
  | Banana

-- new file
data Fruit2
  = Orange

data FruitGrouper = -- ???
```
How should `FruitGrouper` be defined? A value of `FruitGrouper` should only be one of 3 values:
1. FruitGrouper Apple
2. FruitGrouper Banana
3. FruitGrouper Orange

We can define it using this approach:
```haskell
data FruitGrouper
  = Fruit_  Fruit
  | Fruit2_ Fruit2
```
This approach will enable `showFruit` and `intFruit` to continue to work as expected. If we wanted to define a new function that uses both, we would pass in `FruitGrouper` instead:
```haskell
-- original file. This cannot change once written!
data Fruit
  = Apple
  | Banana

showFruit :: Fruit -> String
showFruit Apple = "apple"
showFruit Banana = "banana"

-- new file
data Fruit2
  = Orange

data FruitGrouper
  = Fruit_  Fruit
  | Fruit2_ Fruit2

showAllFruit :: FruitGrouper -> String
showAllFruit (Fruit_  appleOrBanana) = showFruit appleOrBanana
showAllFruit (Fruit2_ Orange) = "orange"
```
Great! We have now seen how to solve a **very simple version** of this problem. Now, let's refine this approach a bit as preparation for a future harder problem.
