# Foreign Function Interface (FFI) Syntax

## Alternate Backends

Besides compiling to Javascript, Purescript can also compile to other languages. See [this link](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md) for a full list (may be outdated)

## Syntax

This folder provides examples of FFI for simple cases regarding the JavaScript backend. However, see [Wrapping JavaScript for PureScript](https://blog.ndk.io/purescript-ffi.html) for more detailed examples as to how to do FFI properly.

You should also look at the Purescript and Javascript source code for Effect.Uncurried:
- [Purescript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.purs#L139)
- [Javascript](https://github.com/purescript/purescript-effect/blob/v2.0.0/src/Effect/Uncurried.js#L1)

Lastly, there may be some cases where you need to write FFI with `Effect`, but `Effect` isn't the best type to use. In such cases, take a look at [Aff's FFI](https://pursuit.purescript.org/packages/purescript-aff/5.0.2/docs/Effect.Aff.Compat):

## Using PureScript code within a JavaScript context

> If I want to create some standalone PureScript functions that integrate with a broader JavaScript codebase, is there a way to take the output from browserify and accomplish that?

```
$ cat src/GCD.purs
module GCD where

import Prelude

gcd2 :: Int -> Int -> Int
gcd2 n m | n == 0 = m
gcd2 n m | m == 0 = n
gcd2 n m | n > m = gcd (n - m) m
gcd2 n m = gcd (m - n) n

$ cat build.sh
pulp browserify --main GCD --skip-entry-point --standalone index --to js/index.js```
```
> As-in, is there some magic required to import `index.js` and expose `gcd2`?

> At Awake, we would write something like a `GCD.Interop`, which has bindings from JS reps to the PS reps, and then we would just import the output directly

> Can you give an example of what that would look like specifically?

> Sure.
```purescript
module GCD.Interop where
import Prelude
import GCD as GCD
import Data.Function.Uncurried (mkFn2)

gcd2 :: Fn2 Int Int Int
gcd2 = mkFn2 GCD.gcd2```
```
> That gets compiled to `./output/GCD.Interop/index.js` and then in a js file I can do
```javascript
import { gcd2 } from "./output/GCD.Interop/index.js";
gcd2(4, 5);
```

> Okay cool. That is helpful. Thank you!

> You can import the original file directly as well but the reason we write an Interop file is so we can change PS files without breaking JS consumers, or at least, if we change types, we know that JS consumers need to be verified

> If I load the original file via a script tag, I can't figure out how to call `gcd2`, as it feels like it's hidden behind a closure, am I wrong? I don't totally understand the magic browserify is doing...

> If you use browserify with standalone, then you can configure what the global variable is. So `pulp browserify --main GCD --skip-entry-point --standalone GCD --to index.js`. If you load that index file with a script tag, then you’ll have `GCD.gcd2` available in the global namesapce

> That's what I was looking for.
