# Type Classes

Type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 1-4 things:

1. (Almost Always) The definition of type signatures for a single/multiple functions/values.
    - Functions may be put into infix notation using aliases to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
3. (Frequently) The functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.
        - For example, `Apply` is a less powerful typeclass than Monad because it does not have `bind` but is more flexible than Monad because it can compute things in parallel.
4. (Sometimes) Something that combines multiple type classes together into one.

Here are some examples:
- The `Show` typeclass specifies a type signature for a function called `show`, but implementations don't have any laws for it, nor are there any derived functions.
- The `Eq` type class specifies a type signature for a function called `eq` and `notEq`, and laws for the two, but there are not any derived functions.
- The `Ord` type class is similar to `Eq`, but it does have derived functions.

Lastly, the `Functor` type class (explained in more detail later) has all three:

(1) The type class `Functor` specifies the type signature of a function called `map`. It does not specify a type signature for a value:
```purescript
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b
```
and it uses the alias `<$>` for `map` to enable one to write `function <$> f_a` instead of `map function f_a`

(2) It also specifies the laws to which a correct implementation will adhere when implementing `map`:
- identity: `map id fa == fa` where `id` is `(\x -> x)`. In other words, if the function returns what it is given, then I should get back the same data structure that I put into `map`.
- composition: `map (function2 <<< function1) fa == (map function2) <<< (map function1 fa)` where `f <<< g a` is `f(g(a))`. In other words, rather than unwrapping and rewrapping the value stored in a Functor (e.g. Box) twice, I can unwrap it only once.

(3) Once `map` has been implemented correctly, Functor provides the following derived functions:
- void
- voidRight
- voidLeft
- mapFlipped
- flap

To understand how typeclasses work, read [this article about 'dictionaries'](https://www.schoolofhaskell.com/user/jfischoff/instances-and-dictionaries)
