module Syntax.Basic.Record.Basic where

import Prelude

-- Records have a different kind than "Type"
-- Their kind signature is `Row Type -> Type`.

-- `Row` kinds are 0 to N number of "label-to-kind" associations
-- that are known at compile time. `Row` kinds will be covered more fully
-- in the Type-Level Programming Syntax folder.
-- Most of the time, you will see the labels associated with the kind, `Type`.
-- In other words:
type Example_Row = (rowLabel :: ValueType)

-- Rows can have 1 or many label-Type associations...
type Example_of_a_Single_Row = (labelName :: ValueType)
type Example_of_a_Multiple_Rows = (first :: ValueType, second :: ValueType)

type PS_Keywords_Can_Be_Label_Names =
  (data :: ValueType, type :: ValueType, class :: ValueType)

-- Rows can also have kind signatures. The right-most entity/kind
-- will be `Row Type`:
type SingleRow_KindSignature :: Row Type
type SingleRow_KindSignature = (labelName :: ValueType)

type MultipleRows_KindSignature :: Row Type
type MultipleRows_KindSignature = (first :: ValueType, second :: ValueType)

-- Rows can also be empty.
type Example_of_an_Empty_Row :: Row Type
type Example_of_an_Empty_Row = ()

-- Rows can take type parameters just like data, type, and newtype:
type Takes_A_Type_Parameter :: Type -> Row Type
type Takes_A_Type_Parameter a = (someLabel :: Box a)

-- That's enough about rows for now.
-- Let's see why they are useful for Records.

data Record_ -- Row Type -> Type

-- Think of records as a JavaScript object / HashMap / big product types.
-- There are keys (the labels) that refer to values of a given type.
type RecordType_Desugared = Record ( label1 :: String
                                -- , ...
                                   , labelN :: Int
                                   , function :: (String -> String)
                                   )
-- However, there is syntax sugar for writing this:
-- "Record ( rows )" becomes "{ rows }"
type RecordType = { label1 :: String
               -- , ...
                  , labelN :: Int
                  , function :: String -> String
                  }

-- ## Create Records

-- We can create a record using the "{ label: value }" syntax...
createRec_colonSyntax :: RecordType
createRec_colonSyntax = { label1: "value", labelN: 1, function: (\x -> x) }

-- We can also create it using the "names exist in immediate context" syntax

createRec_immediateContextSyntax :: RecordType
createRec_immediateContextSyntax = { label1, labelN, function }
  where
    label1 = "value"
    labelN = 1
    function = \x -> x

-- We can also create it using the "label names exist in external context" syntax
-- Given the below record type...
type PersonRecord = { username :: String
                    , age :: Int
                    , isCool :: String -> Boolean
                    }
-- ... and some values/functions with the same name as that record's labels...
username :: String
username = "Bob"

age :: Int
age = 4

isCool :: String -> Boolean
isCool _ = true

-- ... the compiler will infer below that 'username' should be "Bob"
-- because `username` is a value that exists in this module.
-- Note: this syntax won't pick up things that exist in other files.
createRec_externalContextSyntax :: PersonRecord
createRec_externalContextSyntax = { username, age, isCool }

createRec_noUnderscore :: String -> Int -> (String -> String) -> RecordType
createRec_noUnderscore label1 labelN function = { label1, labelN, function }

createRec_withUnderscore :: String -> Int -> (String -> String) -> RecordType
createRec_withUnderscore = { label1: _, labelN: _, function: _ }

-- same type signature as 'createRec_withUnderscore'
type InlineWithUnderscoreType = String -> Int -> (String -> String) -> RecordType

inlineExample1 :: InlineWithUnderscoreType
inlineExample1 =
  \label1 labelN function -> { label1: label1, labelN: labelN, function: function }

inlineExample2 :: InlineWithUnderscoreType
inlineExample2 =             { label1: _     , labelN: _     , function: _      }

-- ## Get the corresponding values in records

getLabel1 :: RecordType -> String
getLabel1 obj = obj.label1

-- ## Overwrite Labels' Values in Records

-- We can update a record using syntax sugar:
overwriteLabelValue_equalsOperator :: RecordType -> String -> RecordType
overwriteLabelValue_equalsOperator rec string = rec { label1 = string }

-- or by using an underscore to indicate that the next argument is the
-- record type
setLabelValue_recordUnderscore :: String -> RecordType -> RecordType
setLabelValue_recordUnderscore string = _ { label1 = string }                      {-

setLabelValue_recordUnderscore "bar" { label1: "foo" } == { label1: "bar" }        -}

-- or by using an underscore for both args if they come in the correct order:
-- record first and then the argument to apply to that record's label
setLabelValue_recordAndArgUnderscore :: RecordType -> String -> RecordType
setLabelValue_recordAndArgUnderscore = _ { label1 = _ }                            {-

setLabelValue_recordAndArgUnderscore { label1: "foo" } "bar" == { label1: "bar" }  -}

syntaxReminder :: String
syntaxReminder = """

Don't confuse the two operators that go in-between label and value!

"label OPERATOR value" where OPERATOR is
  "=" means "update the label of a record that already exists":
          record { label = newValue }
  ":" means "create a new record by specifying the label's value":
                 { label: initialValue }
"""

-- ## Nested Records

type NestedRecordType = { person :: { skills :: { name :: String } } }

nestedRecord_create :: String -> NestedRecordType
nestedRecord_create newName = { person: { skills: { name: newName } } }

nestedRecord_get :: NestedRecordType -> String
nestedRecord_get rec = rec.person.skills.name

nestedRecord_overwrite1 :: String -> NestedRecordType -> NestedRecordType
nestedRecord_overwrite1 newName p  = p { person { skills { name = newName } } }

nestedRecord_overwrite2 :: String -> NestedRecordType -> NestedRecordType
nestedRecord_overwrite2 newName    = _ { person { skills { name = newName } } }

-- -- This fails to compile!
-- nestedRecord_overwrite3 :: String -> NestedRecordType -> NestedRecordType
-- nestedRecord_overwrite3            = _ { person { skills { name = _       } } }

-- -- This fails to compile
-- nestedRecord_overwrite4 :: String -> NestedRecordType -> NestedRecordType
-- nestedRecord_overwrite4            = _ { _      { _      { name = _       } } }

-- ## Pattern Matching on Records

-- We can also pattern match on a record. The label names must match
-- the label names of the record
patternMatch_allLabels :: Int
patternMatch_allLabels =
  let { label1, label2 } = { label1: 3, label2: 5 }
  in label1 + label2

patternMatch_someLabels :: String
patternMatch_someLabels =
  -- notice how we don't include 'label2' here
  -- in the pattern match
  let { label1 } = { label1: "a", label2: "b" }
  in label1

-- needed to compile
type ValueType = String
data Box a = Box a
