# Random Number

## Interpreting These Benchmarks

I posted the random number game's benchmark's photo on the FP slack channel. Then, I got some comments from other people.
- Comparing the "Different Monad" and "Same Monad" approaches with ReaderT is really comparing a 'monomorphic stack' (`AppM`) and a polymorphic stack' (`AppT`). In other words, we're benchmarking how much overhead is incurred by passing around type class dictionaries.
- The game will NOT stack overflow when it runs because all versions are ultimately run in the `Aff` monad, which is stack-safe. However, the `Identity` monad is not. The problematic function is `gameLoop` and `runRecursivelyUntilPure`, recursive monadic functions that use `bind`/`>>=` to continually loop. As a result, we have two choices:
    - We do not guarantee stack-safety and just benchmark using small numbers. Since the number is so small, we won't "blow the stack."
    - We do guarantee stack-safety and can benchmark using very large numbers. To do so, we'll need to use [`Trampoline`](https://pursuit.purescript.org/packages/purescript-free/5.1.0/docs/Control.Monad.Trampoline#t:Trampoline) as the base monad (a pure monad like `Identity`, but which is stack-safe). This incurs some overhead, however, so it must be used wisely.

One other note: PureScript's compiler is not as heavily optimized as Haskell's GHC. So, while these benchmarks might show the current performance now, this does not mean these benchmarks are as fast as they _can_ be.
