# Variance of Functors

This is a summary of [this post](https://typeclasses.com/contravariance) and [this post](https://www.schoolofhaskell.com/user/commercial/content/covariance-contravariance).

When we look a `Function`'s definition, we see that it is higher-kinded by two, that is, two types need to be defined before we can have a concrete type:
```purescript
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
```purescript
                   -- (input ->)
instance a :: Functor (Function input) where
                              -- (input -> a)     -> (input -> b)
  map :: forall a b. (a -> b) -> Function input a -> Function input b
  map aToB inputToA = (\input -> aToB (inputToA input))
```
However, what if we specified the output type of `Function` in the instance head and left the input type to be defined in `map`? If so, it would look like this:
```purescript
type FlippedFunc output input = (input -> output)
                   -- (-> output)
instance a :: Functor (FlippedFunc output) where
                              -- (a -> output)        -> (b -> output)
  map :: forall a b. (a -> b) -> FlippedFunc output a -> FlippedFunc output b
  map inputA_To_InputB inputA_To_Output = -- this isn't possible to implement!
```
We cannot define an instance of `Functor` in this way because the first argument in `map` changes an `a` value to a `b` value. However, if we flipped the direction of the arrow, we could write the function's body:
```purescript
type FlippedFunc output input = (input -> output)

                         -- (-> output)
instance a :: SomethingElse (FlippedFunc output) where
                                  -- (a -> output)        -> (b -> output)
  map_ish :: forall a b. (b -> a) -> FlippedFunc output a -> FlippedFunc output b
  map_ish inputB_To_InputA inputA_To_Output =
    (\inputB -> inputA_To_Output (inputB_To_InputA inputB))
```
The above type class is called [`Contravariant`](https://pursuit.purescript.org/packages/purescript-contravariant/4.0.0/docs/Data.Functor.Contravariant#t:Contravariant) and `map_ish` is called `cmap`.

## Functor Re-examined

The above two type classes, `Functor` and `Contravariant`, are the same except for the direction of the arrow in the `map`/`map_ish`'s first function argument. The former is called `Functor` instead of `Covariant` because it appears more often than the latter.

| Real Name | Purescript Name | Frequency of Appearance | Usage
| - | - | - | - |
| Covariant Functor | Functor | Very frequent | Use an `a`
| Contravariant Functor | Contravariant | Infrequent | Make an `a`

## Positive and Negative Position

However, there are actually special names for the input and output types:
> **Positive** position: the type variable is the result/output/range/codomain of the function
> **Negative** position: the type variable is the argument/input/domain of the function

Or to put it into meta-language: `negativePosition -> positivePosition`

These terms are used so that one can ultimately determine whether a given type is a Covariant or Contravariant Functor by the rules of multplication:

| position 1 | position 2 | end position
| - | - | - |
| + | + | + |
| - | - | + |
| - | + | - |
| + | - | - |
