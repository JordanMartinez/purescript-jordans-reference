# Useful Monads

**Note:** This file's contents assumes you have read through and are somewhat familiar with the contents of the file, `Syntax/Prelude Syntax/Reading Do as Nested Binds.md`.

So far, we have only shown you the `Box` monad to help you get used to the syntax and see the logic for how `Monad` and `bind`/`>>=` works. (The `Box` type is a learner-friendly name for the `Identity` monad, which we'll cover later in the `Application Structure` folder.)

However, `Monads` are used to compose different functions. Whereas the `Box`/`Identity` monad only produces one output, the below types can produce 2 outputs. Functions that produce 2 outputs don't typically compose. However, the `Monad` type class enables us to compose them using "railway-oriented programming" (~Scott Wlaschin).

When we compose different monadic types, we get different control flows. The `do` notation helps us avoid the [Pyramid of Doom](https://www.wikiwand.com/en/Pyramid_of_doom_(programming)) boilerplate code and emphasizes developer intent.

## The Maybe Monad

In JavaScript, we might write this code:
```javascript
let a = computation();
if (a == null) {
  return null;
} else {
  let b = compute1(a);
  if (b == null) {
    return null;
  } else {
    let c = compute2(b);
    if (c == null) {
      return null;
    } else {
      return compute3(c);
    }
  }
}
```

In PureScript, we would write the following code:

```purescript
data Maybe a
  = Nothing
  | Just a

instance bindMonad :: Bind Maybe where
  bind :: forall a b. Maybe a -> (a -> Maybe b) -> Maybe b
  -- when given a Nothing, stop all possible future computations
  -- and return immediately.
  bind Nothing _ = Nothing
  -- when given a Just, run the function on its contents
  -- and continue any Monadic computations
  bind (Just a) f = f a

someComputation :: Maybe ReturnValue
someComputation = do
  a <- computation
  b <- compute1 1
  c <- compute2 b
  compute3 c
```

If a `Nothing` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.

What is a real-world example of using the Maybe monad? One often writes monadic code using Maybe as the Monad to lookup values in some structure (e.g. `Map`, `Array`, `List`, or `Tree`). Often, this control flow reads like this: "Try to get value X. If it exists, try to get value Y. If that exists, do something with both. If either one of them does not exist, throwdo something else." In other words...

```purescript
example :: Maybe String
example = do
  x <- index 4 array
  y <- lookup "fooKey" map
  pure (x + y)
```

## The Either Monad

In JavaScript, we might write this code:
```javascript
let a = computation();
if (isError(a)) {
  return a;
} else {
  let b = compute1(a);
  if (isError(b)) {
    retun b;
  } else {
    let c = compute2(b);
    if (isError(c)) {
      return c;
    } else {
      return compute3(c);
    }
  }
}
```

In PureScript, we would write this code:

```purescript
data Either a b
  = Left a
  | Right b

instance bindEither :: Bind (Either a) where
  bind :: forall b c. Either a b -> (b -> Either a c) -> Either a c
  -- when given a Left, stop all possible future computations
  -- and return immediately.
  bind l@(Left _) _ = l
  -- when given a Right, run the function on its contents
  -- and continue any Monadic computations
  bind (Right a) f = f a

someComputation :: Either ErrorType ReturnValue
someComputation = do
  a <- computation
  b <- compute1 1
  c <- compute2 b
  compute3 c
```

If a `Left` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.

What is a real-world example of using the Maybe monad? One often uses it to validate that some data is correct. It reads like, "Try to parse the given String into an Int. If it fails, stop. Otherwise, try to parse the given String into a Foo. If it fails, stop. Otherwise, take the Int and the Foo and do something with them."

```purescript
example :: String -> Either String ValidatedData
example string = do
  intValue <- parseString string
  fooValue <- parseNextPart
  doSomethingWith intValue fooValue
```

## The List Monad

In JavaScript, we would might write this code:
```javascript
let list1 = [1, 2, 3];
let list2 = [2, 3, 4];
let list3 = [3, 4, 5];
var finalList = [];

for (i in list1) {
  for (h in list2) {
    for (j in list3) {
      finalList = finalList.add(i + h + j);
    }
  }
}
return finalList;
```

In PureScript, we would write this code:

```purescript
data List a
  = Nil
  | Cons a (List a)

-- bind implementation not shown here
instance bindList :: Bind List where
  bind :: forall a b. List a -> (a -> List b) -> List b
  -- when given a Nil (end of list), stop all potential future computations and return immediately.
  bind Nil _ = Nil
  -- when given a non-empty list, run the future computations on the head
  -- and then prepend it to the rest of the computations on the tail.
  bind (head : tail) f = f head <> bind tail f

someComputation :: List Int
someComputation = do
  a <- (1 : 2 : 3 : Nil)
  b <- (2 : 3 : 4 : Nil)
  c <- (3 : 4 : 5 : Nil)
  pure (a + b + c)
```
which outputs:
```purescript
-- a = 1, b = 2
( 6 : 7 : 8
-- a = 1, b = 3
: 7 : 8 : 9
-- a = 1, b = 4
: 8 : 9 : 10

-- a = 2, b = 2
: 7 : 8 : 9
-- a = 2, b = 3
: 8 : 9 : 10
-- a = 2, b = 4
: 9 : 10 : 11

-- a = 3, b = 2
: 8 : 9 : 10
-- a = 3, b = 3
: 9 : 10 : 11
-- a = 3, b = 4
: 10 : 11 : 12

: Nil)
```

## Concluding Thoughts

Different monadic types lead to different control flow statements. We've only shown a few here.

We will see more control flow options in the `Application Structure` folder, but there's more ground-work to cover before it'll make sense.
