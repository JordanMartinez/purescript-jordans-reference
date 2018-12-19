# From `Free` to `Run`

So far, we've used the `Free` monad to model effects using `Coproduct`. However, this approach is not very extensible because `Coproduct` is the "closed" `Type -> Type` sum type.

This folder will show how to make these effects more extensible by using `VariantF`, the "open" `Type -> Type` sum type. In addition, it will show how to combine `VariantF` and `Free` into an easier type via `Run`.
