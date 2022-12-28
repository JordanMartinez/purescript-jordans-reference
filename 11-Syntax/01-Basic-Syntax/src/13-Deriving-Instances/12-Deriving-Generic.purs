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

data Product3 a b c = Product3 a b c

derive instance Generic (Product3 a b c) _
instance Generic_ (Product3 a b c)
  ( Constructor "Product3"
      ( Product
          (Argument a)
          ( Product
              (Argument b)
              (Argument c)
          )
      )
  )
  where
    to_ = to
    from_ = from

data Sum3 a b c
  = SumA a
  | SumB b
  | SumC c

derive instance Generic (Sum3 a b c) _
-- getRep :: forall a b c. ?Help
-- getRep = repOf (Proxy :: Proxy (Sum3 a b c))
instance Generic_ (Sum3 a b c)
  ( Sum
      ( Constructor "SumA"
          (Argument a)
      )
      ( Sum
          ( Constructor "SumB"
              (Argument b)
          )
          ( Constructor "SumC"
              (Argument c)
          )
      )
  )
  where
    to_ = to
    from_ = from

newtype StartingPoint = StartingPoint (Sum3 NoArgs (Product3 Int Int Int) NoArgs)

derive instance Generic StartingPoint _
instance Generic_ StartingPoint
  ( Constructor "StartingPoint"
      ( Argument
          (Sum3 NoArgs (Product3 Int Int Int) NoArgs)
      )
  ) 
  where
    to_ = to
    from_ = from
