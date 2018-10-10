module Syntax.Record.Basic where

-- Records have a different kind than "Type".

-- "# Type" stands for "Row". It is a special kind used to indicate that
-- there will be an N-sized number of types that are known at compile time.

type Example_of_an_Empty_Row = ()
type Example_of_a_Single_Row = (fieldName :: ValueType)
type Example_of_a_Multiple_Rows = (first :: ValueType, second :: ValueType)

data Record_ -- # Type -> Type

-- Think of records as a unordered named TupleN
type RecordType_Desugared = Record ( field1 :: String
                                -- , ...
                                   , fieldN :: Int
                                   , function :: (String -> String)
                                   )
-- However, there is syntax sugar for writing this:
-- "Record ( rows )" becomes "{ rows }"
type RecordType = { field1 :: String
               -- , ...
                  , fieldN :: Int
                  , function :: String -> String }

getField :: RecordType -> String
getField obj = obj.field1

createRec :: RecordType
createRec = { field1: "value", fieldN: 1, function: (\x -> x) }

-- We can update a record using syntax sugar:
setField :: RecordType -> String -> RecordType
setField rec string = rec { field1 = string }

-- Some syntax for inline functions:

--    \field1 field2 -> rec { field1: field1, field2: field2 }
-- ... is the same as ...
--                      rec { field1: _     , field2: _      }

--    \rec field1 {- fieldN -} -> rec { field1: field1 {- , fieldN: fieldN -} }
-- ... is the same as ...
--                                _   { field1: _      {- , fieldN: _      -} }

type NestedRecordType = { person :: { skills :: { name :: String } } }

nestedRecordUpdate :: String -> NestedRecordType -> NestedRecordType
nestedRecordUpdate name p = p { person { skills { name = "newName" } } }

syntaxReminder :: String
syntaxReminder = """

Don't confuse the two operators that go in-between field and value!

"field OPERATOR value" where OPERATOR is
  "=" means "update the field of a record that already exists":
          record { field = newValue }
  ":" means "create the field of a new record":
          record { field: initialValue }
"""

-- needed to compile
type ValueType = String
