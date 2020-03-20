module Syntax.Basic.Function.HigherKindedTypes where

import Prelude

-- == Review ==
data Box a = Box a
-- `Box a` is a higher-kinded type (HKT). In other words,
-- it has a kind of `Type -> Type`, not `Type` like Int.
-- Its 'a' still needs to be specified before it is fully concrete.

-- we can define a function when the 'a' of Box is known ("Int" in this case)...
add1 :: Box Int -> Box Int
add1 (Box x) = Box (x + 1)

-- we can also define a function when 'a' of Box is not known
modify :: forall a. Box a -> (a -> a) -> Box a
modify (Box a) function = Box (function a)

-- However, how might one write a function that works on all of
-- the four types below? In other words, how would we define a function
-- when we know we will have a higher-kinded type like `Box`, but
-- we don't know the exact type of that Box-like type?

data Box1 a = Box1 a
data Box2 a = Box2 a
data Box3 a = Box3 a
data Box4 a = Box4 a

-- The following function shows the syntax to follow.
hktFunction0 :: forall f a. f a -> f a
hktFunction0 boxN = boxN
{-
Read
  "f a"
as
  "f is a higher-kinded type
    that needs one type, `a`, specified
    before it can be a concrete type"

When using higher-kinded types, convention is to start with `f` and continue
down the alphabet for each higher-kinded type thereafter (e.g. `g`, `h`, etc.). -}

hktFunction1 :: forall f g h a. f a -> g a -> h a -> h a
hktFunction1 _ _ hOfA = hOfA

-- I think the convention of using 'f' has something to do with a Type Class
-- called Functor (covered in the Hello-World folder).


-- If the higher-kinded type we want to include in our function takes more than
-- one type, we just add the extra types beyond it
data HigherKindedTypeWith4Types a b c d = Constructor a b c d

hktFunction2 :: forall f a b c d. f a b c d -> f a b c d
hktFunction2 f_abcd = f_abcd
{-
Read the above
  "f a b c d"
as
  "f is a higher-kinded type
     that takes 4 types, 'a', 'b', 'c', and 'd',
     all of which need to be specified
     before 'f' can be a concrete type"
-}

-- We can also specify specific types in the function:
hktFunction3 :: forall f a b c. f a b c Int -> f a b c Int
hktFunction3 f_abc_Int = f_abc_Int
{-
Read
  "f a b c Int"
as
  "f is a higher-kinded type
    that takes 4 types, 'a', 'b', 'c', and 'd'.

  'd' has already been specified to 'Int',
    but
  the other types (a, b, and c) have yet to be specified.

  The compiler will complain
    if one passes in an 'f' type whose fourth type is not an Int.
-}


-- Returning to our previous question...
boxFunction :: forall f a. f a -> (f a -> a) -> (a -> a) -> (a -> f a) -> f a
boxFunction boxN unwrap changeA rewrap =
  rewrap (changeA (unwrap boxN))
-- The unwrap and rewrap functions in the above function are only needed to make
-- this compile. In many functions, they won't be needed due to
-- typeclasses (explained later).

-- If we specified functions like below for each of the box type...
unwrapBox2 :: forall a. Box2 a -> a
unwrapBox2 (Box2 a) = a

unwrapBox3 :: forall a. Box3 a -> a
unwrapBox3 (Box3 a) = a

rewrapBox2 :: forall a. a -> Box2 a
rewrapBox2 a = Box2 a

rewrapBox3 :: forall a. a -> Box3 a
rewrapBox3 a = Box3 a

-- The following code will compile
box2Example :: Box2 Int
box2Example = boxFunction (Box2 2) unwrapBox2 (_ + 1) rewrapBox2 -- Box2 3

box3Example :: Box3 Int
box3Example = boxFunction (Box3 3) unwrapBox3 (_ + 1) rewrapBox3 -- Box3 4

-- Keep in mind that any type that follows a 'forall' keyword could be
-- a higher-kinded type

-- Higher kinded types can also occur in data declarations:
data Type_with_HKT :: (Type -> Type) -> Type -> Type
data Type_with_HKT hkt a = Type_With_HKT_Constructor (hkt a)
{-
Thus we could have multiple values of this specific type, depending on what
type the `hkt` is:
  Type_With_HKT Array Int
  Type_With_HKT Box Int
-}

data Type_with_2_HKT :: (Type -> Type) -> (Type -> Type) -> Type -> Type
data Type_with_2_HKT hkt1 hkt2 a = Type_With_2_HKT_Constructor (hkt1 a) (hkt2 a)
-- Type_with_2_HKT Array Array a
-- Type_with_2_HKT Array Box a
-- Type_with_2_HKT Box Array a
-- Type_with_2_HKT Box Box a
