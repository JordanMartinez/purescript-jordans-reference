# What Are "Free" `SomeTypeClass` Types

When we first introduced type classes, we explained that they are an encapsulation of 2-3 things:
1. (always) A definition of 1 or more functions/values' type signatures
2. (almost always) Laws to which a concrete type's implementation of said type class must adhere
3. (frequently) Functions that a type obtains for free once the core defintion/values are implemented

Moreover, some type classes combine two or more type classes together

Thus, `SomeTypeClass` isn't so much a 'thing' as much as it is an expectation. We don't say that `f` **is** a `SomeTypeClass` (for it could implement it in various ways); rather, we are really saying that `f` **has** an instance that implements `SomeTypeClass`'s `specialFunction` function in such a way that it adheres to `SomeTypeClass`'s laws. As we saw from the MTL folder, even `StateT`, a newtyped function, can be called a `Functor` because it meets all of these requirements.

However, whenever we had a type that we wanted to use in a `Functor`-like way, we needed to define its `Functor` instance before we could use it in that way. In other words, we have to write a lot of boilerplate code.

What if we could grant `Functor`-like capabailities for any type without implementing such an instance? That is the idea behind "free" type classes.

Essentially, a "free" `TypeClassName` is a box-like type, `Wrapper`, that grants `TypeClassName`-capabilities to some other type, `A`, by providing the necessary structure for implementing a law-abiding `TypeClassName` instance for `Wrapper`.

In short, to create a "free" `SomeTypeClass`, we do 2 things:
1. Translate the type class into a higher-kinded type
2. Do the following for each of the type class' functions, starting with the easiest function:
    - Translate one type class' function into a constructor for the new type
    - Try to implement all required instances using the constructor
    - Fix problems that arise

## A "Free" Monoid

When we look at `Monoid`, we see this type class:
```haskell
class Monoid a where                                                    {-
  append :: a -> a -> a       -- include Semigroup's function           -}
  mempty :: a

-- "hello" <> "world" == "helloworld"
-- "hello" <> mempty  == "hello"
-- mempty  <> "hello" == "hello"
```
Let's follow the instructions from above: First, we'll translate the type class into a data type that can take any type:
```haskell
data FreeMonoid a
```
Second and starting with the easier function `mempty`, we'll translate it into a constructor for `FreeMonoid`. `mempty` is easy, since it translates into a placeholder constructor:
```haskell
data FreeMonoid a
  = Mempty

instance Semigroup (FreeMonoid a) where
  append a Mempty = a
  append Mempty a = a

instance Monoid (FreeMonoid a) where
  mempty = Mempty
```
`append` is a bit harder. We need to store a value of type `a`, so we can try this:
```haskell
data FreeMonoid a
  = Mempty
  | Append a
```
However, if we try to implement this as `(Append a1) <> (Append a2)`, we can't combine `a1` and `a2`. Rather, we need to store both an `a1` and an `a2` in a single `Append`:
```haskell
data FreeMonoid a
  = Mempty
  --       a1 a2
  | Append a  a

-- since `Mempty` is our placeholder instance, we can use it
-- to fill the a2's spot

instance Semigroup (FreeMonoid a) where
  append Mempty Mempty = Mempty
  append a Mempty = a
  append Mempty a = a
  append (Append a1 Mempty) (Append a2 Mempty) = Append a1 a2

-- Works!
(Append a1 Mempty) <> (Append a2 Mempty) == Append a1 a2
-- ...well, not quite!
(Append a1 a2) <> (Append a3 Mempty) == -- ???
```
Our previous solution doesn't work either. If the failure case above is just another append, we get something like this:
`((Append a1 Mempty) <> (Append a2 Mempty)) <> (Append a3 Mempty)`
Rather than defining a second `a` for `Append`, what if we nested the types together? This approach makes our code finally work:
```haskell
data FreeMonoid a
  = Mempty
  --       a1  Mempty / Append a
  | Append a  (FreeMonoid a     )

instance Semigroup (FreeMonoid a) where
  append Mempty Mempty = Mempty
  append a Mempty = a
  append Mempty a = a
  append (Append a memptyOrAppend) otherAppend =
    Append a (memptyOrAppend <> otherAppend)

instance Monoid (FreeMonoid a) where
  mempty = Mempty
```
The above code is the exact same thing as a familiar data type, `List`:
```haskell
data List a
  = Nil
  | Cons a (List a)

instance Semigroup (List a) where
  append Nil Nil = Nil
  append a Nil = a
  append Nil a = a
  append (Cons head tail) otherList =
    Cons head (tail <> otherList)

instance Monoid (List a) where
  mempty = Nil
```
Thus, we say that `List` is a "free" monoid because by wrapping some type (e.g. `Fruit`) into a `List`, we get a monoid instance for `Fruit` for free:
```haskell
data Fruit
  = Apple
  | Orange
  | Banana

(Cons (Apple Nil)) <> (Cons Banana Nil) == Cons (Apple (Cons Banana Nil))
```
This idea can be useful for when we have types that can't implement specific type classes.
