# From `Expression` to `Free`

`Expression` from before was really just a variant of the `Free` monad.

Purescript's `Free` monad is implemented in the "reflection without remorse" style, which adds complexity to the implementation. Thus, rather than redirecting you there, we'll explain the general idea of what the code is doing.
For example, the `Free` monad has its own way of injecting an instance into it called [`liftF`](https://pursuit.purescript.org/packages/purescript-free/5.1.0/docs/Control.Monad.Free#v:liftF). It can be understood like this:
```purescript
liftF :: g (Free f a) -> Free f a
liftF = Impure $ inj
```
