# Foreign Function Interface (FFI) Syntax

## Alternate Backends

Besides compiling to Javascript, Purescript can also compile to other languages. See [this link](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md) for a full list (may be outdated)

## Syntax

This folder documents the pattern to follow to write correct FFI code. However, once [FFI-Easy](https://pursuit.purescript.org/packages/purescript-easy-ffi/2.1.2) gets updated to `0.12.0`, we could write the following code:
```purescript
import Data.Foreign.EasyFFI (unsafeForeignFunction, unsafeForeignProcedure)

basicFunction :: Number -> Number -> Number
basicFunction = unsafeForeignFunction [ "x", "y" ] "x + y"

basicEffect :: String -> Effect Unit
basicEffect = unsafeForeignProcedure [ "msg", "" ] "console.log(msg);"
```

Until then, see [Justin Woo's RTD explanation](https://purescript-resources.readthedocs.io/en/latest/ffi.html) for a good explanation on FFI and links.

You should also look at the Purescript and Javascript source code for Effect.Uncurried:
- [Purescript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.purs#L139)
- [Javascript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.js#L1)

Lastly, there may be some cases where you need to write FFI with `Effect`, but `Effect` isn't the best type to use. In such cases, take a look at [Aff's FFI](https://pursuit.purescript.org/packages/purescript-aff/5.0.2/docs/Effect.Aff.Compat):
