{-
Note: Certain uses of Existential Types seem to be an Anti-Pattern.

See this post for more details:
https://lukepalmer.wordpress.com/2010/01/24/haskell-antipattern-existential-typeclass/

-}
module Patterns.ExistentialTypes where

import Prelude

import Unsafe.Coerce (unsafeCoerce)

data NonPublicState
  = Because_You_Will_Screw_Up_Something_Internally
  | Because_You_Should_Not_Have_Access_To_It
  | Because_We_Want_To_Reduce_The_Number_Of_Generic_Types

type ActualDataTypeUsedInThisProject genericType1 genericType2 =
  { anInt :: Int
  , exposed :: genericType1
  , hidden :: genericType2
  , private :: NonPublicState }

data ExposedDataTypeUsedByEndDevelopers (anInt :: Type) exposed

mkData :: forall a b. ActualDataTypeUsedInThisProject a b -> ExposedDataTypeUsedByEndDevelopers Int a
mkData = unsafeCoerce

unData :: forall exposed r
        . (forall hidden. ActualDataTypeUsedInThisProject exposed hidden -> r)
        -> ExposedDataTypeUsedByEndDevelopers Int exposed
        -> r
unData = unsafeCoerce

changePrivateData :: forall a. (NonPublicState -> NonPublicState) -> ExposedDataTypeUsedByEndDevelopers Int a
changePrivateData f = unData \actualDataType ->
  mkData
    { anInt: actualDataType.anInt
    , exposed: actualDataType.exposed
    , hidden: actualDataType.hidden
    -- change the state of 'private'
    , private: f actualDataType.private
    }
