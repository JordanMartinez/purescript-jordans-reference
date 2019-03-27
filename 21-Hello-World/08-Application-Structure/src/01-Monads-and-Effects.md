# Monads and Effects

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
`bind`/`>>=` insures that one computation occurs before another (i.e. sequential computation), but it does not define what kinds of computation are done. Thus, we must explain what "effects" are.

## Effects

To understand what we mean by "effects" (and due to license-related things), read through the first two sentences of [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html), then continue reading this page.

### Examples of Effects

Effects can be grouped together into type class functions that define computations which `bind` executes in a sequential manner. These type classes are specialized; they are designed to do one thing very very well.

So what kind of "effects" can we have? Let's now give some examples via the table of `Monad Transformers` (defined next) below:

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

Note: **Monad Transformers** are thus named because they "transform" some other monad by augmenting it with additional functions. One monad (e.g. `Box`) can only use `bind` and `pure` to do sequential computation. However, we can "transform" `Box`, so that it now has state-manipulating functions like `get`/`set`/`modify`. In Haskell, "**mtl**" is a library that provides default implementations for each monad transformer mentioned above in such a way that one can compose multiple effects in any order. In Purescript, the library is called `purescript-transformers`.

## Properties of "Effects"

Now, continue reading through the rest of the first section of [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html).

We will explain and illustrate what is meant by each property

### Extensible

While the above effects (e.g. `MonadState`) are pretty obvious, we might one day wish to define a new effect for handling authentication,`MonadAuthenticate`. If a function that uses state-manipulation effects via `MonadState` now needs to add the "authenticate" effect, it should be easy to add that and not require us to refactor a whole lot of code.

In other words, going from this function ...
```purescript
f :: forall m.
     MonadState m =>
     InitialState -> m OutputtedState
```
... to this function...
```purescript
f' :: forall m.
      MonadState m =>
      MonadAuthenticate m =>
      InitialState ->
      m OutputtedState
```
... should be easy/quick.

### Composable

Composable means using two or more effects in the same function should be lawful.

For example
- `set`ting some state to `5` and later `get`ting that state should return `5`, not `8`, no matter what happens in-between those two calls (e.g. printing some value to the console).
- `catch`ing an error cannot occur unless an error was `throw`n prior to it.
- `ask`ing for a configuration value should return the same value each time no matter what happens before/after that call.

### Efficient

This can be understood a few different ways:
- During runtime: the program runs fast (time-efficient) or uses as little memory as possible (space-efficient)
- During compile-time: the compiler runs fast (time-efficient) or uses as little memory as possible (space-efficient)

I believe the author is referring to the first idea (runtime).

### Terse

We shouldn't have to write boilerplate-y code

For example, we shouldn't have to write
- many lines of code to do one thing
- many types to do one thing

### Inferable

Related to `Terse`, we shouldn't have to annotate code (e.g. wrapping `value` with its type annotation: `(value :: { name :: String, age :: Int })` )

## Modeling Effects

There are a number of ways to model effects, but these four in [stepchownfun's `effects` project](https://github.com/stepchowfun/effects) give a general idea:
- `Bespoke monad` - design and use your own hand-crafted monadic type that has an instance for every effect you need
- `MTL` - uses nested functions in a stack-like way, where lower ones are "**lifted**" into higher ones
- `Free` - uses nested data structures in a stack-like way where lower ones are "**interpreted**" into higher ones
- `Eff`- ???

In this folder, we'll only cover `MTL` and `Free`. The article to which we referred above overviews more ideas, but that is not our current focus. It might be worth returning to it after one has read through the rest of this folder.

### Composing Monads

As we explained previously, `bind`/`>>=`'s type signature forces one to only return the same `Box`-like monad type that is used in bind:
```purescript
bind :: forall a. f   a -> ( a    -> f   b)           -> f    b
bind :: forall a. Box a -> ( a    -> Box b         )  -> Box  b
bind             (Box 4)   (\four -> Box (show four)) == Box "5"
```

**In other words, if we use one monad, we cannot use any other monads.** So, how do we get around this limitation?

We saw the same problem earlier when we wanted to run an `Effect` monad inside of a `Box` monad. We fixed it by "lifting" the `Effect` monad into the `Box` monad via a [`NaturalTransformation`](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.NaturalTransformation#t:NaturalTransformation)/`~>`. This was abstracted into a type class specific for `Effect ~> someOtherMonad` in [`MonadEffect`](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#t:MonadEffect).

`MTL` and `Free` use different approaches to solving this problem and its solution is what creates the Onion Architecture-like idea we mentioned before.

**The following ideas are quick overviews of each approach. Their terminology and exact details will be explained in their upcoming folder. It is not meant to be clearly understandable at first.**

#### MTL Approach

In the `MTL`-approach, one models the above effects using functions (we'll show how later). Since each function is a different monadic type, they do not compose. Thus, one gets around this monad-composition problem by creating a "stack" of monad transformers (i.e. functions). Following the previous idea, we can define **something similar to** a `NaturalTransformation` that "lifts" one monadic function (e.g. a function that implements `MonadReader`) into another monadic function (e.g. a function that implements `MonadState`). Using a visual, it produces this diagram (read from bottom to top):
```
MonadState_TargetMonad
      ^
      | gets lifted into
      |
MonadReader_SourceMonad
```
Generalizing this idea, we must ultimately create a "stack" of these function-based monad-transformers that lift one monadic function type somewhere in the "stack" all the way up and into the monadic function type at the top of the stack. Using a visual, it produces this diagram (read from bottom to top):
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

This idea is at the heart of the type class called `MonadTrans`. Again, you should feel somewhat confused right now and a bit overwhelmed. However, we'll refer to these ideas later to help explain why we make some of the design choices that we do. By the end of this folder, this will all make sense.

#### Free

In the `Free`-approach, one models the above effects using data structures (again, we'll show how later). Since each data structure is a different monadic type, they do not compose. Thus, one gets around this monad-composition problem by creating a "stack" of data structures. Following the previous idea, we can define **something similar to** a `NaturalTransformation` that "interprets" one monadic data structure (e.g. a data type that implements `MonadReader`) into another monadic data structure (e.g. a data type that implements `MonadState`). Using a visual, it produces this diagram (read from bottom to top):
```
MonadState_TargetMonad
      ^
      | gets **interpreted as**
      |
MonadReader_SourceMonad
```
Generalizing this idea, we must ultimately create a "stack" of these data-structure-based monads that takes one monadic data type somewhere in the "stack" and interprets it as the monadic data structure type at the top of the stack. Using a visual, it produces this diagram (read from bottom to top):
```
Index0_TopMonad
      ^
      | which gets **interpreted as**
      |
Index1_NextMonad
      ^
      | which gets **interpreted as**
      |
Index2_NextMonad
      ^
      | which gets **interpreted as**
      |
Index3_NextMonad
      ^
      | which gets **interpreted as**
      |
Index4_NextMonad
      ^
      | gets **interpreted as**
      |
Index5_BottomMonad
```
