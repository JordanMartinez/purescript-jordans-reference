-- Think of records as a unordered named TupleN
type RecordType = { field1: String, fieldN: Int, function: String -> String }
-- which desugars to
data RecordType = Record { field1: String, fieldN: Int, function: String -> String }

-- Need to unwrap the Record to get to the underlying fields/functions
getField1 :: RecordType -> String
getField1 (RecordType obj) = obj.field1

-- We can update a record using syntax sugar:
setField1 :: RecordType -> String -> RecordType
setField1    rec    string    =    rec    { field1 =    string    } {-
setField1    rec {- string -} =    rec    { field1 = {- string -} } -}
setField1    rec              =    rec    { field1 = _ }  {- string is inferred here
setField1 {- rec -}           = {- rec -} { field1 = _ }  -}
setField                      =    _      { field1 = _ } -- rec is also inferred here

-- Same inferences using inline functions:
\field1 {- field2 -}-> rec { field1: field1 {- , field2: field2 -} }
-- is the same as
rec { field1: _ {- , field2: _ -} }

\rec field1 {- fieldN -} -> rec { field1: field1 {- , fieldN: fieldN -} }
-- is the same as
                            _   { field1: _ ,    {- , fieldN: _ -}      }



type NestedRecordType = { person: { skills: { name: String } } }

nestedRecordUpdate :: String -> NestedRecordType -> NestedRecordType
nestedRecordUpdate name person = person { skills { name: "newName" }}
