# Foreign Function Interface (FFI) Syntax

## Alternate Backends

Besides compiling to Javascript, Purescript can also compile to other languages. See [this link](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md) for a full list (may be outdated)

## Syntax

This folder provides examples of FFI for simple cases regarding the JavaScript backend. However, see [Wrapping JavaScript for PureScript](https://blog.ndk.io/purescript-ffi.html) for more detailed examples as to how to do FFI properly.

You should also look at the Purescript and Javascript source code for Effect.Uncurried:
- [Purescript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.purs#L139)
- [Javascript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.js#L1)

Lastly, there may be some cases where you need to write FFI with `Effect`, but `Effect` isn't the best type to use. In such cases, take a look at [Aff's FFI](https://pursuit.purescript.org/packages/purescript-aff/5.0.2/docs/Effect.Aff.Compat):
