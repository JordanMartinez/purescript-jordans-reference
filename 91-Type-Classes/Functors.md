# Functors

## Variance of Functors

This is a summary of [this post](https://typeclasses.com/contravariance) and [this post](https://www.schoolofhaskell.com/user/commercial/content/covariance-contravariance).

When we look a `Function`'s definition, we see that it is higher-kinded by two, that is, two types need to be defined before we can have a concrete type:
```haskell
foreign import data Function :: Type -> Type -> Type

infix ? Function as ->

-- Rather than writing `Function input output`
-- we write `input -> output`
no_sugar :: Function Input Output

syntax_sugar :: Input -> Output

generic_on_input :: forall a. a -> Output

generic_on_output :: forall b. Input -> b

generic_on_both :: forall a b. a -> b
```
A type can be a `Functor` if it is higher-kinded by one. In the below example, we specify its input type and leave the output type to be defined in `map`:
```haskell
                   -- (input ->)
instance Functor (Function input) where
                              -- (input -> a)     -> (input -> b)
  map :: forall a b. (a -> b) -> Function input a -> Function input b
  map aToB inputToA = (\input -> aToB (inputToA input))
```
However, what if we specified the output type of `Function` in the instance head and left the input type to be defined in `map`? If so, it would look like this:
```haskell
type FlippedFunc output input = (input -> output)
                   -- (-> output)
instance Functor (FlippedFunc output) where
                              -- (a -> output)        -> (b -> output)
  map :: forall a b. (a -> b) -> FlippedFunc output a -> FlippedFunc output b
  map inputA_To_InputB inputA_To_Output = -- this isn't possible to implement!
```
We cannot define an instance of `Functor` in this way because the first argument in `map` changes an `a` value to a `b` value. However, if we flipped the direction of the arrow, we could write the function's body:
```haskell
type FlippedFunc output input = (input -> output)

                         -- (-> output)
instance SomethingElse (FlippedFunc output) where
                                  -- (a -> output)        -> (b -> output)
  map_ish :: forall a b. (b -> a) -> FlippedFunc output a -> FlippedFunc output b
  map_ish inputB_To_InputA inputA_To_Output =
    (\inputB -> inputA_To_Output (inputB_To_InputA inputB))
```
The above type class is called [`Contravariant`](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Functor.Contravariant#t:Contravariant) and `map_ish` is called `cmap`.

### Functor Re-examined

The above two type classes, `Functor` and `Contravariant`, are the same except for the direction of the arrow in the `map`/`cmap`'s first function argument. The former is called `Functor` instead of `Covariant` because it appears more often than the latter.

| Real Name | Purescript Name | Frequency of Appearance | Usage
| - | - | - | - |
| Covariant Functor | Functor | Very frequent | Changes the output of a function
| Contravariant Functor | Contravariant | Infrequent | Changes the input of a function

### Positive and Negative Position

However, there are actually special names for the input and output types:
> **Positive** position: the type variable is the result/output/range/codomain of the function
> **Negative** position: the type variable is the argument/input/domain of the function

Or to put it into meta-language: `negativePosition -> positivePosition`

These terms are used so that one can ultimately determine whether a given type is a Covariant or Contravariant Functor by the rules of multplication:

| position 1 | position 2 | end position
| + | + | + |
| - | - | + |
| - | + | - |
| + | - | - |

To understand how this works in practice, see [Contravariant Functors are Weird](https://sanj.ink/posts/2020-06-13-contravariant-functors-are-weird.html)

## The 2+ Different Functors

As explained in `../Variance of Functors.md`, there are two different kinds of `Functor`s: covariant Functors and contravariant Functors.

However, one also hears about `Bifunctor`, `Profunctor`, and `Invariant`. These are just different ways of combining those different kinds of functors together:

| Name | Type Class' function name | Meaning
| - | - | - |
| [Functor](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Functor#t:Functor) | `map`/ `<$>`/`<#>` | Maps 1 type with a Covariant Functor
| [Contravariant](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Functor.Contravariant) | `cmap`/`>$<`/`>#<` | Maps 1 type with a Contravariant Functor
| [Bifunctor](https://pursuit.purescript.org/packages/purescript-bifunctors/4.0.0/docs/Data.Bifunctor#t:Bifunctor) | `bimap` | <ul><li>1st Type: **Covariant map** (e.g. `map`)</li><li>2nd Type: **Covariant map** (e.g. `map`)</li></ul>
| [Profunctor](https://pursuit.purescript.org/packages/purescript-profunctor/4.0.0/docs/Data.Profunctor) | `dimap` | <ul><li>1st Type: **Contravariant map** (e.g. `cmap`)</li><li>2nd Type: **Covariant map** (e.g. `map`)</li></ul>
| [Invariant](https://pursuit.purescript.org/packages/purescript-invariant/4.1.0/docs/Data.Functor.Invariant#t:Invariant) | `imap` | Maps 1 type with either/both a Covariant Functor or/and a Contravariant Functor

See also [this Profunctor](https://typeclasses.com/profunctors) explanation
