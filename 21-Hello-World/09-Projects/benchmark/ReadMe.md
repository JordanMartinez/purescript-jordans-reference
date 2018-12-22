# Random Number - Benchmarks

In this folder, we will benchmark our various approaches to structuring our code. As with all benchmarks, take this with a grain of salt. How fast something runs is only one factor to consider when writing well-designed programs.

I ran this folder's benchmarks and stored their results in the `benchmarks-results` folder.

## Compilation Instructions

Note: I assume you have already locally installed `Benchmark.js` and used spacchetti to create your own package set that includes `Benchotron`.

Install [`Benchmark.js`](https://benchmarkjs.com/) locally via the command below:
```bash
# Note: This must be installed locally for the code to work.
# If you install it globally, Node won't be able to find `benchmark`.
npm install benchmark
```

Since `benchotron` is not in the default package set (yet), you'll need to use `spacchetti` to create your own local custom package set by following these instructions:
```bash
# I've already ran `spacchetti local-setup`
# and configured the 'packages.dhall' file.
# See this folder as an example of what you would need to do
# if you had to do it on your own.

# So, we just need to install the local custom package set
spacchetti insdhall
psc-package install
```

## Generating benchmark results

1. Run one of the below commands
```bash
pulp --psc-package run -m Performance.Games.RandomNumber.Benchmark --src-path "benchmark" --include "src:test"
```
2. It will output a file in the freshly-created `tmp` directory
3. Upload the outputted file to [hdgarrood's Benchotron SVG Renderer](http://harry.garrood.me/purescript-benchotron-svg-renderer/)
4. Download the graph as an SVG or PNG
