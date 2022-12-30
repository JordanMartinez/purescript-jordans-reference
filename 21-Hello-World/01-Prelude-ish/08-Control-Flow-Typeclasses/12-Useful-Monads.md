# Useful Monads

**Note:** This file's contents assumes you have read through and are somewhat familiar with the contents of the file, `Syntax/Prelude Syntax/Reading Do as Nested Binds.md`.

So far, we have only shown you the `Box` monad to help you get used to the syntax and see the logic for how `Monad` and `bind`/`>>=` works. (The `Box` type is a learner-friendly name for the `Identity` monad, which we'll cover later in the `Application Structure` folder.)

However, `Monads` are used to compose two or more computations that occur within the same context (where context refers to the monadic type being used). Whereas the monadic type, `Box`/`Identity`, only has one possible value, the below types have two possible values. Functions that produce two possible outputs don't typically compose. However, the `Monad` type class enables us to compose them using "railway-oriented programming" (~Scott Wlaschin).

When we compose different monadic types, we get different control flows. The `do` notation helps us avoid the [Pyramid of Doom](https://www.wikiwand.com/en/Pyramid_of_doom_(programming)) boilerplate code and emphasizes developer intent.

## The Maybe Monad

### JavaScript Code

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

### PureScript Code (non-idiomatic)

In PureScript, we _could_ write the following **non-idiomatic** code that repeats this Pyramid of Doom:

```haskell
data Maybe a
  = Nothing
  | Just a

someComputation :: Maybe Unit
someComputation =
  case computation of
    Nothing -> Nothing
    Just a -> case compute1 a of
      Nothing -> Nothing
      Just b -> case compute2 b of
        Nothing -> Nothing
        Just c -> compute3 c
  where
    computation :: Maybe a
    compute1 :: a -> Maybe b
    compute2 :: b -> Maybe c
    compute3 :: c -> Maybe Unit
```

### PureScript Code (idiomatic)

Or, we could use `Maybe`'s `Monad` instance via `do notation` to write **idiomatic** PureScript code:

```haskell
data Maybe a
  = Nothing
  | Just a

instance Bind Maybe where
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
  b <- compute1 a
  c <- compute2 b
  compute3 c
  where
    computation :: Maybe a
    compute1 :: a -> Maybe b
    compute2 :: b -> Maybe c
    compute3 :: c -> Maybe Unit
```

If a `Nothing` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.

What is a real-world example of using the Maybe monad? One often writes monadic code using Maybe as the Monad to lookup values in some structure (e.g. `Map`, `Array`, `List`, or `Tree`). Often, this control flow reads like this: "Try to get value X. If it exists, try to get value Y. If that exists, do something with both. If either one of them does not exist, stop and return immediately." In other words...

```haskell
example :: Maybe String
example = do
  x <- index 4 array
  y <- lookup "fooKey" map
  pure (x + y)
```

## The Either Monad

### JavaScript Code

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

### PureScript Code (non-idiomatic)

```haskell
data Either a b
  = Left a
  | Right b

someComputation :: Either ErrorType ReturnValue
someComputation = do
  case computation of
    Left err -> Left err
    Right a -> case compute1 a of
      Left err -> Left err
      Right b -> case compute2 b of
        Left err -> Left err
        Right c -> compute3 c
  where
    computation :: Either ErrorType a
    compute1 :: a -> Either ErrorType b
    compute2 :: b -> Either ErrorType c
    compute3 :: c -> Either ErrorType Unit
```

### PureScript Code (idiomatic)

Or, we could use `Either`'s `Monad` instance via `do notation` to write **idiomatic** PureScript code:

```haskell
data Either a b
  = Left a
  | Right b

instance Bind (Either a) where
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
  b <- compute1 a
  c <- compute2 b
  compute3 c
```

If a `Left` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.

What is a real-world example of using the Either monad? One often uses it to validate that some data is correct. It reads like, "Try to parse the given `String` into an `Int`. If it fails, stop. Otherwise, try to parse the given `String` into a `Foo`. If it fails, stop. Otherwise, take the `Int` and the `Foo` and do something with them."

```haskell
example :: String -> Either String ValidatedData
example string = do
  intValue <- parseString string
  fooValue <- parseNextPart
  doSomethingWith intValue fooValue
```

## The List / Array Monad

We use the `List` type below in our examples. However, the `Array` type works exactly the same way.

## JavaScript Code

In JavaScript, we might write this code:
```javascript
let list1 = [1, 2, 3];
let list2 = [2, 3, 4];
let list3 = [3, 4, 5];
var finalList = [];

for (i of list1) {
  for (h of list2) {
    for (j of list3) {
      finalList.push(i + h + j);
    }
  }
}
return finalList;
```

## PureScript Code (idiomatic)

The non-idiomatic version of the PureScript code below is complicated because it uses a lot of recusion. Thus, I do not show it here. Rather, we'll only show the idiomatic version:

```haskell
data List a
  = Nil
  | Cons a (List a)

-- bind implementation not shown here
instance Bind List where
  bind :: forall a b. List a -> (a -> List b) -> List b
  -- when given a Nil (end of list), stop all potential future computations and return immediately.
  bind Nil _ = Nil
  -- when given a non-empty list, run the future computations on the head
  -- and then prepend it to the rest of the computations on the tail.
  bind (head : tail) f = append (f head) (bind tail f)

append :: List x -> List x -> List x
append =
  -- implementation not shown here, but the result will be
  -- append (1 : 2 : Nil) (3 : 4 : Nil) == (1 : 2 : 3 : 4 : Nil)

someComputation :: List Int
someComputation = do
  a <- (1 : 2 : 3 : Nil)
  b <- (2 : 3 : 4 : Nil)
  c <- (3 : 4 : 5 : Nil)
  pure (a + b + c)
```
which outputs:
```haskell
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
