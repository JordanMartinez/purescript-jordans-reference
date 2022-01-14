# Optics

To understand what problem optics solve and why they are an essential tool in the FP toolbox, read Thomas Honeyman's [Practical Profunctor Lenses & Optics in PureScript](https://thomashoneyman.com/articles/practical-profunctor-lenses-optics/).

To learn how to use lenses...
- with an explanation behind how it works, read [Optics by Example](https://leanpub.com/optics-by-example/). Although the language used is Haskell, much of it will transfer over. I'd recommend this book over the below one, which came out earlier.
- without much explanation behind how it works, read [Lenses for the Mere Mortal: Purescript Edition](https://leanpub.com/lenses).

Below are other resources that are more reference material than clear explanations to beginners:
- [Oleg's Glassery post](http://oleg.fi/gists/posts/2017-04-18-glassery.html)
- The [Racket Programming Languages's Lenses Guide](https://docs.racket-lang.org/lens/index.html).
- [Profunctor Optics, a Categorical Update (Extended Abstract)](https://cs.ttu.ee/events/nwpt2019/abstracts/paper14.pdf)

If you're looking to generate optics for your types, consider [`purescript-tidy-codgen-lens`](https://github.com/jordanmartinez/purescript-tidy-codegen-lens).

## Lenses

**Note: due to Thomas' above blog post, the below section will be removed in the next major release.**

Since FP data types cannot be subclassed like OO data types, one will often define a shared component and then define its 'subclasses' as having that shared component:
```haskell
type Shape = { fill :: Color }
type Square = { width :: Number
              , height :: Number
              , shape :: Shape
              }
type Circle = { radius :: Number
              , shape :: Shape
              }
```

As a result, when we wish to update the `shape` part of a Square or Circle, we need to deal with all that nesting:
```haskell
-- for example...
user.config.personal.privacy.email { isPublic = false }
```

This leads to a lot of boilerplate but the concept is easily abstracted into Lenses.
