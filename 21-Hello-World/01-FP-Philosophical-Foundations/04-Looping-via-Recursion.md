# Looping via Recursion

In most OO languages, one writes loops using `while` and `for`. Looping in that matter makes it very easy to introduce impure code. So, in FP languages, one writes loops using recursion, pattern-matching, and tail-call optimization. The rest of this file will compare OO code to its FP counterpart

## For

```javascript
// factorial
var count = 5;
var result = 1;
for (var i = 2; i < count; i++) {
    result = result * i
}
```

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

## While

```javascript
while (condition == true) {
  if (shouldStop()) {
    condition = false
  } else {
    doSomething();
  }
}
```

```purescript
data Unit = Unit

whileLoop :: Boolean -> (Unit -> Boolean) -> (Unit -> Unit) -> Unit
whileLoop false _ _ = -- body
whileLoop true shouldStop doSomething =
  -- `doSomething unit` is called in here somewhere
  -- at the end of the function's body, it will call
  whileLoop (shouldStop unit) shouldStop doSomething
```

## For In

```javascript
// length
var count = 0;
for (value in list) {
  count += 1;
}
```

```purescript
data List a
  = Nil
  | Cons a (List a)

length :: forall a. List a -> Int -> Int
length Nil totalCount = totalCount
length (Cons head tail) currentCount =
  length tail (currentCount  + 1)
```
(There is a better way to write this in FP languages, but we won't explain it now)
