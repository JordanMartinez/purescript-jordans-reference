# From `Expression` to `Free`

We've been defining the function, `fold`, the same way for a while. However, there's another way to write the function. To help you understand the upcoming code, we'll rewrite it in this new way:
```purescript
fold :: forall f a. Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)                                          {-
... which can be rewritten using infix notation                             -}
fold f (In t) = f ((fold f) <$> t)                                          {-
... which can be rewritten to not pass `f` through recursive calls          -}
fold f = go where
  go (In t) = f (go <$> t)                                                  {-
... which can be rewritten to use "case _ of" to pattern match              -}
fold f = go where
  go t = case t of
    In t -> f (go <$> t)
```

With that out of the way, let's compare `Expression` to `Free`. We can see that `Expression` is really just a variant of the `Free` monad without the `Pure` constructor.
```purescript
newtype Expression f
  -- no pure here...
  = In     (f (Expression f  ))

newtype Free       f a
  = Pure a
  | Impure (f (Free       f a))
```

How would we rewrite our solution from before to use `Free` instead of `Expression`? `Value` is replaced with `Pure`. To see an example of this for just `Value` and `Add` (`Multiply` is excluded), see [ADT8.purs](https://github.com/xgrommx/purescript-from-adt-to-eadt/blob/master/src/ADT8.purs) and use the following code snippet to understand why `iter` works that way and the following table to help you understand the terminology:

```purescript
-- when Value and Add were both `f`
fold    f = go where
  go t = case t of
    In     t -> f (go <$> t)

-- when Value is simply Pure now
fold    f = go where
  go t = case t of
    Pure   a -> a              -- Value
    Impure t -> f (go <$> t)   -- Add
```

| xgromxx's code | Our code |
| - | - |
| `Free ExprF a`<br>`Expr` | `Expression (Coproduct Value ExprF) a`
| `lit` | `value`
| `iter` | `fold`
| `iter k go` | `fold algebra expression`
| `Left f`<br>`Right a` | `AddF`<br>`ValueF`

## A Quick Overview of Some of Purescript's `Free` API

Purescript's `Free` monad is implemented in the "reflection without remorse" style, which adds complexity to the implementation. Thus, rather than redirecting you there, we'll explain the general idea of what the code is doing.

### LiftF

The `Free` monad has its own way of injecting an instance into it called [`liftF`](https://pursuit.purescript.org/packages/purescript-free/5.1.0/docs/Control.Monad.Free#v:liftF). It can be understood like this:
```purescript
-- Before
addF :: Expression f -> Expression f -> Expression f
addF x y = In $ inj (AddF x y)

-- After...
liftF :: g (Free f a) -> Free f a
liftF = Impure

-- assuming that `f` is `VariantF` in this case
addF :: Free f -> Free f -> Free f
addF x y = liftF $ inj addSymbol (AddF x y)               {-
addF x y = liftF $ AddF x y -- the basic idea -}
```

### RunFree

Rather than writing `fold` and then writing `run` as a way to use `fold` to evaluate a computation as we did in `Value.purs`, we can simplify this to one function by using [`runFree`](https://pursuit.purescript.org/packages/purescript-free/4.2.0/docs/Control.Monad.Free#v:runFree):
```purescript
-- Before
fold :: forall f a. Functor f => (f a -> a) -> Expression f -> a
fold f = go where
  go t = case t of
    In t -> f (go <$> t)

run :: forall f a b output
      . Functor f
      -- |     case_        | # |    algebra       |
     => ((VariantF () a -> b) -> f output -> output)
     -> Expression f
     -> output
run algebra expression = fold (case_ # algebra) expression

eval :: forall f a b
      . Functor f
     => ((VariantF () a -> b) -> f Int -> Int)
     -> Expression f
     -> Int
eval = run

eval valueAlgebra (value 5)

-- After
eval :: forall f a b
      . Functor f
     => ((VariantF () a -> b) -> f Int -> Int)
     -> Expression f
     -> Int
eval = runFree (case_ # valueAlgebra)

runFree :: forall f a
         . Functor f
        => (f (Free f a) -> Free f a)
        -> Free f a
        -> a                                                                  {-
... which should appear like this...
runFree k = go where
  go m = case resume m of
    Impure f -> k (go <$> f)
    Pure   a -> a

... but, due to "reflection without remorse" complexities, is written like... -}
runFree k = go where
  go m = case resume m of
    Left   f -> k (go <$> f)
    Right  a -> a
```
