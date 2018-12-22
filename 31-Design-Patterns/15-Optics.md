# Optics

Once you have finished the Lenses book mentioned below, see [Oleg's Glassery post](http://oleg.fi/gists/posts/2017-04-18-glassery.html)

## Lenses

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

Lenses have already been explained quite clearly in a book that uses PureScript to do so via [Lenses for the Mere Mortal: Purescript Edition](https://leanpub.com/lenses). I've read it and recommend it.
