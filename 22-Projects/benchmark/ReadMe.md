# Random Number - Benchmarks

In this folder, we will benchmark our various approaches to structuring our code. As with all benchmarks, take this with a grain of salt. How fast something runs is only one factor to consider when writing well-designed programs.

I ran this folder's benchmarks and stored their results in the `benchmarks-results` folder.

Since we'll be benchmarking our projects here, I should also note that Nate has already written such benchmarks in his `Run` repo. See the [purescript-run repo's test folder's Benchmark.purs file](https://github.com/natefaubion/purescript-run/blob/master/test/Bench.purs)

## Compilation Instructions

1. Install [`Benchmark.js`](https://benchmarkjs.com/) locally via the command below:
```bash
# Note: This must be installed locally for the code to work.
# If you install it globally, Node won't be able to find `benchmark`.
npm install benchmark
```
2. Now run `spago build` to install and compile the project:
```bash
spago build
```

## Generating benchmark results

1. Run the benchmark
```bash
spago run -m Performance.Games.RandomNumber.Benchmark -p "benchmark/**/*.purs"
```
2. It will output a file in the freshly-created `tmp` directory
3. Upload the outputted file to [hdgarrood's Benchotron SVG Renderer](http://harry.garrood.me/purescript-benchotron-svg-renderer/)
4. Download the graph as an SVG or PNG
