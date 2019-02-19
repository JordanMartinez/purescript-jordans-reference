# From `Free` to `Run`

So far, we've used the `Free` monad to model effects using `Coproduct`. However, this approach is not very extensible because `Coproduct` is the "closed" `Type -> Type` sum type.

This folder will
- explain what problem arises by using `Either`/`Coproduct`, the "closed" sum types
- show how to make these effects more extensible by using `Variant`/`VariantF`, the "open" sum types
- show how to combine `VariantF` and `Free` into a more-readable type via `Run`.

As stated in [Free Programs, More Better Programs](reasonablypolymorphic.com/blog/freer-monads/index.html), PureScript's `Run` is the same idea behind Haskell's `Eff` monad. Moreover, The pre-`0.12.0` PureScript release's `Eff` monad that was later changed to `Effect` is not the same as Haskell's `Eff` monad, which is covered in that article.
