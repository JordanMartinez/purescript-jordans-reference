# Writing the Evaluate Function

Since we'll be doing graph reductions later that will get somewhat complicated, we will rename `Placeholder` to `In` to make it easier to read. `In` is the same name used in the paper. This should make reading this "commentary" alongside of the paper easier.
```haskell
data Expression f = In (f (Expression f))

-- A full value
In ( Right ( Left ( Add (
  (In ( Left (Value 1)))
  (In ( Right ( Right ( Multiply
    (In (Left (Value 1)))
    (In (Left (Value 1)))
  ))))
))))
```

## The Types' Functor Instances

Due to how `Value`, `Add`, and `Multiply` are now defined, they are also `Functor`s. `Add` and `Multiply` implement `map` as one would expect:
```haskell
map :: (e -> z) -> Add e -> Add z
map f (Add e1 e2) = Add (f e1) (f e2)

map :: (e -> z) -> Multiply e -> Multiply z
map f (Multiply e1 e2) = Multiply (f e1) (f e2)
```
However, `Value` implements it differently in an important way. Since `Value`'s generic type, `e`, is never used in its value and since the `Value` constructor can only wrap an `Int` type, one cannot really "map" a `Value` (i.e. change the inner `Int` type) to anything else. Rather, they can only change `Value`'s `e` type:
```haskell
data Value e = ValueConstructor Int
map :: (e -> z) -> Value e            ->             Value z
map    _          (ValueConstructor x)             = ValueConstructor x
--               ((ValueConstructor x) :: Value e) ((ValueConstructor x) :: Value z)
-- We have to extract the `x` and rewrap it in a different
-- `Value z` type.
```
Thus, `Value` is a no-op `Functor`: using `map` on it just returns the same value.

An `Either` that wraps higher-kinded types implements `Functor` as we would expect:
```haskell
instance (Functor f, Functor g) => Functor (Either (f e) (g e)) where
  map func (Left f)  = Left  (map func f)
  map func (Right g) = Right (map func g)

instance (Functor f, Functor g) => Functor Coproduct f g e where
  map func (Coproduct either)  = Coproduct (map func either)
```

## A Simple Evaluation

We will soon see why it matters that these types are `Functor`s.

Let's write a function that can evaluate the simplest version of our nested data structure. We'll exclude `Add` and `Multiply` and only focus on `Value`. To simulate the `Left` value in `Either (Value e) (SomethingElse e)`, we'll use `BoxF`:
```haskell
data BoxF f a = BoxF (f a)

instance Functor f => Functor (Box f) where
  map function (BoxF f_of_a) = Box (map function f_of_a)

-- the `e` type in `Value e` can be anything.
valueExample :: forall e. Expression (BoxF (Value e))
valueExample = In (BoxF (Value 2))
```

What do we need to do to take `valueExample` and evaluate it to `2`? We need a way to remove the intermediary values: `In`, `BoxF`, and `Value`. There are two ways this could be done:
1. We implement 3 different functions that all unwrap the wrapper type.
2. We implement a type class that specifies an 'unwrap' function that each implements.

We'll take the second approach because it adheres to the idea of adding more types later on:
```haskell
class (Functor f) <= Evaluate f where
  evaluate :: forall a. f a -> Int

instance Evaluate Value where
  evaluate (Value x) = x

instance Evaluate f => Evaluate (BoxF f) where
  evaluate (Boxf f) = evaluate f

instance Evaluate f => Evaluate (Expression f) where
  evaluate (In f) = evaluate f

-- then we could write:
evaluate valueExample
```

## Including `Add` again

This solution works until we make our code more complicatd by composing `Add` with `Value` via `Either` again.
```haskell
addExample :: Expression (Coproduct Value Add e)
addExample =
  In (Right (Add            -- Coproduct's wrapper value
    (In (Left (Value 2)))   -- is excluded for simplicity
    (In (Left (Value 4)))   -- since it's just an `Either`
  ))
```
Returning to the `Eval` type class, how would we implement an instance for `Add`?
```haskell
class (Functor f) <= Evaluate f where
  evaluate :: forall a. f a -> Int

instance Evaluate Add where
  evaluate (Add x y) = -- ???
```
The difficulty above lies in one problem: what is `x` and `y` for `Add`? We might immediately presume that they are another `Expression`. However, the `e` in `Add e` could be anything. Moreover, the `Eval` type class does not force that `e` to be anything in particular. Here's the dilemma we run into now:
- If we use a type class constraint to make `a` be an `Evaluate`, so that we could implement `Add`'s Evaluate instance as `(eval x) + (eval y)`, then that will force `Value`'s `e` type to also satisfy that constraint. How then would we implement an instance for `Value`?
- If we don't constrain the `a` to be an `Evaluate`, we cannot evaluate `addExample`.

So, let's look at what we need to do to evaluate `Add`. We need to
- remove the `In` values at every other point: `In (f (In (f (In (Value)))))`
- remove the intermediary `Left`/`Right` values
- convert `Value x` to `x`
- convert `Add x y` to `x + y`

Starting with an easier problem, we could guarantee that all `In` values are removed by calling an unwrapping function, `removeIn`, followed by a `map` call:
```haskell
removeIn :: Expression f -> f
removeIn (In f) = map removeIn f
```
To see why this works, we'll run this function on `addExample`:
```haskell
-- Start!
removeIn (
  In (Right (Add
    (In (Left (Value 2)))
    (In (Left (Value 4)))
  ))
)
-- call `removeIn` by replacing LHS with RHS
map removeIn (Right (Add
  (In (Left (Value 2)))
  (In (Left (Value 4)))
))
-- call map on Right, which delegates function to Add
Right $ map removeIn (Add
  (In (Left (Value 2)))
  (In (Left (Value 4)))
)
-- call map on Add, which delegates function to both subexpressions
Right $ Add
  (removeIn (In (Left (Value 2))))
  (removeIn (In (Left (Value 4))))
-- call removeIn on both values
Right $ Add
  (map removeIn (Left (Value 2)))
  (map removeIn (Left (Value 4)))
-- call map on both Left values
Right $ Add
  (Left $ map removeIn (Value 2))
  (Left $ map removeIn (Value 4))
-- call map on both `Value` values, which does nothing...
Right $ Add
  (Left $ (Value 2))
  (Left $ (Value 4))
-- remove all of the "$"
Right (Add
  (Left (Value 2))
  (Left (Value 4))
)
```
This approach effectively removes all `In` values. However, we are still left with the same problem above: converting an `Add` expression into an `Int` value by defining an `Evaluate` instance.

However, the reduction of our graph shows something important. What is the type signature for the result of our reduction? We can see it below:
```haskell
result :: Coproduct Value Add e
result =
  Right (Add
    (Left (Value 2))
    (Left (Value 4))
  )
```
Looking at the `Evaluate` type class definition again, we can see that we don't force `a` (which corresponds to our `e` type in `result`) to be anything. However, what if we changed it to `Int`? If we do, it solves our dilemma above:
```haskell
class (Functor f) <= Evaluate f where
  evaluate :: f Int -> Int

instance Evaluate Value where
  evaluate (Value x) = x

instance Evaluate Add where
  evaluate :: Add Int -> Int
  evaluate (Add x y) = x + y

instance (Evaluate f, Evaluate g) => Evaluate (Either f g) where
  evaluate (Left f)  = evaluate f
  evaluate (Right g) = evaluate g
```
If we call `evaluate` on the result of our graph reduction above, what do we get?
```haskell
-- Start!
evaluate (Right (Add
  (Left (Value 2))
  (Left (Value 4))
))
-- replace LHS with RHS
evaluate (Add
  (Left (Value 2))
  (Left (Value 4))
)
-- Compiler error! Expected `Add Int` but got `Add (Either (Value e) (Add e))
```
The problem with this approach is that the nested `Value int` values were not evaluated before we evaluated the `Add`. If we could somehow change how our code works, we need something more like this:
```haskell
-- Start!
evaluate (Right (Add
  (evaluate (Left (Value 2)))
  (evaluate (Left (Value 4)))
))
-- Evaluate both Left values
evaluate (Right (Add
  (evaluate (Value 2))
  (evaluate (Value 4))
))
-- Evaluate both Value values
evaluate (Right (Add
  (2)
  (4)
))
-- Since Add is now of type `Add Int`,
-- evaluate the Right value
evaluate (Add
  (2)
  (4)
)
-- Now evaluate the `Add Int` value
2 + 4
-- Reduce
6
```
So, how do we use the `removeIn` approach to remove the `In` values and also evaluate `Value int` before evaluating `Add`, so that the types are correct by the time it happens? We make just a slight change to `removeIn`. It will now take an "unwrapping" function that gets applied to the result of our mapping. To make it adhere to the paper, we'll rename it to "fold" and explain that name later:
```haskell
fold :: Functor f => (f a -> a) -> Expression f -> a
fold function (In f) = function (map (fold function) f)
```
How should this function be understood? Rather than explain it using words, we'll demonstrate it using a graph reduction. Then, we'll explain the name:
```haskell
-- Start
fold evaluate addExample
-- replace addExample with its definition
fold evaluate (In (Right (Add
  (In (Left (Val 2)))
  (In (Left (Val 3)))
)))
-- replace fold's LHS with RHS
evaluate (map (fold evaluate) (Right (Add
  (In (Left (Val 2)))
  (In (Left (Val 3)))
)))
-- apply map to Right value by delegating it to Add value
evaluate (Right $ map (fold evaluate) (Add
  (In (Left (Val 2)))
  (In (Left (Val 3)))
))
-- apply map to Add value by delegating it to both expressions
evaluate (Right $ Add
  (fold evaluate (In (Left (Val 2))))
  (fold evaluate (In (Left (Val 3))))
)
-- apply fold to `In` value
evaluate (Right $ Add
  (evaluate (map (fold evaluate) (Left (Val 2))))
  (evaluate (map (fold evaluate) (Left (Val 3))))
)
-- apply map to Left value, which delegates to `Value` value
evaluate (Right $ Add
  (evaluate (Left $ map (fold evaluate) (Val 2)))
  (evaluate (Left $ map (fold evaluate) (Val 3)))
)
-- apply map to `Value` value (no-op!)
evaluate (Right $ Add
  (evaluate (Left $ (Val 2)))
  (evaluate (Left $ (Val 3)))
)
-- remove the "$"
evaluate (Right $ Add
  (evaluate (Left (Val 2)))
  (evaluate (Left (Val 3)))
)
-- evaluate the Left value
evaluate (Right $ Add
  (evaluate (Val 2))
  (evaluate (Val 3))
)
-- evaluate the Value value
evaluate (Right $ Add
  (2)
  (3)
)
-- put everything on one line again
evaluate (Right $ Add (2) (3))
-- remove the $ and extra parenthesis
evaluate (Right (Add 2 3))
-- evaluate the Right value
evaluate (Add 2 3)
-- evaluate the Add value
2 + 3
-- add them up
5
```

## Explaining Terms

There's a term we did not explain but which appears in the paper: `algebra`. An [`Algebra`](https://pursuit.purescript.org/packages/purescript-matryoshka/0.3.0/docs/Matryoshka.Algebra#t:Algebra) is merely a special name for a function with a specific type signature: `(f a -> a)`. It's our `evaluate` function.

## All Code So Far and Evaluate

**I have not checked whether this code works, but it will serve to give you an idea for how it works.**
```haskell
-- File 1
data Value e = Value Int
data Add e = Add e e

derive instance Functor Value
derive instance Functor Add

data Expression f = In (f (Expression f))

-- where `f` is a composed data type via Coproduct
value :: forall f. Int -> Expression f
value i = inj (Value i)

add :: forall f. Expression f -> Expression f -> Expression f
add x y = inj (Add x y)

class (Functor f) <= Evaluate f where
  evaluate :: f Int -> Int

instance Evaluate Value where
  evaluate (Value x) = x

instance Evaluate Add where
  evaluate (Add x y) = x + y

fold :: Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)

type VA e = Coproduct Value Add e
newtype VA_Expression = VA_Expression (Expression VA)

eval :: forall f. Expression f -> Int
eval expression = fold evaluate expression

-- call `eval` on this
file1Example :: VA_Expression
file1Example = add (value 5) (value 6)

-- File 2
data Multiply e = Multiply e e
derive instance Functor Multiply

multiply :: forall f. Expression f -> Expression f -> Expression f
multiply x y = inj $ Multiply x y

instance Evaluate Multiply where
  evaluate (Multiply x y) = x * y

type VAM e = Coproduct3 Value Add Multiply e
newtype VAM_Expression = VAM_Expression (Expression VAM)

-- call `eval` on this
file2Example :: VAM_Expression
file2Example = add (value 5) (multiply (add (value 2) (value 8)) (value 4))
```
