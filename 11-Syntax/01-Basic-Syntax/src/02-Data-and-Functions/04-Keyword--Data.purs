module Syntax.Basic.Keyword.Data where

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

-- We can refer to various parts in these definitions by the following names.
-- Wherever a name appears, that's what you would call it if you were talking
-- to someone else about it.
data TypeConstructor typeParameter = DataConstructor

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
  | NestedBox2 (Box (Box Int)) -- outer Box's "a" is "(Box Int)"

data Type_with_Higher_Kinded_Type f = TypeValue (f Int)

typeWithHigherKindedTypeExample :: Type_with_Higher_Kinded_Type Box
typeWithHigherKindedTypeExample = TypeValue (Box 4)

data Type_with_Higher_Kinded_Generic_Type higherKindedBy1 a
  = MyConstructor (higherKindedBy1 a)
  | OtherC (higherKindedBy1 Int)

data Type_With_HigherKindedByTwo_Generic higherKindedBy2 first second
  = Example (higherKindedBy2 first second)

data Type_whose_implementations_ignore_generic_type ignoredType
  = Constructor_without_generic_type
  | Other_Constructor_no_generic_type Int String


data Type_with_no_implementation -- no equals sign followed by right-hand-side


data Recursive_Type
  = No_Recursion_Here
  | Recursion_Here Recursive_Type
-- Recursion_Here (Recursion_Here (No_Recursion_Here))

data Recursive_type_with_generic_type a
  = End_Recursion_Here
  | Recursion_Here__Store_A a (Recursive_type_with_generic_type a)
{-
Recursion_Here__Store_A "first"
  (Recursion_Here__Store_A "second"
    End_Recursion_Here)
-}
------------------------------------------

-- Full Syntax
data DataType aType bType hktBy1 ignored
  = NoArgs
  | Args Type1 Type2 Type3
  | FunctionArg (Type1 -> Type2)
  | NestedArg (Box Int)
  | DoubleNestedArg (Box (Box Int))
  | HigherKindedGenericType1 (hktBy1 Int)
  | HigherKindedGenericType2 (hktBy1 aType)
  | Recursive (DataType aType bType hktBy1 ignored)
  | ArgMix Type_ (A -> B) bType (DataType aType bType hktBy1 ignored)

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
