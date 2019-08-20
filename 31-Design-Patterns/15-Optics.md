# Optics

To understand what problem optics solve and why they are an essential tool in the FP toolbox, read Thomas Honeyman's [Practical Profunctor Lenses & Optics in PureScript](https://thomashoneyman.com/articles/practical-profunctor-lenses-optics/).

Lenses have already been explained quite clearly in a book that uses PureScript to do so via [Lenses for the Mere Mortal: Purescript Edition](https://leanpub.com/lenses). I've read it and recommend it.

Once you have finished the Lenses book mentioned below, see [Oleg's Glassery post](http://oleg.fi/gists/posts/2017-04-18-glassery.html)

Lenses are also explained in the [Racket Programming Languages's Lenses Guide](https://docs.racket-lang.org/lens/index.html). I'm not sure how helpful it is or what it further explains besides the above book, but I'm still including it here.

## Lenses

**Note: due to Thomas' above blog post, the below section will be removed in the next major release.**

Since FP data types cannot be subclassed like OO data types, one will often define a shared component and then define its 'subclasses' as having that shared component:
```purescript
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
```purescript
-- for example...
user.config.personal.privacy.email { isPublic = false }
```

This leads to a lot of boilerplate but the concept is easily abstracted into Lenses.
