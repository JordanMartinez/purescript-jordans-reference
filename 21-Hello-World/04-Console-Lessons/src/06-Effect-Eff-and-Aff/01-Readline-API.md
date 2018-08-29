# Node ReadLine API

Node's ReadLine API docs are [here](https://nodejs.org/api/readline.html). However, in this folder, we've only used the following Purescript bindings of the API (The Pursuit docs are outdated and for an earlier release, so look at the [source code](https://github.com/purescript-node/purescript-node-readline/blob/master/src/Node/ReadLine.purs) to see all of what is supported. Some functions below had their 'foreign import' part removed to shorten the type signature):
```purescript
foreign import data Interface :: Type

-- | A function which performs tab completion.
-- |
-- | This function takes the partial command as input, and returns a collection of
-- | completions, as well as the matched portion of the input string.
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
-- | event occurs.
question :: String -> (String -> Effect Unit) -> Interface -> Effect Unit
question message handleUserInput interface = -- implementation

-- | Closes the specified `Interface` and cleans up resources.
close :: Interface -> Effect Unit
close interface = -- implementation
