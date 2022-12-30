# Foldable

Note: as of `0.15.6`, a type class instance for `Foldable` can be derived by the compiler.

## Usage

Plain English names:
- Summarizeable
- Reducible
- FP version of the Iterator Pattern

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

```haskell
class (Functor f) => Foldable f where
  foldMap :: forall a m. Monoid m => (a -> m) -> f a -> m

  foldr :: forall a b. (a -> b -> b) -> b -> f a -> b
  foldl :: forall a b. (b -> a -> b) -> b -> f a -> b
```

### Visual Overview

For a cleaner visual, see [Drawing `foldl` and `foldr`](http://www.joachim-breitner.de/blog/753-Drawing_foldl_and_foldr)

#### `foldl`

This version creates a tree-like structure of computations that starts evaluating immediately via `function Binput A1` and continues evaluating towards the bottom-right. Since each step evaluates immediately, this version is "stack safe."

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

We'll implement instances for three types: `Box a`, `Maybe a`, and `List a`. Each implementation will become more complicated that the previous one.

#### `Box`'s Instance

```haskell
data Box a = Box a

-- Box's implementation doesn't show the difference between `foldl` and `foldr`.
-- Moreover, the initial `b` value isn't really necessary.
instance Foldable Box where
  foldl :: forall a b. (b -> a -> b) -> b -> Box a -> b
  foldl reduceToB initialB (Box a) = reduceToB initialB a

  foldr :: forall a b. (a -> b -> b) -> b -> Box a -> b
  foldr reduceToB initialB (Box a) = reduceToB a initialB

  foldMap :: forall a m. Monoid m => (a -> m) -> Box a -> m
  foldMap aToMonoid (Box a) = aToMonoid a
```

#### `Maybe`'s instance

```haskell
-- Maybe's implementation doesn't show the difference between `foldl` and `foldr`.
-- However, the initial `b` value is necessary
-- because of the possible `Nothing` case.
instance Foldable Maybe where
  foldl :: forall a b. (b -> a -> b) -> b -> Maybe a -> b
  foldl reduceToB initialB (Just a) = reduceToB initialB a
  foldl _         initialB Nothing  =           initialB

  foldr :: forall a b. (a -> b -> b) -> b -> Maybe a -> b
  foldr reduceToB initialB (Just a) = reduceToB a initialB
  foldr _         initialB Nothing  =             initialB

  -- While we could implement this the same way as `Box`, let's reuse
  -- `foldl` to implement it
  foldMap :: forall a m. Monoid m => (a -> m) -> Maybe a -> m
  foldMap aToMonoid maybe =
    foldl (\b a -> b <> (aToMonoid a)) mempty maybe
```

#### `List`'s instance

```haskell
-- Cons 1 (Cons 2 Nil)
-- 1 : (Cons 2 Nil)
-- 1 : 2 : Nil
-- same as [1, 2]
-- In the below implementations, `op` stands for `operation`
instance Foldable List where
  -- Same as...
  -- ((((intialB `op` firstElem) `op` secondElem) `op` ...) `op` lastElem)
  foldl :: forall a b. (b -> a -> b) -> b -> List a -> b
  foldl _         accumB   Nil           = accumB
  foldl op initialB (head : tail) =
    foldl op (op initialB head) tail

  -- Same as...
  -- (firstElem `op` (secondElem `op` (... `op` (lastElem `op` initialB))))
  foldr :: forall a b. (a -> b -> b) -> b -> List a -> b
  foldr op accumB   Nil           = accumB
  foldr op initialB (head : tail) =
    op head (foldl op initialB tail)

  -- Unlike Box, reusing `foldl`/`foldr` is actually the cleaner way
  -- to implement `foldMap` for `List`.
  foldMap :: forall a m. Monoid m => (a -> m) -> List a -> m
  foldMap aToMonoid list =
    foldl (\b a -> b <> (aToMonoid a)) mempty list

instance Functor List where
  map f list =
    -- Due to stack safety, this is not how this is implemented
    -- but it communicates the same idea
    foldr (\prevHead tail -> (f prevHead) : tail) Nil list
```

### General Usage Patterns

We'll see more of this in the upcoming overview of the derived functions. However, `foldl` and its corresponding members tend to follow a few patterns:

```haskell
reduceAllAsIntoOneAValue = foldl reduce initial foldableType
  where
    iniital = -- a type class value or hard-coded value
              -- like `mempty` or `true` or `Data.Ordering.LT`, etc.

    reduce = -- some type class function like `<>` or `&&` or `+`, etc.
             -- Note: sometimes this function will change the `a` to
             -- a different type before the function receives it as an argument

-- allows this type of computation: "a1 `operation` a2 `operation` a3"
thereIsNoInitialB_iterateThroughAllAValues =
  let record = foldl reduce initial foldableType
  in record.value

  where
    initial = { isFirstRun: true, value: initialValue }
    reduce b a =
      { isFirstRun: false, value:
          if b.isFirstRun then a else (realReduceFunction b.value a)
      }

buildHigherKindedData = foldl build initial foldableType
  where
    initial = Map.empty
    build mapSoFar nextValue =
      let
        key = show nextValue
        value = someComplicatedFunction nextValue
      in
        Map.add mapSoFar key value

forEachA_doSomeComputation = foldl compute initial foldableType
  where
    initial :: Effect Unit
    initial = pure unit

    compute :: a -> Effect Unit
    compute _ nextValue = do
      someValue <- computeUsing nextValue
      allIsGood <- doSomethingElse someValue
      pure unit
```

## Laws

None

## Derived Functions

We'll overview the derived functions by first grouping them into a few categories, and then providing a general definition for what each one does.

### Default implementations for the members of the `Foldable` type class

`foldMap` can be implemented using either `foldl` or `foldr`. Likewise, both `foldl` and `foldr` can be implemented using `foldMap`.

Thus, once one has implemented one of these sets, they can use a default implementation to implement the other set:
- if `foldl` and `foldr` both are implemented, you can implement `foldMap` by using one of the two function below:
    - [`foldMapDefaultL`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:foldMapDefaultL) which uses `foldl` under the hood
    - [`foldMapDefaultR`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:foldMapDefaultR) which uses `foldr` under the hood
- if `foldMap` is implemented, you can use the functions below to implement `foldl` and `foldr`:
    - [`foldlDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:foldlDefault)
    - [`foldrDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:foldrDefault)


### Use another type class to reduce multiple `a` values into one value.

- via `Semigroup`'s `append`/`<>` function:
    - [`fold`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:fold) == `a1 <> a2 <> ... <> aLast <> mempty`
    - [`intercalate`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:intercalate) == `a1 <> separator <> a2 <> separator <> a3 ...`
        - `fold` but with a separator value appended in-beteeen `a` values.
    - [`surround`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:surroundMap) == `value <> a1 <> value <> a2 <> value ...`
        - The inverse of intercalate
    - [`surroundMap`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:surround) == `value <> (aToMonoid a1) <> value <> (aToMonoid a2) <> value ...`
        - Same as `surround`, but the `a` can be changed to `b` before being appended to `value`.
- via `HeytingAlgebra`'s `conj`/`&amp;&amp;` or `disj`/`||` functions.
    - [`and`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:and) == `a1 && a2 && a3 && ...`
    - [`or`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:or) == `a1 || a2 || a3 || ...`
    - [`all`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:all) == `(aToB a1) && (aToB a2) && (aToB a3) && ...`
        - Same as `and`, but the `a` can be changed to `b` before being `&&`'d.
    - [`any`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:any) == `(aToB a1) || (aToB a2) || (aToB a3) || ...`
        - Same as `or`, but the `a` can be changed to `b` before being `||`'d.
- via `Semiring`s `plus`/`+` or `multiply`/`*` functions:
    - [`sum`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:sum) == `a1 + a2 + a3 + ...`
    - [`product`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:product) == `a1 * a2 * a3 * ...`
- via `Alt`'s `alt`/`<|>` and `Plus`'s `empty` functions (very similar to the `Semigroup` and `Monoid` relationship):
    - [`oneOf`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:oneOf) == [1, 2, 3] == `[1] <|> [2] <|> [3] <|> ...` == `foldl <|> empty [[1], [2], [3], ...]`
    - [`oneOfMap`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:oneOfMap)

### Determine information about the `Foldable` type based on the `a` values it contains / get an `a` value

Note: the below functions are not as performant as they could be because they will iterate through all of the `a` values in the `Foldable` type, even if the desired information is found as soon as possible when testing the first `a` value. In other words, these functions do not "short circuit".

- via `Eq`'s `eq`/`==` and `notEq`/`/=` functions:
    - [`elem`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:elem) == `(a1 == test) || (a2 == test) || (a3 == test) || ...`
    - [`notElem`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:notElem) == `(a1 /= test) && (a2 /= test) && (a3 /= test) && ...`
- Get the index of an `a` value within the `Foldable` type:
    - [`indexl`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:indexl)
    - [`indexr`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:indexr)
- Get first element which satisfies some predicate:
    - [`find`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:find)
    - [`findMap`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:findMap)
- via `Ord`'s `compare` function and its derivations (e.g. `<`, `>`, etc.):
    - [`minimum`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:minimum)
    - [`minimumBy`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:minimumBy)
    - [`maximum`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:maximum)
    - [`maximumBy`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:maximumBy)
- Calculate the length or emptiness of the type:
    - [`null`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:null)
    - [`length`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:length)

### Execute a "for loop" that runs an applicative/monadic computation (e.g. `Effect`) using each `a` in the `Foldable` type

In the Philosophical Foundations folder, we used a recursive function to implement a "for loop." I mentioned there that one could implement the same thing using a type class called `Foldable`. It is these last three functions that show how to do that.

In JavaScript, we might write something like this:
```javascript
var array = [1, 2, 3];
for (int i = 0; i < array.length; i++) {
  var elem = array[i];
  console.log(elem);
}
```

In PureScript, we would write the same thing via `Foldable`:
- *[`for_`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:for_) == `for_ array log`
- *[`traverse_`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:traverse_) == `traverse_ log array`
    - Same as `for_` but the function comes first
- *[`sequence_`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:sequence_) == `sequence_ [ log "1", log "2", log "3" ]`
    - Same as `for_` but the `a` values are applicative computations that have yet to be executed

* Note: that each of these computations must output only `Unit`. `Traversable`, which is covered next, removes that limitation.

A related function is `foldM`, which allows one to run a monadic computation multiple times where the next computation depends on the output of the previous computation. **As the docs indicate, this function is not generally stack-safe.**

[`foldM`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Foldable#v:foldM)

Here's an example:
```haskell
main :: Effect Unit
main = do
  int <- randomInt 1 10
  output <- foldM recursiveComputation 1 [1, 2, 3]
  log $ "Output was: " <> show output
  where
    recursiveComputation initialOrAccumulatedValue nextValueInArray = do
      anotherInt <- randomInt 1 nextValueInArray
      pure (anotherInt + initialOrAccumulatedValue)
```
... which is the same as writing...
```haskell
main :: Effect Unit
main = do
  int <- randomInt 1 10

  -- begin loop
    -- initialOrAccumulatedValue = 1; nextValueInArray = 1
  anotherInt1 <- randomInt 1 1
  accmulatedValue1 <- pure (anotherInt1 + 1)

    -- initialOrAccumulatedValue = 1; nextValueInArray = 2
  anotherInt2 <- randomInt 1 2
  accmulatedValue2 <- pure (anotherInt2 + accmulatedValue1)

    -- initialOrAccumulatedValue = 1; nextValueInArray = 1
  anotherInt3 <- randomInt 1 3
  output <- pure (anotherInt3 + accmulatedValue2)
  -- end loop

  log $ "Output was: " <> show output
```
