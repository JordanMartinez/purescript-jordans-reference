module Keyword.Data where

-- Basic syntax for the `data` keyword

data Singleton_no_Args = SingletonConstructor

data Singleton_with_Args = SingletonConstructor2 Arg1 Arg2 ArgN

data Singleton_with_Function_Arg
  = SingletonConstructor3 (ParameterType -> ReturnType)

data Type_with_Many_Implmementations
  = Implementation1
  | Implementation2
  | ImplementationN

data Type_with_Generic_Types aType bType
  = Stores_A aType
  | Stores_B bType
  | Stores_A_and_B aType bType

---------------------------------

-- This syntax enables Algebraic Data Types (ADTs)
-- For an explanation on how 'data types' can be 'algebraic,' see this video:
-- https://youtu.be/Up7LcbGZFuo?t=19m8s

-- 2 basic version of ADTs: sum type and product type

-- the sum type
data SumType
  = SumConstructor1
  | SumConstructor2
  | SumConstructorN

-- example
data Fruit
  = Apple
  | Banana
  | Orange

-- the product type
data ProductType a b = ProductConstructor a b

-- example
data IntAndString = IAndS Int String

--------------------------------------------

-- Intermediate/Advance syntax

-- given this code
data Box a = Box a
-- then...
data Type_with_Nested_Types
  = SingleBox Int
  | NestedBox1 (Box Int)
  | NestedBox2 (Box (Box Int))


data Type_with_Higher_Kinded_Generic_Type higherKindedBy1 a
  = MyConstructor (higherKindedBy1 a)
  | OtherC (higherKindedBy1 Int)

data Type_with_Higher_Kinded_Generic_Type2 higherKindedBy2 a b
  = MyConstructor2 (higherKindedBy2 a b)
  | OtherC2 (higherKindedBy2 Int b)


data Type_whose_implementations_ignore_generic_type ignoredType
  = Constructor_without_generic_type
  | Other_Constructor_no_generic_type Int String


data Type_with_no_implementation -- no equals sign followed by right-hand-side


data Recursive_Type
  = No_Recursion_Here
  | Recursion_Here Recursive_Type

data Recursive_type_with_generic_types a b
  = No_Recursion_Here2
  | Recursion_Here2 (Recursive_type_with_generic_types a b)

------------------------------------------

-- Full Syntax
data InterfaceLikeType aType bType hktBy1 ignored
  = NoArgs
  | Args Type1 Type2 Type3
  | FunctionArg (Type1 -> Type2)
  | NestedArg (Box Int)
  | DoubleNestedArg (Box (Box Int))
  | HigherKindedGenericType1 (hktBy1 Int)
  | HigherKindedGenericType2 (hktBy1 aType)
  | Recursive (InterfaceLikeType aType bType hktBy1 ignored)
  | ArgMix Type_ (A -> B) bType (InterfaceLikeType aType bType hktBy1 ignored)

-- Necessary for this to compile
type Type1 = Int
type Type2 = Int
type Type3 = Int
type Type_ = Int
type A = Int
type B = Int
type Arg1 = Int
type Arg2 = Int
type ArgN = Int
type ParameterType = Int
type ReturnType = Int
