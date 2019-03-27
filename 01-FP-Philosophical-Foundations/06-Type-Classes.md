# Type Classes

## What Problem Do Type Classes Solve?

Code reuse. Rather than writing the same code 25 different times where it differs in only one way each time, we can write code once and "parameterize it" in 25+ different ways.

To see a bottom-up explanation of this idea, read through the bullet points below and then watch the video.
- This video finishes explaining what type classes are around 22:54.
- The parts that follow are more advanced concepts. They explain how to make "real world code" easily testable via type classes and interpreters. You might not understand those explanations until you are more familiar with PureScript syntax.
- The presentation ends at 1:03:58. Nate starts answering people's questions after that.
- Nate's answers to various questions ends at 1:13:12 and the rest of the video are people talking about various PureScript things.

Video: [Code Reuse in PureScript: Functions, Type Classes, and Interpreters](https://youtu.be/GlUcCPmH8wI?t=24) (actual video title on YouTube: "PS Unscripted - Code Reuse in PS: Fns, Classes, and Interpreters")

## Where Do Type Classes Come From?

Type classes are usually "encodings" of various concepts from Category Theory. Category Theory (herafter referred to as 'CT') is all about the various ways we can compose functions and do so while adhering to specific laws. It's typically used for control flow (e.g. FP-style "if then else" statements).

Type classes make developers productive. They enable programmers...
    - to write 1 line of code that is the equivalent of writing 100s of lines of code.
    - to define complicated control flows that highlight the important parts and minimize the irrelevant boilerplatey parts (e.g. nested "if then else" statements)
    - to use (in general) 5 ["dumb reusable data types"](https://youtu.be/hIZxTQP1ifo?t=1225) to solve most of our problems:
      - Maybe - a box that is either empty or has a value.
      - Either - a sum type: either has a Left value or a Right value
      - Tuple - a product type: has both an A value and a B value
      - List - self-explanatory
      - Tree - self-explanatory

## Type Classes as Encodings of Mathematical Concepts

Putting it differently, if `Some type` can implement some `function(s)/value(s) with a specified type signature` in such a way that the implementation adheres to `specific laws`, one can say it **has** an instance of `some CT concept/term`. Some types cannot satisfy some CT terms' conditions, others can satisfy them in only one way; and still others can satisfy them in multiple ways. Thus, one does not say "`Type X` **is** an instance of [some CT Term]." Rather, one says "`Type X` **has** an instance of [some CT Term]." To see this concept in a clearer way and using pictures, see https://www.youtube.com/watch?v=iJ7V1KXJpsE

Thus, type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 2-3 things:

1. (Always) The definition of type signatures for a single/multiple functions/values.
    - Functions may be put into infix notation using symbolic aliases (e.g. `<$>`) to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
    - **Laws cannot be enforced by the compiler.** For example, one could define a a type class' instance for some type which satisfies the type signature. However, the implementation of that instance might not satisfy the type class' law(s). The compiler can verify that the type signature is correct, but not the implementation. Thus, one will need to insure an instance's lawfulness via tests, (usually by using a testing library called `quickcheck-laws`, which is covered later in this repo)
3. (Frequently) The functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.
        - For example, one can consider `Apply` and `Monad`. `Apply` is a less powerful typeclass than `Monad` because it requires its arguments to be known at compile-time whereas `Monad`'s arguments must be known at runtime. However, `Apply` is more flexibile because it can compute things in parallel whereas `Monad` must compute things sequentially.

### Examples

Here are some examples that demonstrate the combination of the 2-3 elements from above:
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
- identity: `map (\x -> x) fa == fa`. In other words, if the function returns what it is given, then I should get back the same data structure that I put into `map`.
- composition: `map (function2 <<< function1) fa == (map function2) <<< (map function1 fa)` where `f <<< g a` is `f(g(a))`. In other words, rather than unwrapping and rewrapping the value stored in a Functor (e.g. Box) twice, I can unwrap it only once.

(3) Once `map` has been implemented correctly, Functor provides the following derived functions:
- void
- voidRight
- voidLeft
- mapFlipped
- flap

## Type Classes and Dual Relationships

Each type class from CT has a corresponding "dual." While there are better ways to explain duals, the basic idea is that the "direction" of the function's arrow gets flipped. When this happens, we usually prefix them with "Co" (e.g. the `product` type's "dual" is the `coproduct` type (i.e. a sum type); the `Monad`'s "dual" is `Comonad`) Likewise, the laws of some type class are the "flipped" version of the laws of its dual.

For example, a function like `toB` would have its arrow flipped to produce `toA`::

```purescript
toB :: a -> b
toB = -- function's implementation

    -- a <- b
toA :: b -> a
toA = -- function's implementation
```

## Non-Category Theory Usages of Type Classes

Some type classes are purposefully designed to be lawless because they are used for other situations. Here are some examples:
- Type-level documentation
    - `Partial` - represents a partial function: a function that does not always return a value for every input, but which will throw a runtime error on some inputs (covered in `Design Patterns/Partial Functions`)
- Custom compiler warnings/errors
    - `Warn`/`Fail` - causes the compiler to emit a custom warning or a compiler error when the associated function/value is used in the code base (covered in `Hello World/Debugging/Custom Type Errors`)
- Type-level functions
    - `Symbol.Append` - represents a type-level function (covered in `Syntax/Type-Level Programming Syntax` and `Hello World/Type-Level Programming`).
- Function/Value Name Overloading (see next section's explanation and debate about this idea)

### Debate: Must Type Classes Always Be Lawful?

Type classes provide a "convenience" of sorts: rather than forcing the developer to pass in an implementation of the function, `(a -> Boolean)`, the compiler can infer what that function's implementation is **as long as it can infer what the type of `a` is**.

This understanding is crucial for understanding a debate: must type classes always have laws? The following is a summary (somewhat biased) of [this Reddit thread](https://www.reddit.com/r/haskell/comments/5gospp/dont_use_typeclasses_to_define_default_values/)

Those that say "yes" likely value the benefit of laws. Laws guarantee relationships between functions and values. In short, it's easier to understand and reason about code that uses lots of generic types (e.g. `forall a. a -> String`) if one knows that functions that operate on values of the type, `a`, or values that provide an `a` value adhere to certain laws.

Those that say "no" likely value the benefit of overloading a function name with different implementations. For example, what if one wanted to provide a default value of some type? Reusing the function name "default" is pretty easy to understand. However, what laws does it abide by? Without a deeper context, it's hard, if not impossible, to say.

The counterargument from those that say "laws must be required" is: "one usually hasn't thought through their design that deeply yet." As an example, is `Default Int` just a different name for `Monoid`'s `mempty`, (i.e. `0` in addition (`1 + 0 == 1` and `0 + 1 == 1`)? Is their approach to their design actually flawed because there is a "better" way and they just haven't realized it yet?

Are there cases where the function name would "read well" in two contexts but mean two different things? For example, Context A's use of `default` might return `0` whereas Context B's use of `default` might return `12`.

Thus, it seems that lawless type classes imply a domain-specific meaning in each context whereas lawful type classes imply a domain-independent meaning.

The reader is left with these question:
- Are there ever times where gaining the convenience of overloaded function names are worth the loss of lawful-reasoning?
    - Does this change when adds in other factors?
        - Time (e.g. cost is great short-term but sucks long-term; cost stays the same through short- and long-term)
        - Business cost (e.g. cost to refactor non-lawful type classes vs cost of only making lawful type classes when overloaded functions names would have made development easier / accomplished the goal at the end of the day)
        - Hobby (e.g. I'm just making a fun project that no one will ever use)
- If so, when should it be done? How would one know that it was the wrong approach and when would that likely happen?
- What problems did developer X face when sticking to Side A instead of Side B?
