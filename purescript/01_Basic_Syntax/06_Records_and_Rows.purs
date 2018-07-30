type RecordType = { field1: String, fieldN: Int, function: String -> String }

-- Need to unwrap the Record to get to the underlying fields/functions
getField1 :: RecordType -> String
getField1 (RecordType obj) = obj.field1

setField1 :: RecordType -> String -> RecordType
setField1 rec string = rec { field1 = string }
setField1 rec = rect { field1 = _}  -- string is inferred here
setField = _ { field1 = _ } -- rec is also inferred


--
type NestedRecordType = { person: { skills: { name: String } } }

nestedRecordUpdate :: String -> NestedRecordType -> NestedRecordType
nestedRecordUpdate name person = person { skills { name: newName }}

--
rowFunction :: { name :: String } -> String
rowFunction { name: theName } = theName
rowFunction person = person.name -- this syntax also works
-- example
rowFunction { name: "hello" } == "hello"
rowFunction { name: "hello", age: 4 } == -- compiler error: no other fields allowed!

--
rowPolymorphism :: forall anyOtherFieldsThatMayExist. { name :: String | anyOtherFieldsThatMayExist } -> String
rowPolymorphism { name: theName } = theName
rowPolymorphism person = person.name -- this syntax also works

-- examples
rowPolymorphism { name: "a name" } == "a name"
rowPolymorphism { name: "a name", age: 4, stuff: "?" } == "a name"
rowPolymorphism { age: 4, stuff: "?" } -- compiler error! Where is field 'name' ?
