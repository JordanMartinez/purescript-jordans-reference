# From `Expression` to `Free`

`Expression` from before was really just a variant of the `Free` monad.
```purescript
newtype Expression f
  -- no pure here...
  = In     (f (Expression f  ))

newtype Free       f a
  = Pure a
  | Impure (f (Free       f a))
```

So, how does this change the `VariantF` code from before? `Value` is replaced with `Pure`. To see an example of just `Value` and `Add`, see [ADT8.purs](https://github.com/xgrommx/purescript-from-adt-to-eadt/blob/master/src/ADT8.purs) and use this table to help you understand the terminology:

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
-- before, we wrote...
addF :: Expression f -> Expression f -> Expression f
addF x y = In $ inj (AddF x y)

-- but now we can rewrite it as...

liftF :: g (Free f a) -> Free f a
liftF = Impure $ inj

addF x y = liftF $ AddF x y
```

### RunFree

Rather than writing `fold` and then writing `run` as a way to use `fold` to evaluate a computation as we did in `Value.purs`, we can simplify this to one function by using [`runFree`](https://pursuit.purescript.org/packages/purescript-free/4.2.0/docs/Control.Monad.Free#v:runFree)
