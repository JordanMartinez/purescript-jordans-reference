# Node ReadLine API

Node's ReadLine API docs are [here](https://nodejs.org/api/readline.html). In this folder, we'll use the following Purescript bindings of the API (The Pursuit docs are outdated as they only show docs for an earlier release. So, either run `spago docs` and look at the `Node.ReadLine` module's docs, or look at the [source code](https://github.com/purescript-node/purescript-node-readline/blob/master/src/Node/ReadLine.purs) to see all of what is supported.

Below, I cover some of the API (some of the functions below had their 'foreign import' part removed to shorten the type signature):
```haskell
-- Copyright is at the end of this file
foreign import data Interface :: Type

-- | A function which performs tab completion.
type Completer
  = String
  -> Effect
      { completions :: Array String
      , matched :: String
      }

-- | A completion function which offers no completions.
noCompletion :: Completer
noCompletion s = -- implementation

-- | Create an interface with the specified completion function.
createConsoleInterface :: Completer -> Effect Interface
createConsoleInterface compl = -- implementation

-- | Writes a message to the output and adds a listener to the
-- | interface that invokes the callback function when an
-- | event occurs (i.e. user inputs some text and presses Enter).
question :: String -> (String -> Effect Unit) -> Interface -> Effect Unit
question message handleUserInput interface = -- implementation

-- | Closes the specified `Interface` and cleans up resources.
close :: Interface -> Effect Unit
close interface = -- implementation
```
<hr>

Copyright for above code:

```
The MIT License (MIT)

Copyright (c) 2014 PureScript

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
