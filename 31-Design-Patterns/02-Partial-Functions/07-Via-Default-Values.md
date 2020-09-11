# Via Default Values

Unfortunately, the domain problem of safe division is not an example for how "default value" approach can convert a partial function into a total function.

So instead, we'll use the example of getting the first element in a linked list. In situations where the list is empty, it will throw an exception:
```haskell
-- partial function
head :: List Int -> Int
head Nil = -- Exception!
head (Cons head tail) = head
```
To make the function total, we can provide a value to return in such cases:
```haskell
-- total function
headOrDefault :: List Int -> Int -> Int
headOrDefault Nil default = default -- no more exceptions!
headOrDefault (Cons head tail) _ = head
```
