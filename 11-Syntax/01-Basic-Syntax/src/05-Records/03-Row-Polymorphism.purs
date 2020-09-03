module Syntax.Basic.Record.RowPolymorphism where

import Prelude

-- We can also use literal records in our function type signatures:
getName1 :: { name :: String } -> String
getName1 { name: nameValue } = nameValue

getName2 :: { name :: String } -> String
getName2 person = person.name -- this syntax also works

-- example
test1 :: Boolean
test1 =
  (getName1 { name: "hello" }) == "hello"

{-
However, this definition does not allow additional fields.
The following code...

  getName1 { name: "hello", age: 4 }

...will output a compiler error since no other fields are allowed!
-}

{-
Rows can either be "closed" or "open." "Closed" rows means that we will
not be adding any other 'fields' to it at a later time. So far, we
have only shown examples of "closed" rows.
"Open" rows means that we might add more 'fields' to it at a later time.
We'll now show the syntax for that.
-}

-- open rows
type Example_of_Closed_Row              = (first :: ValueType)
type Example_of_Open_Row additionalRows = (first :: ValueType | additionalRows)

type Closed_Record1 = Record (first :: ValueType)
type Open_Record1 r = Record (first :: ValueType | r)

type Closed_Record2 = { first :: ValueType }
type Open_Record2 r = { first :: ValueType | r}

type OpenRecord1 rowsAreDefinedLater = Record ( | rowsAreDefinedLater)
type OpenRecord2 rowsAreDefinedLater = { | rowsAreDefinedLater}

{-
We can get rid of the compiler error by using open rows and row polymorphism

The below function can be read as
    "Given a record that has the field, 'name',
     and zero or more other rows I don't care about,
  I can give you a String value."                                            -}
rowPolymorphism1 :: forall anyOtherFieldsThatMayExist
                  . { name :: String | anyOtherFieldsThatMayExist }
                 -> String
rowPolymorphism1 { name: nameValue } = nameValue

-- Rather than the "anyOtherFieldsThatMayExist" type name, convention is to
-- use "r" for "rows". Rewriting our above function to use 'r' convention:
getName4 :: forall r. { name :: String | r } -> String
getName4 { name: nameValue } = nameValue

-- examples
test2 :: Boolean
test2 =
  (getName4 { name: "a name", age: 4, stuff: "?" }) == "a name" -- now it works!

-- A compiler error will arise when the required field doesn't exist,
-- such as this example:
--
--    getName4 { age: 4, stuff: "?" }


-- needed to compile
type ValueType = String
