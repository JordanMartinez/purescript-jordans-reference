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

Thus, type classes abstract general concepts into an "interface" that can be implemented by various data types. They are usually an encapsulation of 2-3 things:

1. (Always) The definition of type signatures for a single/multiple functions/values.
    - Functions may be put into infix notation using aliases to make it easier to write them.
2. (Almost Always) The laws by which implementations of a type class must abide.
    - These laws guarantee certain properties, increasing developers' confidence that their code works as expected.
    - They also help one to know how to refactor code. Given `left-hand-side == right-hand-side`, evaluating code on the left may be more expensive (memory, time, IO, etc.) than the code on the right.
    - **Laws cannot be enforced by the compiler.** For example, one could define a a type class' instance for some type which satisfies the type signature. However, the implementation of that instance might not satisfy the type class' law(s). The compiler can verify that the type signature is correct, but not the implementation. Thus, one will need to insure an instance's lawfulness via tests, (usually by using a testing library called `quickcheck-laws`, which is covered later in this repo)
3. (Frequently) The functions/values that can be derived once one implements the type class.
    - Most of the power/flexibility of type classes come from the combination of the main functions/values implemented in a type class' definition and these derived functions. When a type class extends another, the type class' power increases, its flexibility decreases, and its costs increase.
        - For example, one can consider `Apply` and `Monad`. `Apply` is a less powerful typeclass than `Monad` because it requires its arguments to be known at compile-time whereas `Monad`'s arguments must be known at runtime. However, `Apply` is more flexibile because it can compute things in parallel whereas `Monad` must compute things sequentially.

### Clarifying Type Class Relationships

#### Parent-Child-Like Relationships

While type classes are written using "parent-child"-like syntax...

```purescript
class SomeChildTypeClass a

class (SomeChildTypeClass a) <= SomeParentTypeClass a

class (OneChild a, AnotherChild a) <= ParentThatCombines a
```

...this relationship is only syntactical. In reality, **these parent-child-like relationships are not necessarily hierarchial (the type must satisfy the child before the possibility of satisfying the parent exists) but conditional (the type must satisfy both the child and parent type classes' type signatures and laws by compile-time)**.

This leads to the following possibilities. If a type has an instance for `ParentTypeClass`, then...
- the type's implementation for `ChildTypeClass` must satisfy additional law(s).
- the type's implementation for `ChildTypeClass` can be done more easily / better by using functions/values from `ParentTypeClass`.

In addition, some derived functions for `ParentTypeClass` are only possible if the implementation can use functions from two or more `ChildTypeClass`es

Thus, a parent type class can
1. extend a child type class with additional functions/values
2. restrict a child type class' implementation by imposing additional laws
3. does 1 and 2 in the same type class
4. combine two or more type classes, so that using the parent type class exposes all the functions/values of its children type classes, but does not add any new functions/values or impose any new laws upon its implementations.

#### Dual Relationships

Each type class from CT has a corresponding Dual. While there are better ways to explain duals, the basic idea is that the function arrow's "direction" gets flipped. Likewise, the laws of some type class are the "flipped" version of the laws of its dual.

For example, `Example'` is the dual of `Example`:

```purescript
class Example a where
  toB :: a -> b

class Example' b where
      -- a <- b
  toA :: b -> a
```

### Non-Category Theory Usages of Type Classes

Some type classes are purposefully designed to be lawless because they are used for other situations. Here are some examples:
- Type-level documentation
    - `Partial` - represents a partial function: a function that does not always return a value for every input, but which will throw a runtime error on some inputs (covered in `Design Patterns/Partial Functions`)
- Custom compiler warnings/errors
    - `Warn`/`Fail` - causes the compiler to emit a custom warning or a compiler error when the associated function/value is used in the code base (covered in `Hello World/Debugging/Custom Type Errors`)
- Type-level functions
    - `Symbol.Append` - represents a type-level function (covered later in this repo).
- Function/Value Name Overloading (see next section's explanation and debate about this idea)

## Dictionaries and Lawless Type Classes

Dictionaries are what enable a function/value to magically appear in the implementation of a function's body. Read [this article about type class 'dictionaries'](https://www.schoolofhaskell.com/user/jfischoff/instances-and-dictionaries) as there really is no better way to explain this concept.

After reading the above article, it's clear that this code...
```purescript
class ToBoolean a where
  toBoolean :: a -> Boolean

  unUsed :: a -> String

example :: forall a. ToBoolean a => a -> Boolean
example value = toBoolean value
```

... gets desugared to this code

```purescript
data ToBooleanDictionary a =
  ToBooleanDictionary
    { toBoolean :: a -> Boolean
    , unUsed :: a -> String
    }

example :: forall a. ToBooleanDictionary a -> a -> Boolean
example (ToBooleanDictionary record) value = record.toBoolean value
```

Thus, type classes provide a "convenience" of sorts: rather than forcing the developer to pass in an implementation of the function, `(a -> Boolean)`, the compiler can infer what that function's implementation is **as long as it can infer the type of `a` in `class ToBoolean a`**.

### Debate: Must Type Classes Always Be Lawful?

This understanding is crucial for understanding a debate: must type classes always have laws? The following is a summary (somewhat biased) of [this Reddit thread](https://www.reddit.com/r/haskell/comments/5gospp/dont_use_typeclasses_to_define_default_values/)

Those that say "yes" likely value the benefit of laws. Laws guarantee relationships between functions and values. In short, it's easier to understand and reason about code that uses lots of generic types (e.g. `forall a. a -> String`) if one knows that functions that operate on instances of `a` or values that provide an `a` instance adheres to certain laws.

Those that say "no" likely value the benefit of overloading a function name with different implementations. For example, what if one wanted to provide a default value of some type? Reusing the function name "default" is pretty easy to understand. However, what laws does it abide by? Without a deeper context, it's hard, if not impossible, to say.

```purescript
class Default a where
  default :: a

instance regularInt :: Default Int where
  default = 0

-- in case some prior definition somehow 'got it wrong'
-- one can use newtypes to deal with that
newtype SpecialInt = SpecialInt Int

instance specialInt :: Default SpecialInt where
  default = SpecialInt 7
```

The counterargument from those that say "laws must be required" is: "one usually hasn't thought through their design that deeply yet." As an example, is `Default Int` just a different name for `Monoid`'s `mempty`, (i.e. `0` in addition (`1 + 0 == 1` and `0 + 1 == 1`)? Is their approach to their design actually flawed because there is a "better" way and they just haven't realized it yet? Are there cases where the code would "read well" if one names a function that returns some value `default` in Context A but in Context B, the code would "read well" if one called some other function `default` but which returns a different value than the first function?

The reader is left with these question:
- Are there ever times where gaining the convenience of overloaded function names are worth the loss of lawful-reasoning?
    - Does this change when adds in other factors?
        - Time (e.g. cost is great short-term but sucks long-term; cost stays the same through short- and long-term)
        - Business cost (e.g. cost to refactor non-lawful type classes vs cost of only making lawful type classes when overloaded functions names would have made development easier / accomplished the goal at the end of the day)
        - Hobby (e.g. I'm just making a fun project that no one will ever use)
- If so, when should it be done? How would one know that it was the wrong approach and when would that likely happen?
- What problems did developer X face when sticking to Side A instead of Side B?

## Examples

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
- identity: `map id fa == fa` where `id` is `(\x -> x)`. In other words, if the function returns what it is given, then I should get back the same data structure that I put into `map`.
- composition: `map (function2 <<< function1) fa == (map function2) <<< (map function1 fa)` where `f <<< g a` is `f(g(a))`. In other words, rather than unwrapping and rewrapping the value stored in a Functor (e.g. Box) twice, I can unwrap it only once.

(3) Once `map` has been implemented correctly, Functor provides the following derived functions:
- void
- voidRight
- voidLeft
- mapFlipped
- flap
