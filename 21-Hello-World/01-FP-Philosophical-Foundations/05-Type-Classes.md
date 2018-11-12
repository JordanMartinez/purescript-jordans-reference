# Type Classes

## A Short Intro to Category Theory

In short, type classes are usually "encodings" of various concepts from Category Theory. Category Theory (herafter referred to as 'CT') is all about functions and their compositions. Fortunately, a programmer often has an easier time understanding CT than a mathematician. Why? AFAIK, a mathematician learning CT feels something like this:

> A programmer is told to write the implementation for a function. When shown the function, he sees a type signature, `QLD -> M42X`. He asks his boss, "What are the instances of the `QLD` type!? What are the instances of the `M42X` type!?" His boss replies, "You cannot know, nor will you ever know. Now get to work." Terrified, he tries writing something and hopes the compiler will issue a warning that gives him a hint." After compilining, the console mockingly reads, "Error. Try again." How does he implement the function?

The issue described above is that a mathematician cannot "peek" through the type to see what its instances are whereas a programmer can. Once a programmer knows that `QLD` is a type alias for `Apple`, whose only instance is `Apple` and `M42X` is a type alias for `String`, a programmer knows that the function is as simple as writing `functionName Apple = "Apple"`:

```purescript
data Apple = Apple
type QLD = Apple
type M42X = String

functionName :: QLD -> M42X
functionName Apple = "Apple"
```

## Type Classes As Category Theory Terms

Putting it differently, if `Some type` can implement some `function(s)/value(s) with a specified type signature` in such a way that the implementation adheres to `specific laws`, one can say it **has** an instance of `some CT concept/term`. Some types cannot satisfy some CT terms' conditions, others can satisfy them in only one way; and still others can satisfy them in multiple ways. Thus, one does not say "`Type X` **is** an instance of [some CT Term]." Rather, one says "`Type X` **has** an instance of [some CT Term]." To see this concept in a clearer way and using pictures, see https://www.youtube.com/watch?v=iJ7V1KXJpsE

Thus, type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 1-4 things:

1. (Almost Always) The definition of type signatures for a single/multiple functions/values.
    - Functions may be put into infix notation using aliases to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
3. (Frequently) The functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.
        - For example, `Apply` is a less powerful typeclass than `Monad` because it does not have `bind` but is more flexible than `Monad` because it can compute things in parallel.
4. (Sometimes) Something that combines multiple type classes together into one.

While it is possible for a programmer to define a type class without laws, there is a debate about whether this is a good decision. Most say classes should always have laws (i.e. be a term from Category Theory) whereas others say laws should not always be required because it enables reusing the same function name for the same concept (i.e. be 'just' an interface). The counterargument to this last point is that one usually hasn't thought through their design that deeply yet. A Reddit thread discusses some of the tradeoffs of each approach here: https://www.reddit.com/r/haskell/comments/5gospp/dont_use_typeclasses_to_define_default_values/

## Examples

Here are some examples that demonstrate the combination of the 1-4 elements from above:
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
