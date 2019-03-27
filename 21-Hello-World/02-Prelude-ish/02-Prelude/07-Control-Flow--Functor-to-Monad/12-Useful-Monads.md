# Useful Monads

**Note:** This file's contents assumes you have read through and are somewhat familiar with the contents of the file, `Syntax/Prelude Syntax/Reading Do as Nested Binds.md`.

So far, we have only shown you the `Box` monad to help you get used to the syntax and see the logic for how it works. (The `Box` type is a learner-friendly name for the `Identity` monad, which we'll cover later in the `Application Structure` folder.)

However, `Monads` are used to compose different functions. Whereas the `Box`/`Identity` monad only produces one output, the below types can produce 2 outputs. Functions that produce 2 outputs don't typically compose. However, the `Monad` type class enables us to compose them using "railway-oriented programming" (~Scott Wlaschin).

## The Maybe Monad

In JavaScript, we might write this code, which leads to the [Pyramid of Doom](https://www.wikiwand.com/en/Pyramid_of_doom_(programming)):
```javascript
let a = computation();
if (a == null) {
  return null;
} else {
  let b = compute1(a);
  if (b == null) {
    retun null;
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
  -- when given a Nothing, stop all future computations and return immediately.
  bind Nothing _ = Nothing
  -- when given a Just, run the function on its contents
  bind (Just a) f = f a

someComputation :: Maybe ReturnValue
someComputation = do
  a <- computation
  b <- compute1 1
  c <- compute2 b
  compute3 c
```

If a `Nothing` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.

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

In PureScript, we write this code:

```purescript
data Either a b
  = Left a
  | Right b

instance bindEither :: Bind (Either a) where
  bind :: forall b c. Either a b -> (b -> Either a c) -> Either a c
  -- when given a Left, stop all future computations and return immediately.
  bind l@(Left _) _ = l
  -- when given a Right, run the function on its contents
  bind (Right a) f = f a

someComputation :: Either ErrorType ReturnValue
someComputation = do
  a <- computation
  b <- compute1 1
  c <- compute2 b
  compute3 c
```

If a `Left` value is given at any point in the nested-`bind` computations, it will short-circuit and return immediately.
