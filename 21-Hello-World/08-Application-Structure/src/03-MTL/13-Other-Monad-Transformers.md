# Other Monad Transformers

## Usable Now

- [RWS](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.RWS.Trans#t:RWST) a convenience monad that combines `ReaderT`, `WriterT`, and `StateT` into the same monad type
- [ListT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.List.Trans#t:ListT), a monad that returns a `List a`. In addition, it provides the regular list functions you'd expect
- [MaybeT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Maybe.Trans#t:MaybeT), a monad the returns a `Maybe a`
- [MonadRec](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#t:MonadRec) (not included in the `purescript-transformers` library): guarantees stack safety for monad transformers

## Requires More Understanding

We previously mentioned that all lawful type classes that find their roots in Category Theory have duals. The following are monad transformers for the duals of some of the monad transformers we covered here.

- [CoMonadTrans](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Trans.Class), the Transformer type class for Comonads.
- [CoMonadTraced](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Traced.Class#t:ComonadTraced)
- [CoMonadStore](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Store.Class)
- [CoMonadAsk](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Env.Class#t:ComonadAsk)
- [CoMonadEnv](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Comonad.Env.Class#t:ComonadEnv)
