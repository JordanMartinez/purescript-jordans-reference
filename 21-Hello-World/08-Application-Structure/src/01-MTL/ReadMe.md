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
`bind`/`>>=` insures that one computation occurs before another (i.e. sequential computation), but it does not define what kinds of computation are done. Thus, we must explain what "effects" are. **Effects** are the types of computations we want to use. These effects can be grouped together into functions that define computations which `bind` executes in a sequential manner. So what kind of "effects" can we have? Let's now give some examples via the table below:

| When we want a type of computation (effect) that... | ... we expect to use functions named something like ... | ... which are best abstracted together in a type class called...
| - | - | - |
| Provides for later usage a read-only value/function that may change between different program runs<br>(e.g. "settings" values; dependency injection) | <ul><li>`getSettingValue`</li><li>`getConfigValueStoredOnFile`</li><li>`getNumberOfPlayersInGame`</li></ul> | [`MonadAsk`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadAsk)
| Modifies the state of a data structure<br>(e.g. changing the nth value in a list)| <ul><li>`pop stack`</li><li>`replaceAt index treeOfStrings "some value"`</li><li>`(\int -> int + 1)`</li></ul> | [`MonadState`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)
| Returns a computation's output and additional data that is generated during the computation | <ul><li>[See this SO answer](https://stackoverflow.com/a/27651976)</li><li>[See this Reddit thread](https://www.reddit.com/r/haskell/comments/3faa02/what_are_some_real_world_uses_of_writer/)</li></ul> | [`MonadTell`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadTell)
| Stops computation because of an unforeseeable error<br>(e.g. "business logic error") | -- | [`MonadThrow`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadThrow)
| Deals with "callback hell"<br>(e.g. [de-invert inversion of control](http://www.thev.net/PaulLiu/invert-inversion.html)) | -- | [`MonadCont`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Cont.Class#t:MonadCont)

| When we want to extend the functionality of... | ... with the ability to... | ... we can use its extension type class called...
| - | - | - |
| MonadAsk | Modify the read-only value for one computation<br>(e.g. `makeFontSizeMoreAccessible getFontSize displayPage`) | [`MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadReader)
| MonadTell | Modify or use the additional non-output data before completing a computation | [`MonadWriter`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadWriter)
| MonadThrow | Catch and handle the error that was thrown<br>(e.g. log debug output to see why business logic was wrong) | [`MonadError`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadError)

## Setting Your Expectations

These type classes all do one thing very very well. However, that's all they do. **The upcoming code examples for each type class may seem pointless at first because the program doesn't do anything "useful." That's intentional for teaching purposes.** Each needs to be studied separately to increase familiarity. Once we understand how they work individually, we can start to combine them together using "monad transformers."

## Explaining the Name: Monad Transformers

As we explained previously, `bind`/`>>=`'s type signature forces one to only return the same `Box`-like monad type that is used in bind:
```purescript
bind :: forall a. f   a -> ( a    -> f   b)           -> f    b
bind :: forall a. Box a -> ( a    -> Box b         )  -> Box  b
bind             (Box 4)   (\four -> Box (show four)) == Box "5"
```
**In other words, if we use one of the above monads (e.g. `MonadState`) as our monad, we cannot use any other computational monads from above.** For some parts of our program, this is not a problem. If we only want to run a state computation, we only need to use the `MonadState` effect. However, in other parts of our program, we need to use functions from both `MonadState` and `MonadReader`. Thus, we need to "compose" one effect with another. In other words, we need "composable effects."

So, how do we get around this limitation?

We saw the same problem earlier when we wanted to run an `Effect` monad inside of a `Box` monad. We fixed it by "lifting" the `Effect` monad into the `Box` monad via a [`NaturalTransformation`](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.NaturalTransformation#t:NaturalTransformation)/`~>`. This was abstracted into a type class specific for `Effect ~> someOtherMonad` in [`MonadEffect`](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#t:MonadEffect).

Following that idea, we can define **something similar to** a `NaturalTransformation` that "lifts" one computational monad (e.g. `MonadReader`) into another computational monad (e.g. `MonadState`). Using a visual, it produces this diagram (read from bottom to top):
```
MonadState_TargetMonad
      ^
      | gets lifted into
      |
MonadReader_SourceMonad
```
Thus, a **monad transformer** can "transform" one monad that does not have certain effects (e.g. state manipulation) into a version that does. In short, a monad transformer augments a base monad with additional powers.

If we want to use all of the monads above, we must ultimately create a "stack" of these monad transformations that lift one monad type somewhere in the "stack" all the way up and into the monad type at the top of the stack. Using a visual, it produces this diagram (read from bottom to top):
```
Index0_TopMonad
      ^
      | gets lifted into
      |
Index1_NextMonad
      ^
      | gets lifted into
      |
Index2_NextMonad
      ^
      | gets lifted into
      |
Index3_NextMonad
      ^
      | gets lifted into
      |
Index4_NextMonad
      ^
      | gets lifted into
      |
Index5_BottomMonad
```
This idea will be covered more when we explain what `MonadTrans` is and how it works

In short, "**monad transformers**" augment a base monad with additional capabilties. In Haskell, "**mtl**" is a library that provides default implementations for each monad transformer in such a way that one can compose multiple effects in any order.
In Purescript, these two ideas are combined together in the library called `purescript-transformers`.
