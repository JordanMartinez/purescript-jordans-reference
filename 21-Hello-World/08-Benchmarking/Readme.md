# Benchmarking

Purescript has a few benchmarking libraries:

| Name | Status | Comments |
| - | - | - |
| [purescript-benchotron (my fork)](https://github.com/JordanMartinez/purescript-benchotron) | Up-to-date | Uses QuickCheck<br>Output results only in Node<br>Results are viewable only via graphs |
| [purescript-benchotron (original)](https://pursuit.purescript.org/packages/purescript-benchotron/) | Up-to-date | Uses QuickCheck<br>Output results only in Node<br>Results are viewable only via graphs |
| [purescript-minibench](https://pursuit.purescript.org/packages/purescript-minibench/2.0.0/docs/Performance.Minibench) | Up-to-date | Provides quick estimates but not very accurate benchmarks
| [purescript-benchmark](https://pursuit.purescript.org/packages/purescript-benchmark/0.1.0) | Outdated (PS `0.11.7`) | Doesn't require QuickCheck<br>Outputs results in Node and Browser<br>Output is full ASCII table with percentage values

In this folder, we'll be covering `benchotron` because it works for `0.15.x` and has finer accuracy than `minibench` and includes graphs.

This benchotron graph...

![benchmark results](./benchmark-results/file-name-for-output.svg)

... was the result of [this somewhat unreadable output](./benchmark-results/file-name-for-output.json)

## Compilation Instructions

`Benchotron` is a Purescript library that provides bindings to [`Benchmark.js`](https://benchmarkjs.com/). Follow these commands to set up this folder:

1. Install [`Benchmark.js`](https://benchmarkjs.com/) locally via the command below:
```bash
# Note: This must be installed locally for the code to work.
# If you install it globally, Node won't be able to find `benchmark`.
npm install benchmark
```

2. Use `spago` to build the program::
```bash
# 'spago build' includes a call to 'spago install'
spago build
```

You can now use `benchotron` via spago.

## Generating benchmark results

1. Run the below command
```bash
# Since we have `"benchmark/**/*.purs"` included in
# the `spago.dhall` file's "sources" config, we can use
# the below command instead. If you don't that that,
# you'll need to add '-p "benchmark/**/*.purs"' as an argument below.
spago run -m Benchmarking.Syntax.Benchotron
```
2. It will output a file in the freshly-created `tmp` directory
3. Upload the outputted file to the [Benchotron SVG Renderer](https://jordanmartinez.github.io/purescript-benchotron-svg-renderer/)
4. Download the graph as an SVG or PNG
