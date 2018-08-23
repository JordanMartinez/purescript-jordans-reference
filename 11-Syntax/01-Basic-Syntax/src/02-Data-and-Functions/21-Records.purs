module Syntax.Record where

-- Think of records as a unordered named TupleN
type RecordType = { field1 :: String
                  , fieldN :: Int
                  , function :: String -> String }
--    which desugars to
type RecordType_Desugared = Record ( field1 :: String
                                   , fieldN :: Int
                                   , function :: (String -> String) )

-- Need to unwrap the Record to get to the underlying fields/functions
getField1 :: RecordType -> String
getField1 obj = obj.field1

createRec :: RecordType
createRec = { field1: "value", fieldN: 1, function: (\x -> x) }

-- We can update a record using syntax sugar:
setField1 :: RecordType -> String -> RecordType
setField1 rec string = rec { field1 = string }

-- Same inferences using inline functions:
--    \field1 field2 -> rec { field1: field1, field2: field2 }
-- is the same as
--    rec { field1: _ , field2: _ }

-- \rec field1 {- fieldN -} -> rec { field1: field1 {- , fieldN: fieldN -} }
-- is the same as
                            -- _   { field1: _ ,    {- , fieldN: _ -}      }



type NestedRecordType = { person :: { skills :: { name :: String } } }

nestedRecordUpdate :: String -> NestedRecordType -> NestedRecordType
nestedRecordUpdate name p = p { person { skills { name = "newName" } } }

{- Syntax reminder:
update single field using copy syntax, use "field = value":
  record { field = newValue }
create record, use "field: value":
  { field: value }
-}
