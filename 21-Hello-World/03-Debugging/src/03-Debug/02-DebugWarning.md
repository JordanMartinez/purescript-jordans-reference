# DebugWarning

`Debug` uses Custom Type Errors to warn the developer when it is being used.

Let's examine it further since it provides an example for us to follow should we wish to do something similar in the future. The source code is [here](https://github.com/garyb/purescript-debug/blob/v5.0.0/src/Debug.purs), but we'll provide type signatures for the parts we need below and explain their usage:
```haskell
-- See the copyright notice at the bottom of this file for this code:

-- | Nullary type class used to raise a custom warning for the debug functions.
class DebugWarning

instance Warn (Text "Debug usage") => DebugWarning

foreign import trace :: forall a b. DebugWarning => a -> (Unit -> b) -> b

-- same idea as 'trace' for all the other functions
```

In short, rather than writing `function :: Warn (Text "Debug usage") => [function's type signature]` on every function, they use an empty type class whose sole instance adds this for every usage of that type class.

<hr>
Copyright notice for the above code:

```
The MIT License (MIT)

Copyright (c) 2015 Gary Burgess

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
