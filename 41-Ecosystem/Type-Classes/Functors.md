# Functors

As explained in `Design Patterns/Variance of Functors.md`, there are two different kinds of `Functor`s: covariant Functors and contravariant Functors.

However, one also hears about `Bifunctor`, `Profunctor`, and `Invariant`. These are just different ways of combining those different kinds of functors together:

| Name | Type Class' function name | Meaning
| - | - | - |
| [Functor](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Functor#t:Functor) | `map`/ `<$>`/`<#>` | Maps 1 type with a Covariant Functor
| [Contravariant](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Functor.Contravariant) | `cmap`/`>$<`/`>#<` | Maps 1 type with a Contravariant Functor
| [Bifunctor](https://pursuit.purescript.org/packages/purescript-bifunctors/4.0.0/docs/Data.Bifunctor#t:Bifunctor) | `bimap` | Maps 1 type with **a Covariant** Functor and maps 1 other type with a Covariant Functor<br>
| [Profunctor](https://pursuit.purescript.org/packages/purescript-profunctor/4.0.0/docs/Data.Profunctor) | `dimap` | Maps 1 type with **a Contravariant Functor** and maps 1 other type with a Contravariant Functor
| [Invariant](https://pursuit.purescript.org/packages/purescript-invariant/4.1.0/docs/Data.Functor.Invariant#t:Invariant) | `imap` | Maps 1 type with either/both a Covariant Functor or/and a Contravariant Functor
