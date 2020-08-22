# Type Classes

## What Problem Do Type Classes Solve?

Their primary use is to make writing some code more convenient / less boilerplatey. Rather than writing the same code 25 different times where it differs in only one way each time, we can write code once and "parameterize it" in 25+ different ways.

To see a bottom-up explanation of this idea, read through the bullet points below and then watch the video.
- This video is a recording of a presentation given by Nathan Faubion, a core contributor to PureScript.
- This video finishes explaining what type classes are around 22:54.
- The parts that follow are more advanced concepts. They explain how to make "real world code" easily testable via type classes and interpreters. You might not understand those explanations until you are more familiar with PureScript syntax.
- The presentation ends at 1:03:58. Nate starts answering people's questions after that.
- Nate's answers to various questions ends at 1:13:12 and the rest of the video are people talking about various PureScript things.
- While Nate explains that type classe enable "code reuse," one could use an approach called "scrap your type classes" (SYTC) to accomplish that goal. SYTC will be covered later in this file.

Video: [Code Reuse in PureScript: Functions, Type Classes, and Interpreters](https://youtu.be/GlUcCPmH8wI?t=24) (actual video title on YouTube: "PS Unscripted - Code Reuse in PS: Fns, Classes, and Interpreters")

## Where Do Type Classes Come From?

Type classes are usually "encodings" of various concepts from mathematics, specifically abstract algebra and category theory.

Type classes make developers productive. They enable programmers...
    - to write 1 line of code that is the equivalent of writing 100s of lines of code.
    - to define complicated control flows that highlight the important parts and minimize the irrelevant boilerplatey parts (e.g. nested "if then else" statements)
    - to use (in general) 5 ["dumb reusable data types"](https://www.youtube.com/embed/hIZxTQP1ifo?start=1225&end=1334) to solve most of our problems:
      - Maybe - a box that is either empty or has a value.
      - Either - a sum type: either has a Left value or a Right value
      - Tuple - a product type: has both an A value and a B value
      - List - self-explanatory
      - Tree - self-explanatory

## Type Classes as Encodings of Mathematical Concepts

Putting it differently, if `Some type` can implement some `function(s)/value(s) with a specified type signature` in such a way that the implementation adheres to `specific laws`, one can say it **has** an instance of the given type class. Some types cannot satisfy a given type class' conditions; others can satisfy them in only one way; and still others can satisfy them in multiple ways. Thus, one does not say "`Type X` **is** an instance of &lt;some type class&gt;." Rather, one says "`Type X` **has** an instance of &lt;some type class&gt;." To see this concept in a clearer way and using pictures, see https://www.youtube.com/watch?v=iJ7V1KXJpsE

Thus, type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 2-3 things:

1. (Always) The definition of type signatures for a single/multiple functions/values.
    - Functions may be put into infix notation using symbolic aliases (e.g. `<$>`) to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
    - **Laws cannot be enforced by the compiler.** For example, one could define a type class' instance for some type which satisfies the type signature. However, the implementation of that instance might not satisfy the type class' law(s). The compiler can verify that the type signature is correct, but not the implementation. Thus, one will need to insure an instance's lawfulness via tests, (usually by using a testing library called `quickcheck-laws`, which is covered later in this repo)
3. (Frequently) The functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.
        - For example, one can consider `Apply` and `Monad`. `Apply` is a less powerful typeclass than `Monad` because it requires its arguments to be known at compile-time whereas `Monad`'s arguments must be known at runtime. However, `Apply` is more flexible because it can compute things in parallel whereas `Monad` must compute things sequentially.

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

## Similarities and Dual Relationships Among Type Classes

Some type classes have a corresponding "dual." While there are better ways to explain duals, the basic idea is that the "direction" of the function's arrow gets flipped. When this happens, we usually prefix them with "Co". For example, if we have a type class called `Monad`, the dual of it is called `Comonad`. If `Monad` has laws `A` and `B`, then it's likely that `Comonad` will have laws `A'` and `B'`, which are "flipped" version of `A` and `B`.

For example, a function like `toB` would have its arrow flipped to produce `toA`::

```purescript
toB :: a -> b
toB = -- function's implementation

    -- a <- b
toA :: b -> a
toA = -- function's implementation
```

## Type Class Instances: Global vs Local

Since type classes encapsulate the 2-3 ideas above, often multiple different types (e.g. `Box`, `Array`, `Maybe`, etc.) can satisfy a type class' requirements (e.g. `Functor`, etc.). Thus, rather than writing code that states, "This function will only work on Arrays of Strings," one often writes code that states, "This function will work for any data type that can satisfy the requirements of the `Functor` type class)."

To state that a given type (e.g. `Box`) can satisfy a type class' requirements, one writes a "**type class instance**". This instance actually defines how a given type (e.g. `Box`) implements that type class (e.g. `Functor`). Philosophically, type class instances can come in two forms: global or local. PureScript uses global type class instances whereas languages like Scala use local type class instances. So, what's the difference?

### Benefits of Global Instances

Let's say I use functions that require the underlying data type to satisfy the `Functor` type class' requirements. Sometimes, that underlying data type is `Array`. Sometimes, it's `Box`. Sometimes, it's `Maybe`.

Global instances mean that a given data type (e.g. `Box`) can only have one instance for a given type class (e.g. `Functor`). Thus, every time and everywhere that I use `Functor` in my code where the underlying type is `Box`, the same Box-Functor instance is always used. This makes it easy for the compiler to figure out which instance to use, and the programmer does not have to think deeply about which instance will be used.

Local instances mean that a given data type (e.g. `Box`) can have an infinite number of instances for a given type class (e.g. `Functor`). Thus, any time I use `Functor` in my code and the underlying type is `Box`, any one of its instances could be used. This makes it harder for the compiler to figure out which instance to use. Ultimately, the compiler chooses an appropriate instance based on which instance is "closest" in the given scope. Moreover, the programmer has to think more deeply about how to properly configure/arrange their code, so that the instance they want the compiler to choose is actually chosen and used.

### Costs of Global Instances: Orphan Instances

Given this tradeoff, it may seem strange that global instances aren't used everywhere. If it's easier for the compiler and programmer, why use local instance?

The major pain point of global instances is "orphan instances."

Due to how global instances work, an instance for a type class must be defined in one of two ways. The first way is defining it in the same file where the original data type is declared. For example, if a type class, `MyTypeClass`, was defined in `File1.purs` and my data type, `Box`, was defined in `File2.purs`, the `Box`-`MyTypeClass` instance would be defined somewhere in `File2.purs`, which would import the `MyTypeClass` type class.

The second way is defining it in the same file where the original type class is declared. For example, if a type class, `MyTypeClass`, was defined in `File1.purs` and my data type, `Box`, was defined in `File2.purs`, the `Box`-`MyTypeClass` instance would be defined somewhere in `File1.purs`, which would import the `Box` data type.

If an instance is defined anywhere else, it's called an "orphan instance." For example, if `Box` was defined in `File1.purs` and `MyTypeClass` was defined in `File2.purs`, then defining a `Box`-`MyTypeClass` instance in `File3.purs` would be an "orphan instance."

### Why Orphan Instances Are Painful

#### An Example

Let's say you have a library called `purescript-unordered-collections` that defines a data type called `HashMap`. Let's say you have another library called `purescript-argonaut-codecs` that defines two type classes called `EncodeJson` and `DecodeJson`. Where do you define `HashMap`'s instances for those two type classes?

If in the data-type library (where the `HashMap` data type is declared), then that library will need to depend on the codec library.
If in the codec library (where the `EncodeJson/DecodeJson` type classes are declared), then it will need to depend on the data-type library.

Either way, someone will get annoyed by something:
  - once the instance is defined in either library, everyone in the ecosystem is now stuck using that instance's definition. If they thought it should have been defined differently, they often have to write boilerplatey code via `newtype`s to be able to define their own instances.

Languages with local instances can shrug their shoulders as they have more control as to which instance gets chosen.

#### The `Default` Type Class

Type classes provide a "convenience" of sorts: rather than forcing the developer to pass in an implementation of the function, `(a -> Boolean)`, the compiler can infer what that function's implementation is **as long as it can infer what the type of `a` is**.

Thus, new learners tend to reach the following conclusion. Let's say you are writing a library where you want to make it easier for the developer to use this library. At some point in the library, you need them to provide a default value. "Gee!" you think, "Why not use a type class called `Default`? The compiler can infer which instance to use and the developer's life will be that much easier!" While your intentions are good, that's a terrible idea as it will lead to "instance wars" due to orphan instances.

Although it can suffer from similar problems, a better choice is `Monoid`. See Gabriel Gonzalez' post on [Defaults](http://www.haskellforall.com/2013/04/defaults.html).

Similarly, read [Don't Use Type Classes to Define Default Values](https://www.reddit.com/r/haskell/comments/5gospp/dont_use_typeclasses_to_define_default_values/).

### Summary of Global vs Local Type Class Instances' Tradeoffs

| Type | Pros | Cons |
| - | - | - |
| Global | <ul><li>Easier for the compiler to find an instance</li><li>To the programmer, it's obvious which instance will be used</li></ul> | Orphan Instances or writing boilerplatey code to get around them |
| Local | <ul><li>Harder for the compiler to find an instance</li><li>To the programmer, it's not obvious which instance will be used and sometimes very difficult to properly configure/arrange one's code, so that the correct instance is eventually used</li></ul> | Best instance for the problem can be used without boilerplate |

Scala uses local instances. Haskell uses global instances and orphan instances are disallowed by default; however, I believe Haskell has an "escape hatch" that allows orphan instances to exist.

PureScript uses global instances, and orphan instances are strictly disallowed. Unlike Haskell, there are no "escape hatches." For more context, see [Harry's comment in 'Disallow Orphan Instances' (purescript/purescript#1247)](https://github.com/purescript/purescript/issues/1247#issuecomment-512975645).

## Scrap Your Type Classes (SYTC)

At the end of the day, mainstream usage of type classes provide a lot of convenience to the developer. Rather than defining a function that takes many arguments, it only takes a few arguments that highlight what you want to do.

As a result, some developers who encounter a problem will immediately decide to use type classes as their solution rather than some other language feature that is more appropriate (e.g. regular functions). For some problems, it is better to use regular functions rather than type classes. Regular functions might be less convenient than type classes, but they can be easier to use in some cases and more performant in others.

To understand the tradeoff, you must
1. understand that [type class constraints are replaced with arguments called 'type class dictionaries'](https://www.schoolofhaskell.com/user/jfischoff/instances-and-dictionaries)
2. realize that the possibly "larger" type class dictionary object argument could be replaced with a "smaller" single function

For more context, see [Scrap Your Type Classes](http://www.haskellforall.com/2012/05/scrap-your-type-classes.html)

## Other Usages of Type Classes

Some type classes are purposefully designed to be lawless because they are used for other situations. Here are some examples:
- Type-level documentation
    - `Partial` - represents a partial function: a function that does not always return a value for every input, but which will throw a runtime error on some inputs (covered in `Design Patterns/Partial Functions`)
- Custom compiler warnings/errors
    - `Warn`/`Fail` - causes the compiler to emit a custom warning or a compiler error when the associated function/value is used in the code base (covered in `Hello World/Debugging/Custom Type Errors`)
- Type-level functions
    - `Symbol.Append` - represents a type-level function (covered in `Syntax/Type-Level Programming Syntax` and `Hello World/Type-Level Programming`).
- Function/Value Name Overloading (see next section's explanation and debate about this idea)

### Debate: Must Type Classes Always Be Lawful?

While I already linked to the following link in the 'default type class' issue explained above, the link also covers another topic: why type classes should be lawful. Focusing on that aspect, the following is a (somewhat biased) summary of [Don't Use Type Classes to Define Default Values](https://www.reddit.com/r/haskell/comments/5gospp/dont_use_typeclasses_to_define_default_values/)

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
