# Other Monad Transformers

## Usable Now

### RWS

[RWS](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.RWS.Trans#t:RWST) a convenience monad that combines `ReaderT`, `WriterT`, and `StateT` into the same monad type

### MaybeT

[MaybeT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Maybe.Trans#t:MaybeT), a computation the returns a `Maybe a`. The below code snippet shows why you'd use it and when:

Before (ugly verbose code):
```haskell
getName :: Effect (Maybe String)
getAge :: Effect (Maybe Int)

main :: Effect Unit
main = do
  maybeName <- getName
  case maybeName of
    Nothing -> log "Didn't work"
    Just name -> do
      maybeAge <- getAge
      case maybeAge of
        Nothing -> log "Didn't work"
        Just age -> do
          log $ "Got name: " <> name <> " and age " <> show age
```
After (clear readable code):
```haskell
getName :: Effect (Maybe String)
getAge :: Effect (Maybe Int)

main :: Effect Unit
main = do
  result <- runMaybeT do
    name <- MaybeT getName
    age <- MaybeT getAge
    pure { name, age }
  case result of
    Nothing -> log "Didn't work"
    Just rec -> do
      log $ "Got name: " <> rec.name <> " and age " <> show rec.age
```

You can refer to [Monday Morning Haskell's post on MaybeT](https://mmhaskell.com/monads-6) for more context. Replace `IO` with `Effect` and you'll get the idea.

### ListT

[ListT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.List.Trans#t:ListT), a monad that returns a `List a`. In addition, it provides the regular list functions you'd expect

It follows the same idea as `MaybeT` above.

### MonadGen

[MonadGen](https://pursuit.purescript.org/packages/purescript-gen/2.1.0/docs/Control.Monad.Gen.Class#t:MonadGen) (not included in the `purescript-transformers` library): generates random data. (This is used in the Testing library later. We'll cover it when we get there.)

### MonadRec

[MonadRec](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#t:MonadRec) (not included in the `purescript-transformers` library): guarantees stack safety for monad transformers. For a tutorial on this type class, see `Design Patterns/Stack Safety.md`.

## Sketches of Monadic Control Flow

I'd like to clean this up and provide more, but I don't know what it's copyright is. Thus, I'm only linking to it here. The below link is a visual idea as to what occurs when one uses some of these monad transformers:
[Monads, a Field Guide](http://blog.sigfpe.com/2006/10/monads-field-guide.html?m1)

## Requires More Understanding

We previously mentioned that all lawful type classes that find their roots in Category Theory have duals. The following are monad transformers for the duals of some of the monad transformers we covered here.

To quickly summarize how they work, `map`ping a monadic function would change its output type whereas `map`ping a comonadic function would change its input type. If the definition of `Functor`'s `map` for a monadic function is `compose`/`<<<`, the definition for a comonadic function is `composeFlipped`/`>>>`. See the [CoMonads by Example](https://github.com/ChrisPenner/comonads-by-example/tree/master/src/Comonads) repository for a better overview of these type classes and their implementations.

- [CoMonadTrans](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Trans.Class), the Transformer type class for Comonads.
- [CoMonadTraced](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Traced.Class#t:ComonadTraced)
- [CoMonadStore](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Store.Class)
- [CoMonadAsk](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Env.Class#t:ComonadAsk)
- [CoMonadEnv](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Env.Class#t:ComonadEnv)
