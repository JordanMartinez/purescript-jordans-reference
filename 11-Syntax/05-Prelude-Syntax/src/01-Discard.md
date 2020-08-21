# Discard

There is a type class in Prelude called [`Discard`](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Control.Bind#t:Discard) that does not appear in our diagram of Prelude's type classes. It is implemented only by `Unit`.:
```purescript
-- Pseudo-Syntax: combines the class and its only instance into one block:
class Discard Unit where
  discard :: forall f b. Bind f => f Unit -> (Unit -> f b) -> f b
  discard = bind
```

This seemingly pointless type class insures that you do not accidentally "throw away" the result of a computation when you did not intend to do so (covered next in 'do notation'). One should almost never implement it for another type, unless one knows what they are doing and they have a very rare use case for it.
