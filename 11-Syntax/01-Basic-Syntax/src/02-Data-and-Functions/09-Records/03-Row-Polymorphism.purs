module Syntax.Record.RowPolymorphism where

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
However, this definition does not prevent additional fields.
The following code...

  getName1 { name: "hello", age: 4 }

...will output a compiler error since no other fields are allowed!
-}


-- There is a way to get rid of the compiler error using row polymorphism
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
