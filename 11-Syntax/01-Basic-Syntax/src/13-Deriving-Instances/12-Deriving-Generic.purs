module Syntax.Basic.Deriving.ClassGeneric where

import Data.Generic.Rep (class Generic, NoArguments, Sum, Product, Constructor, Argument, to, from)

{-
`Generic` is another useful class we can derive. It's found in the `prelude` library: 
See the `Design Patterns/Generics` file for why it's useful.

class Generic type representation | type -> representation, representation -> type where
  to_ :: representation -> type
  from_ :: type -> representation

Normally, we would define a data type and then derive the `Generic` instance
by writing the following:

  derive instance Generic NameOfType _

But what is the type hidden/implied by `_`? The rest of this file
demonstrates what the `_` value is.
The rest of the file helps demonstrate what the `representation` value
will be if you decide to use `Generic`.                                                             -}

-- We'll define a class that's essentially the same as `Generic`
-- but allows us to be explicit about what `_` is
-- and then implement the type's instance by reusing the
-- corresponding function from the `Generic` type class.
class Generic_ type_ representation | type_ -> representation, representation -> type_ where
  to_ :: representation -> type_
  from_ :: type_ -> representation

-- Given the below types
data NoArgs = NoArgs

-- This...
derive instance Generic NoArgs _

-- ... translates to this: 
instance Generic_ NoArgs (Constructor "NoArgs" NoArguments) where
  to_ = to
  from_ = from

data Product5 a b c d e = Product5 a b c d e

-- Notice how the nested Products produce a linked-list like structure
-- rather than a tree-like structure.
derive instance Generic (Product5 a b c d e) _
instance
  Generic_ (Product5 a b c d e)
    ( Constructor "Product5"
        ( Product
            (Argument a)
            ( Product
                (Argument b)
                ( Product
                    (Argument c)
                    ( Product
                        (Argument d)
                        (Argument e)
                    )
                )
            )
        )
    )
  where
  to_ = to
  from_ = from

data Sum5 a b c d e
  = SumA a
  | SumB b
  | SumC c
  | SumD d
  | SumE e

-- Notice how the nested Sums produce a linked-list like structure
-- rather than a tree-like structure.
derive instance Generic (Sum5 a b c d e) _
instance
  Generic_ (Sum5 a b c d e)
    ( Sum
        (Constructor "SumA" (Argument a))
        ( Sum
            (Constructor "SumB" (Argument b))
            ( Sum
                (Constructor "SumC" (Argument c))
                ( Sum
                    (Constructor "SumD" (Argument d))
                    (Constructor "SumE" (Argument e))
                )
            )
        )
    )
  where
  to_ = to
  from_ = from

newtype StartingPoint = StartingPoint (Sum5 NoArgs (Product5 Int Int Int Int Int) NoArgs NoArgs NoArgs)

derive instance Generic StartingPoint _
instance
  Generic_ StartingPoint
    ( Constructor "StartingPoint"
        ( Argument
            (Sum5 NoArgs (Product5 Int Int Int Int Int) NoArgs NoArgs NoArgs)
        )
    )
  where
  to_ = to
  from_ = from
