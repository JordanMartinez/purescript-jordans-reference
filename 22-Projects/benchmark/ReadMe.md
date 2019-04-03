# Random Number - Benchmarks

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
spago bundle -p "benchmark/**/*.purs" -m Performance.RandomNumber.Benchmark -t dist/benchmarks/random-number.js
node dist/benchmarks/random-number.js
```
