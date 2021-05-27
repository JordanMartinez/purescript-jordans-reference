# Functor: Mappable

## Usage

```
Change a value, `a`,
  that's currently stored in some box-like type, `f`,
into `b`
  using a function, `(a -> b)`.
```

## Definition

See its docs: [Functor](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Functor)

```haskell
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b

infixl 4 map as <$>

data Box a = Box a

instance Functor Box where
  map :: forall a b. (a -> b) -> Box a ->  Box  b
  map                 f         (Box a) =  Box (f a)
```

Put differently, `Functor` solves a specific problem. If I have a function of type `(a -> b)`, I cannot use that function on values of `a` if they are stored in a box-like type:
```haskell
function :: Int -> String
function 0 = "0"
function _ = "1"

function 5 -- This works!
function (Box 5) -- compiler error! Oh noes!
```
One could also see `map` as "transforming" a function, so that it also operates on Box-like types. This is often described as "lifting" a function into a Box-like type:
```haskell
map :: forall a b. (a -> b) -> (Box a -> Box b)
map f = (\(Box a) -> Box (f b))
```

## Laws

### Identity

Definition: `(\x -> x) <$> fa == fa`

```haskell
-- Start!
(\a -> a) <$> (Box 4)
-- De-infix "<$>" to map
map (\a -> a) (Box 4)
-- Replace map's "call signature" with its "body"
Box ((\a -> a) 4)
-- Apply argument by replacing '\a' with its argument '4'
Box ((\4 -> 4)  )
-- Keep only the body of function
Box ((      4)  )
-- Remove parenthesis and whitespace
Box 4
-- Check whether left-hand side (LHS) equals right-hand side (RHS)
(Box 4) == (Box 4)
-- Law met!
true
```

### Composition

(Remember, `g <<< f` means `(\a -> g (f a))`)

Definition: `map (g <<< f) = (map g) <<< (map f)`

```haskell
-- # Reduce left side of the law #

-- Start!
map ((\y -> y * 10) <<< (\x -> x + 1)) (Box 4)
-- Remember that `f <<< g` means `(\a -> f (g a))`
-- Reduce the "<<<" into one function
map (\x -> 10 * (x + 1)) (Box 4)
-- Replace map's "call signature" with its "body"
Box ((\x -> 10 * (x + 1)) 4)
-- Apply argument by replacing '\x' with its argument '4'
Box ((\4 -> 10 * (4 + 1))  )
-- Keep only the body of function
Box ((      10 * (4 + 1))  )
-- Reduce the body of function to its end result:
Box ((      10 * (5    ))  )
Box ((      10 *  5     )  )
Box ((      50          )  )
-- Remove parenthesis and whitespace
Box 50

-- # Reduce right side of the law #

-- Start!
(map (\y -> y * 10)) <<< (map (\x -> x + 1)) (Box 4)
-- Reduce "<<<" into one function
(\box4    -> map (\y -> y * 10) ( map (\x -> x + 1)  box4  ) ) (Box4)
-- Apply argument
(\(Box 4) -> map (\y -> y * 10) ( map (\x -> x + 1) (Box 4)) )
-- Keep only the body of function
(            map (\y -> y * 10) ( map (\x -> x + 1) (Box 4)) )
-- Replace 2nd map "call signature" with its "body"
(            map (\y -> y * 10) ( Box (\x -> x + 1) 4) )
-- Apply the argument
(            map (\y -> y * 10) ( Box (\4 -> 4 + 1)  ) )
-- Keep only the body of the function
(            map (\y -> y * 10) ( Box (      4 + 1)  ) )
-- Calculate the function
(            map (\y -> y * 10) ( Box (      5    )  ) )
-- Remove unneeded parenthesis
(            map (\y -> y * 10)   Box        5         )
-- Remove unneeded whitespace
(            map (\y -> y * 10) Box 5                  )
-- Replace map's "call signature" with its "body"
(                               Box ((\y -> y * 10) 5) )
-- Apply the argument
(                               Box ((\5 -> 5 * 10)  ) )
-- Keep only the function
(                               Box ((      5 * 10)  ) )
-- Calculate the function
(                               Box ((      50    )  ) )
-- Remove unneeded parenthesis
                                Box         50
-- Shift everything left
Box 50

-- Test if LHS equals RHS
(Box 50) == (Box 50)
-- Law met!
true
```

## Derived Functions

See the docs above for their definitions and read through the source code:
- Ignore the `a` value and just replace it with
    - the value towards which the arrow points...
        - (`voidLeft` / `$>`): `(Box 4) $> "a" == (Box "a")`
        - (`voidRight` / `<$`): `"a" <$ (Box 4) == (Box "a")`
    - `Unit` (`void`): `void (Box 4) == (Box unit)`
        - **Note:** `void` is used heavily to make it work with the `Discard` type class in `do` notation.
- Flip the order of map's arguments (`mapFlipped` / `<#>`)
- Generalize `flip`, so that it works for all types (`flap` / `<@>`)
