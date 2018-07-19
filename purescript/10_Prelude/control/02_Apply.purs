data Box a = Box a

instance boxFunctor :: Functor Box where
  map :: forall a b. (a -> b) -> f a -> f b -- alias is "<$>"
  map (Box a) f = Box $ f a -- Box (f a)


class (Functor f) <= Apply f where
  apply :: f (a -> b) -> f a -> f b

infixl 4 apply as <*>

instance boxApply :: Apply Box where
  apply :: f (a -> b) -> f a -> f b
  apply (Box f) (Box a) = Box (f a)

-- example
(Box (\x -> x + 1)) <*> (Box 3) == (Box 4)

applyFirst :: forall a b f. Apply f => f a -> f b -> f a
infixl 4 applyFirst as <*

applySecond :: forall a b f. Apply f => f a -> f b -> f b
infixl 4 applySecond as *>

-- also has a lift3/lift4/lift5
lift2 :: forall a b c f. Apply f
  => (a -> b -> c) -- Type Constructor
  -> f a           -- first arg
  -> f b           -- second arg
  -> f c           -- Return value: implementation of Type

data Person = PersonConstructor Name Age

-- example
lift2 PersonConstructor (Box nameArg) (Box ageArg)
-- is the same as what is more commonly seen
PersonConstructor <$> (Box nameArg) <*> (Box ageArg) -- <*> (Box argN) ...
-- desugars to...
 (\name age -> PersonConstructor name    age) <$> (Box nameArg)  <*> (Box ageArg)
((\name age -> PersonConstructor name    age) <$> (Box nameArg)) <*> (Box ageArg)
(Box  (\age -> PersonConstructor nameArg age))                   <*> (Box ageArg)
(Box          (PersonConstructor nameArg ageArg))

-- The above can be written using `ado` (Syntax Sugar since Purscript 0.12.0)
box :: Box Int
box = Box 0

ado
  in function box
-- function <$> box

ado
  binding <- box
  in function binding
-- (\binding -> function binding) <$> box

ado
  one   <- box1
  two   <- box2
  three <- box3
  in function one three two -- changed order of args
-- (\one two three -> function one three two) <$> box1 <*> box2 <*> box3

ado
  one  <-    box1
  {- _ <- -} box2 -- skipped
             box3
  four <-    box4
  in function one four
-- (\one _ _ four -> function one four) <$> box1 <*> box2 <*> box3 <*> box4

ado
  one <- box1
  let y = one + 1
  in function one y
-- (\one ->
--   let y = one + 1
--   in function one y
-- ) <*> box1

-- all of them now
ado
  one <- box1
  let y = one + 1
  box2
  three <- box3
  in function one y three
-- (\one ->
--   let y = one + 1
--   in \_ three -> function one y three
--  ) <$> box1 <*> box2 <*> box3


-- Thus...
PersonConstructor <$> nameArg <*> ageArg
-- is the same as..
ado
  name <- nameArg
  age <- ageArg
  in PersonConstructor name age

-- This syntax is useful when lines can get really long
ado
  name <- doThisLast( andThenThis( doThisFirst(someArg) ) )
  age <- validateData( unwrapData( (changeData <$> someData) ))
  in PersonConstructor name age
