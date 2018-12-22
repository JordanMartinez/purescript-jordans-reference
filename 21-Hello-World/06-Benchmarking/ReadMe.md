# Benchmarking

Purescript has a few benchmarking libraries:

| Name | Status | Comments |
| - | - | - |
| [purescript-benchotron](https://pursuit.purescript.org/packages/purescript-benchotron/7.0.0) | Up-to-date | Uses QuickCheck<br>Output results only in Node<br>Results are viewable only via graphs |
| [purescript-minibench](https://pursuit.purescript.org/packages/purescript-minibench/2.0.0/docs/Performance.Minibench) | Up-to-date | Provides quick estimates but not very accurate benchmarks
| [purescript-benchmark](https://pursuit.purescript.org/packages/purescript-benchmark/0.1.0) | Outdated (PS `0.11.7`) | Doesn't require QuickCheck<br>Outputs results in Node and Browser<br>Output is full ASCII table with percentage values

In this folder, we'll be covering `benchotron` because it works for `0.12.x` and has finer accuracy than `minibench` and includes graphs.

This benchotron graph...

![benchmark results](./benchmark-results/file-name-for-output.svg)

... was the result of [this somewhat unreadable output](./benchmark-results/file-name-for-output.json)

## Compilation Instructions

`Benchotron` is a Purescript library that provides bindings to [`Benchmark.js`](https://benchmarkjs.com/). Follow these commands to set up this folder:

1. If it exists, delete this folder's `.psc-package` folder (Step 4 won't work if you have already set up a package set in this folder)

2. Install [`Benchmark.js`](https://benchmarkjs.com/) locally via the command below:
```bash
# Note: This must be installed locally for the code to work.
# If you install it globally, Node won't be able to find `benchmark`.
npm install benchmark
```

3. Use `spacchetti` to create your own local custom package set that includes `Benchotron` by following these instructions (that library does not yet exist in the default package set):
```bash
# I've already ran `spacchetti local-setup`
# and configured the 'packages.dhall' file.
# See this folder as an example of what you would need to do
# if you had to do it on your own.

# So, we just need to install the local custom package set
spacchetti insdhall
```

4. Install that package set using psc-package:
```bash
psc-package install
```

You can now use `benchotron` via psc-package.

## Generating benchmark results

1. Run the below command
```bash
pulp --psc-package run --src-path "benchmark" -m Benchmarking.Syntax.Benchotron
```
2. It will output a file in the freshly-created `tmp` directory
3. Upload the outputted file to [this link](http://harry.garrood.me/purescript-benchotron-svg-renderer/)
4. Download the graph as an SVG or PNG

## Generating benchmarks for real-world projects

In real-world projects, one would run this command:
```bash
pulp --psc-package run -m Performance.ModulePath.To.MainModule --src-path "benchmark" --include "src:test"
```
