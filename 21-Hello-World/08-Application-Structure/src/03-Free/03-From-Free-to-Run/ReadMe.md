# From `Free` to `Run`

So far, we've used the `Free` monad to model effects using `Coproduct`. However, this approach is not very extensible because `Coproduct` is the "closed" `Type -> Type` sum type.

This folder will
- explain what problem arises by using `Either`/`Coproduct`, the "closed" sum types
- show how to make these effects more extensible by using `Variant`/`VariantF`, the "open" sum types
- show how to combine `VariantF` and `Free` into a more-readable type via `Run`.
