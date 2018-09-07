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
| Produce for later usage a read-only value that may change between different program runs<br>(e.g. "settings" values; dependency injection) | <ul><li>`getSettingValue`</li><li>`getConfigValueFromFile`</li><li>`getNumberOfPlayersInGame`</li></ul> | [`MonadAsk`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadAsk)
| Modify the state of a data structure<br>(e.g. changing the nth value in a list)| <ul><li>`pop stack`</li><li>`replaceAt index tree`</li><li>`(_ + 1)`</li></ul> | [`MonadState`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)
| Use a Semigroup to combine a function's additional non-output data | [see this SO answer](https://stackoverflow.com/a/27651976) | [`MonadTell`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadTell)
| Stop computation because of an unforeseeable error<br>(e.g. "business logic error") | -- | [`MonadThrow`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadThrow)
| Stop "callback hell"<br>(e.g. [de-invert inversion of control](http://www.thev.net/PaulLiu/invert-inversion.html)) |-- | [`MonadCont`](invert inversion of control)

| When we want to extend the functionality of... | with the ability to... | ... we can use its extension type class called...
| - | - | - |
| MonadAsk | Modify the read-only value for one computation<br>(e.g. `increaseFontSizeFor getFontSize displayPage`) | [`MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadReader)
| MonadTell | TODO | [`MonadWriter`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadWriter)
| MonadThrow | Catch and handle the error that was thrown<br>(e.g. log debug output to see why business logic was wrong) | [`MonadError`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadError)

These type classes will be explained and used in code.
