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

### Default implementations for the members of the `Traversable` type class

`traverse` can be implemented using `sequence` and `sequence` can be implemented using `traverse`. Similar to `Foldable`, once one has implemented one of these when writing a `Traversable` instance for a data type, they can use a default implementation to implement the other:
- if `traverse` is implemented, you can implement `sequence` by using [`sequenceDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Traversable#v:sequenceDefault)
- if `sequence` is implemented, you can implement `traverse` by using [`traverseDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Traversable#v:traverseDefault)
