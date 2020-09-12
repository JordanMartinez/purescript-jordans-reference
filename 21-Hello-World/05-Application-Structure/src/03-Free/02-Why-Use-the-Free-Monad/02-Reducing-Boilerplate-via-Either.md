# Reducing Boilerplate

There are two problems with our current approach that we want to raise.

**First**, if we want to add another data constructor `Cherry`, we now need to nest that type even further using another type wrapper:
```haskell
-- original file. This cannot change once written!
data Fruit
  = Apple
  | Banana

showFruit :: Fruit -> String
showFruit Apple = "apple"
showFruit Banana = "banana"

-- File 2. This cannot change once written!
intFruit :: Fruit -> Int
intFruit Apple = 0
intFruit Banana = 1

data Fruit2
  = Orange

data FruitGrouper
  = Fruit_  Fruit
  | Fruit2_ Fruit2

showAllFruit :: FruitGrouper -> String
showAllFruit (Fruit_  appleOrBanana) = showFruit appleOrBanana
showAllFruit (Fruit2_ Orange) = "orange"

-- File 3.
data Fruit3 = Cherry

data FruitGrouper2
  = FruitGrouper_ FruitGrouper
  | Fruit3_       Fruit3

showMoreFruit :: FruitGrouper2 -> String
showMoreFruit (FruitGrouper_ a) = showAllFruit a
showMoreFruit (Fruit3_ Cherry)  = "cherry"
```

We see that we keep nesting types inside more type wrappers. If we were to abstract this away into a more general type, we basically have nested `Either`s:
```haskell
data Either a b
  = Left a
  | Right b

Either Fruit (Either Fruit2 Fruit3)
```
Anytime we want to add a new data constructor, we need to nest it in another `Either`:
`Either first (Either second (Either third (Either fourth ... (Either _ last))))`
If we were to visualize this data structure, it looks like this:
```
   Either                    Either
   /   \                     /   \
  /     \                   /     \
first  Either         Left first  Right
        /  \                      /  \
       /    \                    /    \
  second   Either       Left second   Right
            /  \                      /  \
           /    \                    /    \
      third    Either        Left third   Right
                /  \                      /  \
               /    \                    /    \
           fourth   last        Left fourth   Right last
```
Thus, to access `last`, we need to call `Right (Right (Right (Right last)))`

**Second**, using a value that is wrapped in a nested data structure leads to boilerplate.

Here's an example of putting a value of one of the nested types into the data structure. One needs to write a variant for each type position in our data structure:
```haskell
putInsideOf :: forall first second third fourth last
             . last
            -> Either first (Either second (Either third (Either fourth last)))
putInsideOf last = Right (Right (Right (Right last)))
```
If we want to extract a value of a type that is in our nested `Either` value, we need to return `Maybe TheType` because the value may be of a different type in the nested `Either` value. Using `Maybe` makes our code pure:
```haskell
extractFrom :: forall first second third fourth last
           . Either first (Either second (Either third (Either fourth last)))
          -> Maybe Result
extractFrom (Right (Right (Right (Right last)))) = Just last
extractFrom _ = Nothing
```
Once again, we need to write a variant of this function that works for every type position (e.g. `first`, `second`, and `third`) in our data structure.

In short, this boilerplate gets tedious. However, boilerplate usually implies a pattern we can use. Here's two ways we could make this easier:
1. Rather than using a nested `Either` type, why not define a type for this specific purpose?
2. Rather than using `extractFrom` and `putInsideOf` , why not define a type class with two functions for this specific purpose?

## Defining NestedEither

Looking at our example of a nested `Either` below, what is the common structure?
```haskell
Either first   (      Either second   (      Either third         last))
Left   first | Right (Left   second | Right (Left   third | Right last))
Left   first | Right (NestedEither second theRemainintTypes            )
```
So we come up with this idea, but it doesn't work...
```haskell
data NestedEither a b
  = Left a
  | Right (NestedEither b c)
```
...because we enter an infinte loop:
1. To define `c` in the `Right` value's `NestedEither b c` argument, we need the type declaraction, `data NestedEither a b` to include the third type, `c`. Thus, we go to step 2.
2. We update the type to `data NestedEither a b c`. However, now the `NestedEither b c` in `Right` value has only two types, not three. Thus, it no longer adheres to its own declaration (i.e. `NestedEither b c ?` vs `NestedEither a b c`). To add the type, we need it to be different than the others to enable the recursive idea of a nested `Either`, so we'll call it `d`. Thus, we return to step 1 except `c` is now `d` in that example.

Still, we can clean up the verbosity/readability of nested `Either`s by creating an infix notation for it:
```haskell
infixr 6 type Either as \/

Either Int String == Int \/ String

-- As an example, the first line below reduces to the last line below
first \/  second \/  third \/  fourth \/ last       -- first
first \/  second \/  third \/ (fourth \/ last)
first \/  second \/ (third \/ (fourth \/ last))
first \/ (second \/ (third \/ (fourth \/ last)))    -- last
```

## Defining InjectProject

When we have to write the same function again and again for different types in FP languages, we convert it into a type class (e.g. `Semigroup`, `Monoid`, `Functor`, etc.). Likewise, when we look at our code below...
```haskell
putInsideOf :: forall first second third fourth last
             . last
            -> Either first (Either second (Either third (Either fourth last)))
putInsideOf last = Right (Right (Right (Right last)))
```
... we want `putInsideOf` to mean "if I have a data structure with nested types, take one of those types values and put it into that data structure." In other words, we want to `inject` some value into a data structure:
```haskell
inject :: forall theType theNestedEitherType
        . theType
       -> theNestedEitherType
```
When we look at the other code we had...
```haskell
extractFrom :: forall first second third fourth last
             . Either first (Either second (Either third (Either fourth last)))
            -> Maybe last
extractFrom (Right (Right (Right (Right last)))) = Just (f last)
extractFrom _ _ = Nothing
```
... we want `extractFrom` to mean "If I have a data structure with nested types, I want to extract the value of a specific type out of that structure via `Just` or get `Nothing` if the value does not exist." In other words, we want to `project` some type's value from the data structure into the world:
```haskell
project :: forall nestedType theType
         . nestedType
        -> Maybe theType
```
Turning this idea into a type class, we get this:
```haskell
class InjectAndProject someType nestedType where
  inject :: someType -> nestedType
  project :: nestedType -> Maybe someType
```

## `Purescript-Either`

Indeed, the ideas we've proposed have already been defined by `purescript-either`:
- [`\/` as a type alias for `Either`](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Nested)
- The [Inject](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Inject) type class and its [implementation via "instance chains"](https://github.com/purescript/purescript-either/blob/v4.0.0/src/Data/Either/Inject.purs#L8-L10) that works for nested `Either` types.

The library provides convenience functions and types for nested `Either`s, **but only up to 10 total types**:
- Convenience functions for dealing with injection and projection
    - [injection - inX](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Nested#v:in1)
    - [projection - atX](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Nested#v:at1)
- Convenience functions for running code that handles every possible type in the nested Either:
    - [eitherX](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Nested#v:either1)
- Convenience types for writing them in a function's type signature without the `\/` syntax
    - [EitherX](https://pursuit.purescript.org/packages/purescript-either/4.0.0/docs/Data.Either.Nested#t:Either1)
