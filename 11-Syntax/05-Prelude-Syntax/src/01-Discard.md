# Discard

There is a type class in Prelude called [`Discard`](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Bind#t:Discard) that does not appear in our diagram of Prelude's type classes. It is implemented only by `Unit`. One could implement it for another type, but that's probably not desirable:
```purescript
-- Pseudo-Syntax: combines the class and its only instance into one block:
class Discard Unit where
  discard :: forall f b. Bind f => f Unit -> (Unit -> f b) -> f b
  discard = bind
```

This may seem like a pointless type class, but it becomes important when we talk about do notation (next).
