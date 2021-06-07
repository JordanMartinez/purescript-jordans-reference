module TLP.RowList.Simple where

import Prelude

import Data.Array as Array
import Data.List.Types (List(..))
import Prim.RowList as RL
import Data.Symbol (class IsSymbol, reflectSymbol)
import Type.Proxy (Proxy(..))

                                                                              {-
Let's say we want to produce a `Show` instance that
only shows the keys of a record. Since a `Show` instance
already exists for all Records, we'll need to define
a newtype and its `Show` instance to achieve this desired behavior.                  -}

newtype ShowKeysOnly :: Row Type -> Type
newtype ShowKeysOnly r = ShowKeysOnly (Record r)
                                                                              {-
Once implemented, our code should work like this in the REPL:
---
> show $ ShowKeysOnly { a: 4, b: 6, c: "apple", z: false }
["a", "b", "c", "z"]
---

How would we implement the `Show` instance for `ShowKeysOnly`?

We implement it by defining another type class called `ShowKeysInRecord`
that computes that information for all records, not just records wrapped
in the `ShowKeysOnly`. Since this type class must work for all records,
it cannot know anything about the record itself. This type class
(and any other like it) will always use `RowList` to accomplish its goal.

`RowList` is almost always used to implement anything that involves type
classes and operating on the keys/values of any record that we know nothing of.
A `RowList` functions like a type-level list but one that is specialized to
work with row kinds.

A `RowList` kind has two type-level values:
- Nil (the base case)
- Cons (the recursive case)

At its most basic idea, it allows you to do a `Data.Foldable.foldl`-like
computation on a record where the "next" element is the next key/field in
that record.

Let's remember what a fold-left looks like by using List.
---
data List a
  = Nil
  | Cons a (List a)
---

Read the below function as
  Given
    1. a function that takes the previous accumulated value and the next
        element in the list and produces the next accumulated value
    2. the initial accumulated value
    3. a list of elements
  Produce the final accumulated value                                           -}
foldLeft
  :: forall element accumulatedValue
   . (accumulatedValue -> element -> accumulatedValue)
  -> accumulatedValue
  -> List element
  -> accumulatedValue
foldLeft _ finalAccumulatedValue Nil =
  -- base case: we're done
  finalAccumulatedValue
foldLeft f initialOrNextAccumulatedValue (Cons nextElement restOfList) =
  -- recursive case: do one step and continue
  let
    nextAccumulatedValue = f initialOrNextAccumulatedValue nextElement
  in foldLeft f nextAccumulatedValue restOfList

{-
The first step we need to do is convert a row kind (i.e. the `r` in `{ | r }`
or `Record r`) into a list-like structure, `RowList`. This is done by using
the type class, `RL.RowToList`, a type-level function.

Once we have a `RowList`, we can simulate a fold-left at the type-level
by defining two instances, one for each value of `RowList`.
1. The first instance corresponds to the `Nil` case above: it ends
    the recursiong and returns the final version of the accumulated value.
    Most of the time, this instance is very very boring.
2. The second instance corresponds to the `Cons` case above: it computes
    the next computation and adds it to the accumulated value and then
    continues the recursion. Since this computes something using type-level
    information, there are numerous other type class constraints that
    enable such computations to occur at runtime.

Great. Let's now show an example.

We'll first define the `ShowKeysInRowList` type class. Since type classes
infer what their types are based on runtime values, we need to include a
`Proxy` runtime value in the type signature of `buildKeyList`. Otherwise,
the compiler will hav eno idea which `rowList` we're referring to.           -}
class ShowKeysInRowList :: RL.RowList Type -> Constraint
class ShowKeysInRowList rowList where
  buildKeyList :: Proxy rowList -> List String

-- As I said before, the base case is quite boring. It just ends the recursion.
instance ShowKeysInRowList RL.Nil where
  buildKeyList :: Proxy (RL.Nil) -> List String
  buildKeyList _ = Nil

{-
The recursive case is more interesting. First, write the initial instance
boilerplate:

instance ShowKeysInRowList (RL.Cons sym k rest) where
  buildKeyList :: Proxy (RL.Cons sym k rest) -> List String
  buildKeyList _ =

Second, let's implement this instance. Since the type-level
`RowList` is a `Cons`, our value-level `List` should also be a `Cons`

instance ShowKeysInRowList (RL.Cons sym k rest) where
  buildKeyList :: Proxy (RL.Cons sym k rest) -> List String
  buildKeyList _ = Cons key remainingKeys
    where
    key = ???
    remainingKeys = ???

Third, we'll compute what `key` should be. We know that a `Symbol`,
a type-level `String`, can be converted into a value-level `String`
via `reflectSymbol` as defined by the `IsSymbol` type class. So,
let's add the `IsSymbol` class as a constraint to expose `reflectSymbol`
and then use that function to produce our key:

instance (IsSymbol sym) => ShowKeysInRowList (RL.Cons sym k rest) where
  buildKeyList _ = Cons key remainingKeys
    where
      key = reflectSymbol (Proxy :: Proxy sym)
      remainingKeys = ???

Fourth, we need to compute what the remaining keys are. Wait, isn't that
what we're already doing? Let's use `buildKeyList` on the rest of the
rows. Since `buildKeyList` is defined by `ShowKeysInRowList`, we need
to add that constraint, so we can use that function:

instance (IsSymbol sym, ShowKeysInRowList rest)
  => ShowKeysInRowList (RL.Cons sym k rest) where
  buildKeyList _ = Cons key remainingKeys
    where
      key = reflectSymbol (Proxy :: Proxy sym)
      remainingKeys = buildKeyList (Proxy :: Proxy rest)

And that's it! We've now defined our type class instance. You'll notice
that the constraints get a bit long. So, the final version below
will use indentation to make it easier to read (at least in my opinion):      -}

instance (
  IsSymbol sym,
  ShowKeysInRowList rest
  )  => ShowKeysInRowList (RL.Cons sym k rest) where
  buildKeyList _ = Cons key remainingKeys
    where
      key = reflectSymbol (Proxy :: Proxy sym)
      remainingKeys = buildKeyList (Proxy :: Proxy rest)

-- Let's show all three parts together now for easier readability.
-- We'll add a `2` so that the code still compiles:
class ShowKeysInRowList2 :: RL.RowList Type -> Constraint
class ShowKeysInRowList2 rowList where
  buildKeyList2 :: Proxy rowList -> List String

instance ShowKeysInRowList2 RL.Nil where
  buildKeyList2 :: Proxy (RL.Nil) -> List String
  buildKeyList2 _ = Nil

instance (
  IsSymbol sym,
  ShowKeysInRowList2 rest
  )  => ShowKeysInRowList2 (RL.Cons sym k rest) where
  buildKeyList2 _ = Cons key remainingKeys
    where
      key = reflectSymbol (Proxy :: Proxy sym)
      remainingKeys = buildKeyList2 (Proxy :: Proxy rest)

{-
To actually implement our `Show` instance, we'll add the constraints
needed to compute these values
-}
instance (
  -- 1. First convert the `recordRows` to a `RowList`
  RL.RowToList recordRows rowList,
  -- 2. Then bring `buildKeyList2` into scope
  ShowKeysInRowList2 rowList
  ) => Show (ShowKeysOnly recordRows) where
  show (ShowKeysOnly rec) =
    -- 4. And convert the `List` into an `Array` and reuse the
    --    Array's `show` to produce our desired result.
    show $ Array.fromFoldable keyList
    where
    -- 3. Then build the key list
    keyList = buildKeyList2 (Proxy :: Proxy rowList)
                                                                              {-
Below are a few examples to prove that this works.
Run the following in the REPL to confirm it for yourself:
---
spago repl
example1
example2
---
                                                                              -}
example1 :: ShowKeysOnly ( a :: String, b :: Int, c :: Boolean )
example1 = ShowKeysOnly { a: "", b: 0, c: false }

example2 :: ShowKeysOnly ( rowlists :: String, are :: Int, cool :: Boolean )
example2 = ShowKeysOnly { rowlists: "", are: 0, cool: false }

{-
Did you notice how the output of `example2` is unexpected?
It prints
  ["are","cool","rowlists"]
rather than
  ["rowlists","are","cool"]

It seems like `RowToList` will sort the rows labels before returning them
as a new list.
-}
