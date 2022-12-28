# Global Typeclasses

## Type Class Instances: Global vs Local

To state that a given type (e.g. `Box`) can satisfy a type class' requirements, one writes a "**type class instance**". This instance actually defines how a given type (e.g. `Box`) implements that type class (e.g. `Functor`).

A language can implement type classes in two different ways:
- Global: one type can only have one instance for any given type class.
- Local: one type can have multiple instances for any given type class.

PureScript uses global type class instances whereas languages like Scala use local type class instances. So, what's the difference?

### Benefits of Global Instances

Let's say I use functions that require the underlying data type to satisfy the `Functor` type class' requirements. Sometimes, that underlying data type is `Array`. Sometimes, it's `Box`. Sometimes, it's `Maybe`.

Global instances mean that a given data type (e.g. `Box`) can only have one instance for a given type class (e.g. `Functor`). Thus, every time and everywhere that I use `Functor` in my code where the underlying type is `Box`, the same Box-Functor instance is always used. This makes it easy for the compiler to figure out which instance to use, and the programmer does not have to think deeply about which instance will be used.

Local instances mean that a given data type (e.g. `Box`) can have an infinite number of instances for a given type class (e.g. `Functor`). Thus, any time I use `Functor` in my code and the underlying type is `Box`, any one of its instances could be used. This makes it harder for the compiler to figure out which instance to use. Ultimately, the compiler chooses an appropriate instance based on which instance is "closest" in the given scope. However, the programmer has to think more deeply about how to properly configure/arrange their code, so that the instance they want the compiler to choose is actually chosen and used.

### Costs of Global Instances: Orphan Instances

Given this tradeoff, it may seem strange that global instances aren't used everywhere. If it's easier for the compiler and programmer, why use local instance?

The major pain point of global instances is "orphan instances."

For the below examples, let's say there is a type class, `MyTypeClass`, that is defined in `Data.MyTypeClass`. Let's say there is a data type, `Box`, that is defined in `Data.Box`. Let's say there is a third module, `Data.Orphan`, that has various other functions and values.

Due to how global instances work, an instance for a type class must be defined in one of two ways. There are two places where we could declare and implement the `Box`-`MyTypeClass` instance:
- either in `Data.MyTypeClass` module, which imports the `Box` module and its type
- or in the `Data.Box` module, which imports the `Data.MyTypeClass` module and its class.

If an instance is defined anywhere else (e.g. defined in `Data.Orphan`), it's called an "orphan instance." For example, Bob writes a library that exposes a type class (e.g. `MyTypeClass`). Sally, writes a data type that exposes a type (e.g. `Box`). The `Box`-`MyTypeClass` instance can be defined in either Bob's library or Sally's library. You are a third-party who wishes the `Box`-`MyTypeClass` instance was implemented differently than what either Bob or Sally implemented it as. However, since your module (e.g. `Data.Orphan`) is not one of those two modules, you cannot redefine the instance.

The only workaround to this situation is to define a newtype over `Box` that provides a different `Box`-`MyTypeClass` instance. While this seems simple to do, newtype wrapping and unwrapping can start to feel like "bloat" that gets in the way of other things.

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
| Global | <ul><li>Easier for the compiler to find an instance</li><li>To the programmer, it's obvious which instance will be used</li></ul> | Orphan Instances or writing boilerplatey `newtyp` code to get around them |
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
