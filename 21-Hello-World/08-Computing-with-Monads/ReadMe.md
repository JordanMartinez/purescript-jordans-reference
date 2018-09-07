# Computing With Monads

Monads represent sequential computation via `bind`/`>>=`: "do X, and once finished, do Y". In our previous example/explanation from `Hello World/Prelude/Control-Flow/How the Computer Executes FP Programs.md`, we implied that `Box` could be used to "compute" something. In that example, however, it merely acted as a wrapper around values and functions. In other words, the code from before (now in `do notation`)...
```purescript
main :: Box Unit
main = do
  four        <- Box 4
  five        <- Box (1 + four)
  five_string <- Box (show five)
  print five_string
```
... could be rewritten to remove `Box` entirely and focus just on the values and functions:
```purescript
-- since `print` is not a pure function, we'll leave put it at the end
-- Reminder: function arg == arg # function
(
  4 # (\four ->
    (1 + four) # (\five ->
      (five # show)
    )
  )
) # (\five_string -> print five_string)
```
So, why use Monads in the first place?.

The example did not make it clear how `Box` could be a "computation" because we aren't using functions of the type `(a -> Box b)`. Rewriting the above code to use functions would appear like so:
```purescript
main :: Box Unit
main = do
  four        <- Box 4

              -- add1 :: Int -> Box Int
              -- add1 x = Box (1 + x)
  five        <- add1 four

              -- toString :: Int -> Box String
              -- toString x = Box (show x)
  five_string <- toString five

-- similar for `print` function
  print five_string
```
If `bind`/`>>=` insures sequential computation, what kinds of functions could we have that work with `bind`/`>>=` to compute some new value? Let's now give some examples via the table below:

| When we want `bind` to... | ... we expect to use functions named something like ... | ... which are best abstracted together in a type class called...
| - | - | - |
| manipulate state | <ul><li>`getState`</li><li>`setState`</li><li>`modifyState` (get and then set)</li></ul> | [`MonadState`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState), which provides functions for manipulating state.
| sequentially log things to a Logger | <ul><li>`logToFile`</li><li>`logToConsole`</li></ul> | [`MonadTell` and `MonadWriter`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadTell), which provides functions for sequentially logging info to a Logger
| Get the value of some settings/config | <ul><li>`getSettingValue`</li><li>`getConfigValue`</li><li>`getConfigValueFromFile`</li></ul> | [`MonadAsk` and `MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadAsk), which provide read-only functions for getting such values

These type classes will be explained and used in code.
