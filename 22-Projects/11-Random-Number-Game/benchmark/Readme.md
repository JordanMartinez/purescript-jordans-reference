# Benchmark

In this folder, we will benchmark our various approaches to structuring our code. As with all benchmarks, take this with a grain of salt. This might be a naive implementation or I might not be writing the most performant code that one could write. Also, how fast something runs is only one factor to consider when writing well-designed programs.

I ran this folder's benchmarks and stored their results in the `benchmarks-results` folder.

Since we'll be benchmarking our projects here, I should also note that Nate has already written such benchmarks in his `Run` repo. See the [purescript-run repo's test folder's Benchmark.purs file](https://github.com/natefaubion/purescript-run/blob/master/test/Bench.purs)

## Generating benchmark results

1. Bundle and run the benchmark via one of the commands in the next section
2. It will output a file in the freshly-created `tmp` directory
3. Upload the outputted file to [hdgarrood's Benchotron SVG Renderer](http://harry.garrood.me/purescript-benchotron-svg-renderer/)
4. Download the graph as an SVG or PNG

<hr>

Commands to Run a Benchmark:
```bash
# Random Number Game
spago bundle-app -p "benchmark/**/*.purs" -m Performance.RandomNumber.Benchmark -t dist/benchmarks/random-number.js
node dist/benchmarks/random-number.js
```

## Interpreting These Benchmarks

I posted the random number game's benchmark's photo on the FP slack channel. Then, I got some comments from other people.
- Comparing the "Different Monad" and "Same Monad" approaches with ReaderT is really comparing a 'monomorphic stack' (`AppM`) and a polymorphic stack' (`AppT`). In other words, we're benchmarking how much overhead is incurred by passing around type class dictionaries.
- The game will NOT stack overflow when it runs because all versions are ultimately run in the `Aff` monad, which is stack-safe. However, the `Identity` monad is not. The problematic function is `gameLoop` and `runRecursivelyUntilPure`, recursive monadic functions that use `bind`/`>>=` to continually loop. As a result, we have two choices:
    - We do not guarantee stack-safety and just benchmark using small numbers. Since the number is so small, we won't "blow the stack."
    - We do guarantee stack-safety and can benchmark using very large numbers. To do so, we'll need to use [`Trampoline`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Trampoline#t:Trampoline) as the base monad (a pure monad like `Identity`, but which is stack-safe). This incurs some overhead, however, so it must be used wisely.

One other note: PureScript's compiler is not as heavily optimized as Haskell's GHC. So, while these benchmarks might show the current performance now, this does not mean these benchmarks are as fast as they _can_ be.
