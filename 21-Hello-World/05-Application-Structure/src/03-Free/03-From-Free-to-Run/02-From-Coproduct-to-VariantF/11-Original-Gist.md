# Original Gist

My code diverges from the original gist's code by
- converting the unfamiliar `Matryoshka`-library types and names into the more familiar types and names we've been using here
- defining algebras only via "on" (i.e. `on symbol function`) rather than using "onMatch" (i.e. `onMatch {value: function, add: function}`)
- the original paper showed how to define an expression that only allowed `Value` and `Multiply` operations. xgrommx's original gist did not have this.

The following table will help you understand the upcoming links to code:

| Our Code | xgrommx's code |
| - | - |
| `newtype Expression f` | [`newtype Mu f`](https://pursuit.purescript.org/packages/purescript-fixed-points/5.1.0/docs/Data.Functor.Mu#t:Mu)
| `Expression (VariantF t)` | `MuV t`
| `In $ inj symbol data` | `injMu symbol data`
| `f a -> a` | [`Algebra f a`](https://pursuit.purescript.org/packages/purescript-matryoshka/0.3.0/docs/Matryoshka.Algebra#t:Algebra)
| `fold` | [`cata`](https://pursuit.purescript.org/packages/purescript-matryoshka/0.3.0/docs/Matryoshka.Fold#v:cata)<br>`Recursive t f` can be better understood as `t (f t) -> f t`

The links:
- Read from `ADT1.purs` to `ADT6.purs`: [From Algebraic Data Types (ADTs) to Extensible Algebraic Data Types (EADTs)](https://github.com/xgrommx/purescript-from-adt-to-eadt/tree/master/src). This will help us get used to the different names he uses for the same ideas
- The [original gist](https://gist.github.com/xgrommx/35f912544d37420db5f195c9b515ceb3)
