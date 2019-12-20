# Foldable

## Usage

Plain English names:
- Summarizeable
- Reducible

```
  Given
    a box-like type, `f`,
      that stores zero or more `a` values
        and
    an initial value of type, `b`
        and
    a `Semigroup`/`Monoid`-like function
      that produces a `b` value if given an `a` and a `b` argument,
        of which there are two versions
        (
          either `a -> b -> b`
          or     `b -> a -> b`
        ),
return a single value of type, `b` by
  (first application) passing the initial `b` and initial `a` values into the function,
    which produces the next `b` value,
  (recursive application) passing the previously-computed `b` value with the next `a` value into the function
    which produces the next `b` value,
    which will eventually be the final `b` value returned
      when there are no more `a` values
        in the box-like `f` type.
```

It enables:
- a way to reduce a `List` of `String`s into one `String` (the combination of all the `String`s)
- a way to reduce a `List` of `Int`s into one `Int` (the sum/product of all the ints)
- a way to take a `List Int` and create a `Map String Int` (each value is an `Int` from the list and its key is the output of `show int`)
- a way to take a `List Int` and double each `Int` in the list (i.e. write `List`'s `Functor` instance by implementing `map` via this type class).

## Definition

### Code Definition

Don't look at its docs until after looking at the visual overview in the next section: [Foldable](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Foldable#t:Foldable)

```purescript
class (Functor f) => Foldable f where
  foldMap :: forall a m. Monoid m => (a -> m) -> f a -> m

  foldr :: forall a b. (a -> b -> b) -> b -> f a -> b
  foldl :: forall a b. (b -> a -> b) -> b -> f a -> b
```

### Visual Overview

For a cleaner visual, see [Drawing `foldl` and `foldr`](http://www.joachim-breitner.de/blog/753-Drawing_foldl_and_foldr)

#### `foldl`

This version creates a tree-like structure of computations that starts evaluating immediately via `function Binput A1` and continues evaluating towards the bottom-right. Since each evaluation requires only 1 step, this version is "stack safe."

```
(b -> a -> b)  Binit   //=== `f a` ===\\
|               |      ||             ||
|               |      || A1  A2  A3  ||
|               |      \\=+===+===+===//
|               |         |   |   |
\               \         /   |   |
 \=========>     ---------    |   |
  |                 B2        |   |
  |                 |         |   |
  \                 \         /   |
   \==========>      ---------    |
    |                   B3        |
    |                   |         |
    \                   \         /
     \==========>        ---------
                             Boutput
```

#### `foldr`

This version creates a tree-like structure of computations that doesn't start evaluating until it gets to the bottom right of the tree. Once it reaches the bottom right, it evaluates `function A3 Binput` and then evaluates towards the top-left of the tree
Since each step towards the bottom-right of the tree allocates a stack, this function is not always "stack safe".

```
      Boutput
    -----     <==========\
   /      \               \
   |      |               |
   |      |               |
   |      B3              |
   |    ------    <=======\
   |   /       \           \
   |   |       |           |
   |   |       B2          |
   |   |    -------   <====\
   |   |   /        \       \
   |   |   |        |       |
//=+===+===+===\\   |       |
|| A1  A2  A3  ||   |       |
||             ||   |       |
\\=== `f a` ===//   Binit   (a -> b -> b)
```

### Examples

```purescript
data Box a = Box a

-- Box doesn't really show the difference between foldl and foldr
-- but List will
instance f :: Foldable Box where
  -- same as `initialB <> a`
  foldl :: forall a b. (b -> a -> b) -> b -> Box a -> b
  foldl reduceToB initialB (Box a) = reduceToB initialB a

  -- same as `a <> initialB`
  foldr :: forall a b. (a -> b -> b) -> b -> Box a -> b
  foldr reduceToB initialB (Box a) = reduceToB a initialB

  foldMap :: forall a m. Monoid m => (a -> m) -> Box a -> m
  foldMap putIntoMonoid (Box a) = putIntoMonoid a

-- Cons 1 (Cons 2 Nil)
-- 1 : (Cons 2 Nil)
-- 1 : 2 : Nil
-- same as [1, 2]
instance l :: Foldable List where

  -- Same as...
  -- intialB <> firstElem <> secondElem <> thirdElem <> ... <> lastElem
  foldl :: forall a b. (b -> a -> b) -> b -> List a -> b
  foldl _         accumB   Nil           = accumB
  foldl reduceToB initialB (head : tail) =
    foldl reduceToB (reduceToB initialB head) tail

  -- Same as...
  -- firstElem <> secondElem <> thirdElem <> ... <> lastElem <> initialB
  foldr :: forall a b. (a -> b -> b) -> b -> List a -> b
  foldr reduceToB accumB   Nil           = accumB
  foldr reduceToB initialB (head : tail) =
    reduceToB (head (foldl reduceToB initialB tail))

  foldMap :: forall a m. Monoid m => (a -> m) -> List a -> m
  foldMap putIntoMonoid list = foldl putIntoMonoid mempty list

instance fL :: Functor List where
  map f list = foldr (\a b -> (f a) : b) Nil list
```

## Laws

None

## Derived Functions

[A lot!](https://pursuit.purescript.org/packages/purescript-foldable-traversable/4.0.1/docs/Data.Foldable#v:fold) So we won't be covering them all here. Still, some of my favorite are:
- `intercalate "\n" listOfStrings` - inserts a newline character between each element in the list of `String`s.
- `fold listOfStrings` - combines all the elements in a list of `String`s into one `String`.
