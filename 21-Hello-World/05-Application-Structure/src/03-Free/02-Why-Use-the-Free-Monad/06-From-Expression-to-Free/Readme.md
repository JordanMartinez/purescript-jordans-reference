# From `Expression` to `Free`

We've been defining the function, `fold`, the same way for a while. However, there's another way to write the function. To help you understand the upcoming code, we'll rewrite it in this new way:
```haskell
fold :: forall f a. Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)                                          {-
... which can be rewritten using infix notation                             -}
fold f (In t) = f ((fold f) <$> t)                                          {-
... which can be rewritten to not pass `f` through recursive calls          -}
fold f = go where
  go (In t) = f (go <$> t)                                                  {-
... which can be rewritten to use "case _ of" to pattern match              -}
fold f = go where
  go in_t = case in_t of
    In t -> f (go <$> t)
```

With that out of the way, let's compare `Expression` to `Free`. We can see that `Expression` is really just a variant of the `Free` monad without the `Pure` constructor.
```haskell
newtype Expression f
  -- no pure here...
  = In     (f (Expression f  ))

newtype Free       f a
  = Pure a
  | Impure (f (Free       f a))
```

How would we rewrite our solution from before to use `Free` instead of `Expression`? `Value` is replaced with `Pure`.

To see an example of this for just `Value` and `Add` (`Multiply` is excluded) and to understand its code, refer to the below code and table before viewing [ADT8.purs](https://github.com/xgrommx/purescript-from-adt-to-eadt/blob/master/src/ADT8.purs).

```haskell
-- when Value and Add were both `f`
fold    f = go where
  go in_t = case in_t of
    In     t -> f (go <$> t)

-- when Value is simply Pure now
fold    f = go where
  go free = case free of
    Pure   a -> a              -- Value
    Impure t -> f (go <$> t)   -- Add
```

| xgrommx's code | Our code |
| - | - |
| `Free ExprF a`<br>or<br>`Expr` | `Expression (Coproduct Value ExprF) a`
| `lit` | `value`
| `iter` | `fold`
| `iter k go` | `fold algebra expression`
| `Left f`<br>`Right a` | `AddF`<br>`ValueF`

## A Quick Overview of Some of Purescript's `Free` API

Purescript's `Free` monad is implemented in the "reflection without remorse" style, which adds complexity to the implementation. Thus, rather than redirecting you there, we'll explain the general idea of what the code is doing.

### LiftF

The `Free` monad has its own way of injecting a value into it called [`liftF`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Free#v:liftF). It can be understood like this:
```haskell
-- Before
someValue :: forall a. a -> Expression SomeFunctor
someValue a =
  In (SomeFunctor a) -- or `inj (SomFunctor a)`

-- After...
liftF :: a -> Free SomeFunctor a
liftF = Impure (SomeFunctor a)
```

### Wrap

`LiftF` is useful, but it won't let us compile the examples we will show next because it expects the `a` to be any `a`. In cases like `AddF`/`MultiplyF`, sometimes that `a` has to be `Free AddF`/`Free MultiplyF` instead of just the `Int` type. In such cases, we can use [`wrap`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Free#v:wrap):

```haskell
-- Using `liftF`
add :: Int -> Int -> Free AddF Int
add x y = liftF $ AddF x y

-- the above 'add' definition does not allow us to create
-- nested adds

-- Using `wrap`
add :: Free AddF Int -> Free AddF Int -> Free AddF Int
add x y = wrap $ AddF x y
```

### Other Functions

[`foldFree`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Free#v:foldFree) interprets the Free into some other monad (e.g. `Effect`, etc.).

[`runFree`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Free#v:runFree) computes a "pure" program described in `Free` (by 'pure,' we meant that `Free` only stores the instructions the program would execute, but does not run them).

## Compilation Instructions

You can run the upcoming code examples using these instructions:
```bash
spago run -m Free.AddAndMultiply
```
