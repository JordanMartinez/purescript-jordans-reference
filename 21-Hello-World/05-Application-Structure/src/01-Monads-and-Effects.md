# Monads, Effects, and Capabilities

Monads represent sequential computation via `bind`/`>>=`: "do X, and once finished, do Y". In our previous example/explanation from `Hello World/Prelude/Control-Flow/How the Computer Executes FP Programs.md`, we implied that `Box` could be used to "compute" something. In that example, however, it merely acted as a wrapper around values and functions. When we covered `Effect` and `Aff` in their respective folder, we saw that conceptually they operated very similar to `Box`.

Still, our `Box`/`Effect`/`Aff` examples did not make it clear how `Monad`s could be a "computation." While `bind`/`>>=` insures that one computation occurs before another (i.e. sequential computation), it does not define what kinds of computation are done. Thus, we must explain what "effects"/"capabilities" are.

For the rest of this folder, we'll use the terms, "effects" and "capabilties," interchangeably. Lowercased "effect" refers to something different than the `Effect` monad.

## Effects / Capabilities

To understand what we mean by "effects" (and due to license-related things), read through the first two sentences of [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html), then continue reading this page.

### Examples of Effects / Capabilities

Capabilities can be grouped together into type class functions that define computations which `bind` executes in a sequential manner. These type classes are specialized; they are designed to do one thing very very well.

So what kind of "capabilities" can we have? Let's now give some examples via the table below:

| When we want a type of computation (effect) that... | ... we expect to use functions named something like ... | ... which are best abstracted together in a type class called...
| - | - | - |
| Provides for later usage a read-only value/function that may change between different program runs<br>(e.g. "settings" values; dependency injection) | <ul><li>`getSettingValue`</li><li>`getConfigValueStoredOnFile`</li><li>`getNumberOfPlayersInGame`</li></ul> | [`MonadAsk`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadAsk)
| Modifies the state of a data structure<br>(e.g. changing the nth value in a list)| <ul><li>`pop stack`</li><li>`replaceAt index treeOfStrings "some value"`</li><li>`(\int -> int + 1)`</li></ul> | [`MonadState`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)
| Returns a computation's output and additional data that is generated during the computation | <ul><li>[See this SO answer](https://stackoverflow.com/a/27651976)</li><li>[See this Reddit thread](https://www.reddit.com/r/haskell/comments/3faa02/what_are_some_real_world_uses_of_writer/)</li></ul> | [`MonadTell`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadTell)
| Stops computation because of a possible error<br>(e.g. "file does not exist") | -- | [`MonadThrow`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadThrow)
| Deals with "callback hell"<br>(e.g. [de-invert inversion of control](http://www.thev.net/PaulLiu/invert-inversion.html)) | -- | [`MonadCont`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Cont.Class#t:MonadCont)

| When we want to extend the functionality of... | ... with the ability to... | ... we can use its extension type class called...
| - | - | - |
| MonadAsk | Modify the read-only value for one computation<br>(e.g. `makeFontSizeMoreAccessible getFontSize displayPage`) | [`MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadReader)
| MonadTell | Modify or use the additional non-output data before completing a computation | [`MonadWriter`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadWriter)
| MonadThrow | Catch and handle the error that was thrown<br>(e.g. create the missing file) | [`MonadError`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadError)

## Modeling Effects

In this folder, we'll only cover `MTL`/`ReaderT Design Pattern` and `Free`/`Run`. The article to which we referred above overviews more ideas, but that is not our current focus. It might be worth returning to it after one has read through the rest of this folder.

### Composing Monads

As we explained previously, `bind`/`>>=`'s type signature forces one to only return the same `Box`-like monad type that is used in bind:
```haskell
bind :: forall a. f   a -> ( a    -> f   b)           -> f    b
bind :: forall a. Box a -> ( a    -> Box b         )  -> Box  b
bind             (Box 4)   (\four -> Box (show four)) == Box "4"
```

**In other words, if we use one monad, we cannot use any other monads.** So, how do we get around this limitation?

We saw the same problem earlier when we wanted to run an `Effect` monad inside of an `Aff` monad. We fixed it by "lifting" the `Effect` monad into the `Aff` monad via a [`NaturalTransformation`](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.NaturalTransformation#t:NaturalTransformation)/`~>`. This was abstracted into a type class specific for `Effect ~> someOtherMonad` in [`MonadEffect`](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#t:MonadEffect).

`MTL` and `Free` use different approaches to solving this problem and its solution is what creates the Onion Architecture-like idea we mentioned before. As we saw earlier in Nate's video in this folder's ReadMe, `mtl` is the "Final Encoding" style and `Free`/`Run` is the "Initial Encoding" style.

**The following ideas are quick overviews of each approach. Their terminology and exact details will be explained in their upcoming folder. It is not meant to be clearly understandable at first.**

#### MTL Approach

**Monad Transformers** are thus named because they "transform" some other monad by augmenting it with additional functions. One monad (e.g. `Box`) can only use `bind` and `pure` to do sequential computation. However, we can "transform" `Box`, so that it now has state-manipulating functions like `get`/`set`/`modify`. "MTL" refers to the original "Monad Transformers Library" (I believe).

In the `MTL`-approach, one models the above effects using functions (we'll show how later). Since monad transformers augment some "base" monad, it creates a stack-like picture (read from bottom to top):
```
BaseMonad
      ^
      | augments
      |
Pure MonadState
```

Since each function is a different monadic type, they cannot be used within the same monadic context in `do notation`. Thus, one gets around this monad-composition problem by creating a "stack" of nested monad transformers (i.e. functions). Following the previous idea, we can define **something similar to** a `NaturalTransformation` that "lifts" the effects of one monadic function (e.g. a function that implements `MonadReader`) into another monadic function (e.g. a function that implements `MonadState`), which augments the base monad. Using a visual, it produces this diagram (read from bottom to top):
```
BaseMonad
      ^
      | augments
      |
Pure MonadState_TargetMonad
      ^
      | gets lifted into
      |
Pure MonadReader_SourceMonad
```
Generalizing this idea, we must ultimately create a "stack" of these function-based monad-transformers. Using a visual, it produces this diagram (read from bottom to top):
```
BaseMonad
      ^
      | augments
      |
Pure MonadState
      ^
      | gets lifted into
      |
Pure MonadWriter
      ^
      | gets lifted into
      |
Pure MonadReader
```

This idea is at the heart of the type class called `MonadTrans`. Again, you should feel somewhat confused right now and a bit overwhelmed. However, we'll refer to these ideas later to help explain why we make some of the design choices that we do. By the end of this folder, this will all make sense.

#### Free

In the `Free`-approach, one models the above effects using data structures (again, we'll show how later). Essentially, one uses domain-specific languages (DSLs) created via data structures to define an Abstract Syntax Tree (AST). Such trees describe computations but do not run them. Later on, an AST is "interpreted" (via a `NaturalTransformation`/`~>`) into a final base monad that actually runs the computation. Using a visual, it produces this diagram (read top to bottom):
```
Pure High-Level Language
      |
      | gets interpreted into
      |
     \ /
Base Monad
```
Due to how interpreters work, one can define high-level ASTs that are interpreted into lower-level ASTs before being run by a base monad. Using a visual, it produces this diagram (read from bottom to top):
```
Pure AST via High-Level Language
      |
      | gets interpreted into
      |
     \ /
Pure AST via Medium-Level Language
      |
      | gets interpreted into
      |
     \ /
Pure AST via Low-Level Language
      |
      | gets interpreted into
      |
     \ /
Base Monad
```
