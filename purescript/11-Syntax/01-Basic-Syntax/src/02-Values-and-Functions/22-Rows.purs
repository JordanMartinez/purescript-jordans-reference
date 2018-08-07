module Syntax.Record.RowPolymorphism where

import Prelude

-- We can also use literal records in our function type signatures. These are called Rows:
useName1 :: { name :: String } -> String
useName1 { name: theName } = theName

useName2 :: { name :: String } -> String
useName2 person = person.name -- this syntax also works

rowFunction :: { name :: String } -> String
rowFunction {name: binding } = binding

-- example
test1 :: Boolean
test1 =
  (rowFunction { name: "hello" }) == "hello"
  {- Compiler error: no other fields allowed!
  rowFunction { name: "hello", age: 4 } == "hello" -}


-- There is a way to get rid of the compiler error using row polymorphism
rowPolymorphism1 :: forall anyOtherFieldsThatMayExist. { name :: String | anyOtherFieldsThatMayExist } -> String
rowPolymorphism1 { name: theName } = theName

-- Rather than the "anyOtherFieldsThatMayExist" type name, convention is to
-- use "r". We can also use a "row.field" syntax to make things easier to read
-- but this will prevent pattern matching on the fields.
-- Rewriting our above function to use 'r' convention and the new syntax:
rowPolymorphism2 :: forall r. { name :: String | r } -> String
rowPolymorphism2 person = person.name

-- examples
test2 :: Boolean
test2 =
  (rowPolymorphism2 { name: "a name", age: 4, stuff: "?" }) == "a name" -- now it works!

-- Compiler errors arise when the required field doesn't exist, such as this example:
-- rowPolymorphism { age: 4, stuff: "?" }
