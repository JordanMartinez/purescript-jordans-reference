# Looping via Recursion

In most OO languages, one writes loops using `while` and `for`. Looping in that matter makes it very easy to introduce impure code. So, in FP languages, one writes loops using recursion, pattern-matching, and tail-call optimization. The rest of this file will compare OO code to its FP counterpart

## For `i` until `condition` do `computation` and then increment `i`

```javascript
// factorial
var count = 5;
var result = 1;
for (var i = 2; i < count; i++) {
    result = result * i
}
```

```haskell
-- This is a stack-unsafe function (explained and improved next)
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

### Stack-Safe

The above Purescript example illustrates a problem that comes with writing loops this way: stack overflows. Thus, when one says "this function is `stack-safe`", they mean that calling the function will not risk the possibility of a stack overflow runtime error being produced. One usually prevents this risk via tail-call optimization (which usually converts the recursive loop back into an OO loop) or trampolining (when tail-call optimization isn't possible)

Thus, one will usually write recursive functions in this manner. Rather than using recursion to calculate the value by creating a 'stack' of `*` operations (as done above), one will pass into the function an additional argument that acts as the accumulated value. The necessary state change / calculation is done and its result is passed in as the new accumulated value in the next iteration of the recursive function call:
```haskell
factorial :: Int -> Int
factorial n = factorial' n 1

factorial' :: StartingInt -> AccumulatedInt -> AccumulatedInt
factorial' 1 finalResult = finalResult
factorial' amountRemaining accumulatedSoFar =                             {-
  -- This is the general idea being done in the single line of code
  -- after this comment
  let
    oneLess = amountRemaining - 1
    nextAccumulatedValue = accumulatedSoFar * amountRemaining
  in
    factorial' oneLess nextAccumulatedValue                               -}
  factorial' (amountRemaining - 1) (amountRemaining * accumulatedSoFar)

factorial 4
-- reduces via a graph reduction...
factorial' 4 1
factorial' 3 4
factorial' 2 12
factorial' 1 24
24
```

In some cases, one will need to write more complex code to get the desired performance using a combination of defunctionalization and continuation-passing style (CPS). This is covered in more detail in the `Design Patterns/Defunctionalization.md` file.

## For ... Break If

```javascript
// findFirst
var findFirst = (array, condition) => {
  var length = array.length();
  for (var i = 0; i < length; i++) {
      var value = array[i]
      if (condition(value)) {
        return value;
      }
  }
  return null;
}
findFirst([0, 1, 2], (i) => i == 1);
```

```haskell
-- linked list
data List a
  = Nil             -- end of the list
  | Cons a (List a) -- head of a linked list & rest of list

data Maybe a
  = Nothing   -- could not find a value of type A
  | Just a    -- found a value of type A

findFirst :: forall a. List a -> (a -> Boolean) -> Maybe a
findFirst list condition = findFirst' list condition Nothing

findFirst' :: forall a. List a -> (a -> Boolean) -> Maybe a -> Maybe a
findFirst' Nil condition notFound = notFound
findFirst' (Cons head tail) condition theA@(Just alreadyFound) =
  findFirst' tail condition theA
findFirst' (Cons head tail) condition Nothing =
  let foundOrNot = if (condition head) then (Just head) else Nothing
  in findFirst' tail condition foundOrNot

findFirst (Cons 0 (Cons 1 (Cons 2 Nil))) (\el -> el == 1)
-- reduces via a graph reduction...
findFirst' (Cons 0 (Cons 1 (Cons 2 Nil))) (\el -> el == 1) Nothing
findFirst'         (Cons 1 (Cons 2 Nil))  (\el -> el == 1) Nothing
findFirst'                 (Cons 2 Nil)   (\el -> el == 1) (Just 1)
findFirst'                         Nil    (\el -> el == 1) (Just 1)
Just 1
```

### Short-Circuiting

The above Purescript example illustrates another problem with writing loops this way: `short-circuiting`. There are times when we wish to break out of a recursion-based loop early, such as when we have found the first element of a collection. In the above example, the function does not short-circuit, so it continues to iterate through the list even after it has found the element, leading to wasted CPU time and work.

To make the function above short-circuit, we would rewrite the function to this:
```haskell
-- linked list
data List a
  = Nil             -- end of the list
  | Cons a (List a) -- head of a linked list & rest of list

data Maybe a
  = Nothing   -- could not find a value of type A
  | Just a    -- found a value of type A

findFirst :: forall a. List a -> (a -> Boolean) -> Maybe a
findFirst Nil condition = Nothing
findFirst (Cons head tail) condition =
  if (condition head)
  then Just head
  else findFirst' tail condition

findFirst (Cons 0 (Cons 1 (Cons 2 Nil))) (\el -> el == 1)
-- reduces via a graph reduction...
findFirst         (Cons 1 (Cons 2 Nil))  (\el -> el == 1)
Just 1
```

## Other Loops

The following Purescript examples are very _crude_ ways of mimicking the following loops. More appropriate examples would require explaining and using type classes like `Foldable`, `Unfoldable`, and `Monad` (intermediate FP concepts). Thus, take these examples with a grain of salt.

### While

```javascript
while (condition == true) {
  if (shouldStop()) {
    condition = false
  } else {
    doSomething();
  }
}
```

```haskell
data Unit = Unit

whileLoop :: Boolean -> (Unit -> Boolean) -> (Unit -> Unit) -> Unit
whileLoop false _ _ = -- body
whileLoop true shouldStop doSomething =
  -- `doSomething unit` is called in here somewhere
  -- at the end of the function's body, it will call
  whileLoop (shouldStop unit) shouldStop doSomething
```

### For `value` in `collection`

```javascript
// length
var count = 0;
for (value in list) {
  count += 1;
}
```

```haskell
data List a
  = Nil
  | Cons a (List a)

length :: forall a. List a -> Int -> Int
length Nil totalCount = totalCount
length (Cons head tail) currentCount =
  length tail (currentCount  + 1)
```
