# Traversable

## Usage

While `Foldable` allowed us to use things like `for_`, `traverse_`, and `sequence_`, these three functions restricted computations to only outputting `Unit`. `Traversable` removes that restriction. Moreover, it enables a few other nice things.

Plain English names:
- ForEach (traverse)
- "Step-by-Step 'Debugger'" (scanl/scanr)
- BoxSwap (sequence)

[The FP version of "for value in collection, run some impure computation"](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Traversable#v:for)

Oh... one other thing...
https://twitter.com/blouerat/status/867278331779198976

## Definition

See its docs: [Traversable](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Traversable)

## Laws

TODO

## Derived Functions

TODO
