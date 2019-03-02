module Syntax.TypeLevel.Functions.PatternMatching.InstanceChains where

{-
So far, our type-level function's pattern matches use literal values.

Whenever we write...
   instance match_2 :: TL_Function InputValue1 OutputValue1
   instance match_1 :: TL_Function InputValue2 OutputValue2

... it's the equivalent of writing

   tl_Function :: Input -> Output
   tl_Function InputValue1 = OutputValue1
   tl_Function InputValue2 = OutputValue2

-}

-- Let's say we have the given value-level and type-level types/values:
data Fruit
  = Apple
  | Orange
  | Banana
  | Blueberry
  | Cherry

data ZeroOrOne = Zero | One

foreign import kind FruitKind
foreign import data AppleK     :: FruitKind
foreign import data OrangeK    :: FruitKind
foreign import data BananaK    :: FruitKind
foreign import data BlueberryK :: FruitKind
foreign import data CherryK    :: FruitKind

foreign import kind ZeroOrOneKind
foreign import data ZeroK :: ZeroOrOneKind
foreign import data OneK  :: ZeroOrOneKind

-- To write pattern matches with a 'catch-all' underscore binding

fruitToInt :: Fruit -> ZeroOrOne
fruitToInt Apple                    = Zero
fruitToInt _ {- Orange .. Cherry -} = One

-- we can use a feature called "Value Chains:"

class FruitToInt (a :: FruitKind) (i :: ZeroOrOneKind)
  | a -> i                                                                {-

  Notice that we have omitted this type signature because
  we don't know what to do when we know `i` but not `a`

  , i -> a                                                                -}


instance appleMatch :: FruitToInt AppleK ZeroK
else instance catchAll :: FruitToInt a OneK

{-
which is the same as writing...

  instance appleMatch     :: FruitToInt AppleK     ZeroK
  instance orangeMatch    :: FruitToInt OrangeK    OneK
  instance bananaMatch    :: FruitToInt BananaK    OneK
  instance blueberryMatch :: FruitToInt BlueBerryK OneK
  instance cherryMatch    :: FruitToInt CherryK     OneK
-}

{-
As of this writing, Purescript does not support all of the features
described in the paper below (i.e. backtracking), but it does work
for simpler use cases like above

Here's the related Purescript issue:
https://github.com/purescript/purescript/issues/2315

See the original paper here:
http://homepages.inf.ed.ac.uk/jmorri14/pubs/morris-icfp2010-instances.pdf
-}
