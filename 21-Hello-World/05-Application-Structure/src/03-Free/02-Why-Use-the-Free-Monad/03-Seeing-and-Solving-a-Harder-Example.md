# Seeing and Solving a Harder Example

## Failing to Solve a Harder Version

Let's try using our `Either`-based solution to solve a harder problem. We'll solve the same problem the paper to which we referred beforehand solved.

They want to define a program that can evaluate an expression that consists of adding and multiplying integers. However, they want to define this program in such a way that it also solves the Expression Problem.

To start, we'll define the `Value` type that wraps an `Int` and the `Addition` type in the "file 1". An `Addition` should work in all of these cases:
1. Adds two ints
2. Adds an int and another add expression
3. Adds two add expressions.

To achieve this result, we'll define our type like so:
```haskell
data Expression
  = Value Int
  | Add Expression Expression

evaluate :: Expression -> Int
evaluate (Value i) = i
evaluate (Add x y) = (evaluate x) + (evaluate y)

show2 :: Expression -> String
show2 (Value i) = show i
show2 (Add x y) = "(" <> show x <> " + " <> show y <> ")"
```
Now, if we want to add `Multiply` in "file 2" without changing or recompiling "file 1", how does that fare? If we define our data type for `Multiply` like this...
```haskell
data Multiply = Multiply Expression Expression
```
... then `Multiply` will work similarly to `Add`:
1. Multiplies 2 Int values
2. Multiply an int value and an add expression
3. Multiply two add expressions

The problem with our above definition is that it does not account for two other cases that should work:
1. Multiply two multiply expressions
2. Add two multiply expresions

## Exploring Our Options

Let's model these types differently by separating them all into their own types that we can later compose. We won't include `Multiply` yet:
```haskell
data Value = Value Int
data Add = Add Expression Expression

type Expression = Value \/ Add

value :: Int -> Expression
value i = inj (Value i)

add :: Expression -> Expression -> Expression
add x y = inj (Add x y)

show2 :: Expression -> String
show2 (Left (Value i)) = show i
show2 (Right (Add x y)) = "(" <> show2 x <> " + " <> show2 y <> ")"

evaluate :: Expression -> Int
evaluate (Left (Value i)) = i
evaluate (Right (Add x y)) = (evaluate x) + (evaluate y)
```
To achieve the capability to add and multiply `Multiply` expressions, what would we need to do, even if it means breaking the constraints of the Expression Problem?
```haskell
-- File 1
data Value = Value Int
data Add = Add Expression Expression

-- File 2
data Multiply = Multiply Expression Expression

-- The problem: this is the final type we need
type Expression = Value \/ Add \/ Multiply
```
There are two places where we could define `Expression`, each with its own problems:
- If we define it in File 1, then its definition cannot include the `Multiply` field because File 1 doesn't know about that type.
- If we define it in File 2, then File 1 will not compile because the compiler does not know what the type, `Expression`, is.

Hmm... The Expression Problem is more nuanced than first thought. Still, the above refactoring helps shed light on what needs to be done. Let's look back at `Add`:
```haskell
data Add = Add Expression Expression
```
`Add` must add 2 Expressions. However, we've hard-coded what `Expression` means. Since the location declaration of `Expression` causes a problem, we must turn this hard-coded type into a generic type to enable us to define it at a later time. The same goes for `Multiply`:
```haskell
data Add expression = Add expression expression
-- or a less verbose version
data Multiply e = Multiply e e
```
We also know from our previous simpler problem that we will need to eventually compose our data types together into a big `Expression` type. In other words, we should get something like this:
```haskell
--        L             RL  RR
-- Either Value (Either Add Multiply)

              Right ( Left ( Add (
                (Left (Value 1))
                (Right ( Right ( Multiply
                  (Left (Value 1))
                  (Left (Value 1))
                ))
              ))
```
To summarize, we need to
- define the `expression` type in `Add`/`Multiply` generically so we can define it at a later time as a way (avoids the location problem)
- define an `Expression` type that composes data types together but somehow prevents them from knowing about one another. We need something like a "[buffer zone](https://www.wikiwand.com/en/Buffer_zone)" but for our types.

## Solving the Problem

We'll show you how the paper solved this, starting with the type's value and then showing the actual type declaration/definition:
```haskell
-- Value of our Expression type with Placeholder commented out
{- Placeholder ( -} Right ( Left ( Add (
  {- (Placeholder -} ( Left  (Value 1))   -- )
  {- (Placeholder -} ( Right ( Right ( Multiply
              {- (Placeholder -} (Left (Value 1))  -- )
              {- (Placeholder -} (Left (Value 1))  -- )
                      )))  -- )
                    )))  -- )

-- A full value
Placeholder ( Right ( Left ( Add (
  (Placeholder ( Left (Value 1)))
  (Placeholder ( Right ( Right ( Multiply
    (Placeholder (Left (Value 1)))
    (Placeholder (Left (Value 1)))
  ))))
))))

-- Define a special "placeholder" type that hides the next
-- `expression` type from the actual data type
-- `f` is a higher-kinded type
data Expression f = Placeholder (f (Expression f))

-- Make the types all higher-kinded by one
data Add e = Add e e
data Multiply e = Multiply e e
-- `e` not used here
-- but needed to make the next type work
data Value e = Value Int

{-
The following is pseudo-code. I don't konw whether it compiles.

Use Either to compose these higher-kinded types:
             Either (Value e) (Either (Add e)    (Multiply e))
type AMV e =        (Value e) \/      (Add e) \/ (Multiply e)
newtype AMV_Expression = AMV_Expression (Expression AMV)
```

## Revealing Coproduct

Above, we wrote this:
```haskell
Either (Value e) (Either (Add e)    (Multiply e))
       (Value e) \/      (Add e) \/ (Multiply e)
```
However, this is just a more verbose form of [`Coproduct`](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct#t:Coproduct):
```haskell
newtype Coproduct f g a = Coproduct (Either (f a) (g a))
```
Indeed, just as there was a library for nested `Either`s via `purescript-either`, there is also a library for nested `Coproduct`s: [`purescript-functors`](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct#t:Coproduct), which also includes [convenience functions and types for dealing with nested versions of `Coproduct`](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct.Nested) as well as [inject values into and project values out of it](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct.Inject).

To help us understand how to read and write `Coproduct`, let's compare the `Coproduct` version to its equivalent `Either` version:
```haskell
-- not nested
Either   (Value e) (Add e)
Coproduct Value     Add e

-- nested
         (Value e) \/        (Add e) \/ (Multiply  e)
Either   (Value e) (Either   (Add e)    (Multiply  e))
Coproduct Value    (Coproduct Add        Multiply) e

-- nested using convenience types from both libraries
Either3   (Value e) (Add e) (Multiply e)
Coproduct3 Value     Add     Multiply e
```
