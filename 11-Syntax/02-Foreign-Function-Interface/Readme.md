# Foreign Function Interface (FFI) Syntax

## Alternate Backends

Besides compiling to Javascript, Purescript can also compile to other languages. See [this link](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md) for a full list (may be outdated)

## Syntax

This folder provides examples of FFI for simple cases regarding the JavaScript backend. However, see [Wrapping JavaScript for PureScript](https://blog.ndk.io/purescript-ffi.html) for more detailed examples as to how to do FFI properly.

You should also look at the Purescript and Javascript source code for Effect.Uncurried:
- [Purescript](https://github.com/purescript/purescript-effect/blob/v4.0.0/src/Effect/Uncurried.purs)
- [Javascript](https://github.com/purescript/purescript-effect/blob/v4.0.0/src/Effect/Uncurried.js)

Lastly, there may be some cases where you need to write FFI with `Effect`, but `Effect` isn't the best type to use. In such cases, take a look at [Aff's FFI](https://pursuit.purescript.org/packages/purescript-aff/7.0.0/docs/Effect.Aff.Compat):

## Using PureScript code within a JavaScript context

Imagine you defined a function in PureScript like `gcd2` below that you wish to use in JavaScript code. What's a good practice to follow when calling that PureScript code from JavaScript?

```
$ cat src/GCD.purs
module GCD where

import Prelude

gcd2 :: Int -> Int -> Int
gcd2 n m | n == 0 = m
gcd2 n m | m == 0 = n
gcd2 n m | n > m = gcd (n - m) m
gcd2 n m = gcd (m - n) n
```

A good practice is to define a separate `Interop` module that looks like this:
```purs
module GCD.Interop where

import Prelude
import GCD as GCD
import Data.Function.Uncurried (mkFn2)

gcd2 :: Fn2 Int Int Int
gcd2 = mkFn2 GCD.gcd2
```
The above code will get compiled to `./output/GCD.Interop/index.js`. So, in a JavaScript file, I would do the following:
```javascript
import { gcd2 } from "./output/GCD.Interop/index.js";

gcd2(4, 5);
```

Defining an `Interop` module comes with two benefits that occur if `gcd2` needs to do some breaking change (e.g. changing its number/order/type of args and return value):
- If we have an `Interop` module, JavaScript consumers of the module don't have to account for breakage. Rather, the `Interop` version can change how this breakage propagates to the JavaScript consumer. In many cases, such breakage can be hidden entirely.
- If we have an `Interop` module, the `Interop` module will produce a compiler error. This will remind us of every place where the `Interop` code is used by JavaScript and force us to verify that the JavaScript usage of the PureScript code is still correct.
