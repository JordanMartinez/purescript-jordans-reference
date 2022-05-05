# Incorporating "Free" Structures

Given the list of [Free data structures](../27-Free-Data-Structures.md), we can sometimes incorporate one of them into an existing data structure.

For example, given some ADT for one's particular usage where some parts could be monoidic but other parts aren't..
```purs
data Foo a b
  = Bar a Foo b
  | Baz Foo a a

appendIsh :: forall a b. Foo a b -> Foo a b -> Foo a b
appendIsh = case _, _ of
  Baz foo a1 a2, Baz foo2 a3 a4 ->
    Baz (foo1 <> foo2) (a1 <> a3) (a2 <> a4)
  _, _ -> -- uh......
```
a `Monoid` instance can still be created if one incorporates an encoding of the Free Monoid (e.g. `List`) into the data structure itself:
```purs
data Foo a b
  = Bar a Foo b
  | Baz Foo a a
  | Append (Foo a b) (Foo a b) -- Tree-like `Cons`
  | Empty -- `Nil`

instance Semigroup (Foo a b) where
  append = case _, _ of
    Baz foo a1 a2, Baz foo2 a3 a4 ->
      Baz (foo1 <> foo2) (a1 <> a3) (a2 <> a4)
    l, r -> Append l r

instance Monoid (Foo a b) where
  mempty = Empty
```

This idea works for `Semigroup` and `Monoid`. Incorporating other such parts from Free data structures into custom ADTs may also apply. I'm not sure whether this pattern has a name, nor what to call it if it doesn't have one.