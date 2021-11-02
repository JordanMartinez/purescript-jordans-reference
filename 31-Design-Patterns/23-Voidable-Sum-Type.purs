module DesignPatterns.VoidableSumType where

                                                                                                {-
A pattern I have seen used in PureScript's `CST` parser and  in `Dhall` is something
that I will refer to as the "Voidable Sum Type" design pattern.

Let's say you have a type that has 3 data constructors                                          -}

data AnExampleSumType_Base
  = DataConstructor_Base1
  | DataConstructor_Base2
  | DataConstructor_Base3

                                                                                                {-
Let's say in one situation, you need all three data constructors. Let's say in another
situation, you only need the first and second data constructors. Due to the second
situation, most will just define two types. For example                                         -}

data AnExampleSumType_OneTwoThree
  = DataConstructor1a
  | DataConstructor2a
  | DataConstructor3a

data AnExampleSumType_OneTwo
  = DataConstructor1b
  | DataConstructor2b

                                                                                                {-
While defining a second sum type (i.e. `AnExampleSumType_OneTwo`) works, it's not ideal
when the third data constructor should be usable in one situation and uninhabitable in another.

There's an alternative way to achieve the same thing but without defining two different types:
                                                                                                -}

-- First, you define a sum type that has a type parameter on one of the data constructors:
data AnExampleSumType3 param
  = DataConstructor1
  | DataConstructor2
  | DataConstructor3 param

-- To implement `AnExampleSumType_OneTwo`, you set the `param` to `Void`, making it impossible for the `DataConstructor3`
-- data constructor to ever exist (assuming one doesn't "unsafeCoerce" something) because one can never provide a
-- value of type `Void`.
type AnExampleSumType_OneTwo' = AnExampleSumType3 Void

-- Likewise, to implement `AnExampleSumType_OneTwoThree`, you set the `param` to `Unit`.
-- While it was impossible with `Void` before to construct the third data constructor, that's no longer the case with `Unit`:
type AnExampleSumType_OneTwoThree' = AnExampleSumType3 Unit

-- For a few ideas for how this could be uesful, consider `Either3`.
-- See https://pursuit.purescript.org/packages/purescript-either/5.0.0/docs/Data.Either.Nested#t:Either3
type Either3 a b c = Either a (Either b (Either c Unit))

-- The downside to the approach above is that the `c` case is nested in two `Left` constructors, leading
-- to some unnecessary traversals. One could define this same type without such traversals
-- by defining it using the "Voidable Sum Type" pattern:
data Either10 a b c d e h i j k l
  = Either1 a
  | Either2 b
  | Either3 c
  | Either4 d
  | Either5 e
  | Either6 h
  | Either7 i
  | Either8 j
  | Either9 k
  | Either10 l

type Either3 a b c = Either10 a b c Void Void Void Void Void Void Void

either3 :: forall a b c r. (a -> r) -> (b -> r) -> (c -> r) -> Either3 a b c -> c
either3 do1 do2 do3 = case _ of
  Either1 a -> do1 a
  Either2 b -> do2 b
  Either3 c -> do3 c
  Either4 d -> absurd d
  Either5 e -> absurd e
  Either6 h -> absurd h
  Either7 i -> absurd i
  Either8 j -> absurd j
  Either9 k -> absurd k
  Either10 l -> absurd l

                                                                                                                          {-
Using `Either10` above as an example, you can likely see the tradeoffs with defining such a type.

For real life examples, consider these usage:
- PureScript's `Comment` type, which guarantees that the comments before a given source token
  might have some newlines, but that comments afte the source token cannot have any newlines.
  See:
  - https://github.com/purescript/purescript/blob/master/lib/purescript-cst/src/Language/PureScript/CST/Types.hs#L30-L37
  - https://github.com/purescript/purescript/blob/master/lib/purescript-cst/src/Language/PureScript/CST/Types.hs#L41-L42
- Dhall's `Expr` type, which uses the "Voided Sum Type" pattern twice in the same type.
  The first usage determines whether or not source spans are included in the data constructor values
  The second usage determines whether the `Embed` constructor, storing a value that represents
  an imported Dhall expression, either may exist in the parsed expression or definitely
  does NOT exist in the parsed expression.
  - https://hackage.haskell.org/package/dhall-1.40.1/docs/Dhall-Core.html#t:Expr                                          -}
