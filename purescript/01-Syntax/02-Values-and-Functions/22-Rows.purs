-- We can also use literal records in our function type signatures. These are called Rows:
useName :: { name :: String } -> String
useName { name: theName } = theName
useName person = person.name -- this syntax also works

-- example
rowFunction { name: "hello" } == "hello"
rowFunction { name: "hello", age: 4 } == -- compiler error: no other fields allowed!


-- There is a way to get rid of the compiler error using row polymorphism
rowPolymorphism :: forall anyOtherFieldsThatMayExist. { name :: String | anyOtherFieldsThatMayExist } -> String
rowPolymorphism { name: theName } = theName
rowPolymorphism person = person.name -- this syntax also works

-- examples
rowPolymorphism { name: "a name" } == "a name"
rowPolymorphism { name: "a name", age: 4, stuff: "?" } == "a name" -- now it works!
rowPolymorphism { age: 4, stuff: "?" } -- compiler error! Where is field 'name' ?

-- Rather than the "anyOtherFieldsThatMayExist" type name, convention is to
-- use "r". Rewriting our above function to convention norms...

rowPolymorphism :: forall r. { name :: String | r } -> String
rowPolymorphism { name: theName } = theName
rowPolymorphism person = person.name -- this syntax also works
