module ModuleName
  -- exports go here by just writing the name
  ( value

  , function, (>@>>>) -- aliases must be wrapped in parenthesis

  -- when exporting type classes, there are two rules:
  -- - you must precede the type class name with the keyword 'class'
  -- - you must also export the type class' function (or face compilation errors)
  , class TypeClass, tcFunction

  -- when exporting modules, you must precede the module name with
  -- the keyword 'module'
  , module ExportedModule

  -- The type is exported, but no one can create an instance of it
  -- outside of this module
  , ExportDataType1_ButNotItsConstructors

  -- The type is exported and only one of its constructors is exported. Thus,
  -- everyone else can create an instance of `Constructor2A' but not
  -- `Constructor2B`. That one can only be created inside this module.
  , ExportDataType2_AndOneOfItsConstructors(Constructor2A)

  -- The type is exported and some of its constructors are exported. Thus,
  -- everyone else can create an instance of `Constructor3A'
  -- and `Constructor3B`, but not `Constructor3C`, which
  --  can only be created inside this module.
  , ExportDataType3_AndSomeOfItsConstructors(Constructor3A, Constructor3B)

  , ExportDataType3_AndAllOfItsConstructors(..) -- syntax sugar for 'all constructors'

  -- Type aliases can also be exported but must be preceded by 'type'
  , type ExportedTypeAlias

  -- Data type alias
  , (<|_|>)

  -- Type alias
  , type (<_|_>)
  ) where

-- imports go here
import Prelude

import ExportedModule

value :: Int
value = 3

function :: forall a b. a -> b
-- implementation

infix 4 function as >@>>>

class TypeClass a where
  tcFunction :: a -> a -> a

data ExportDataType1_ButNotItsConstructors = Constructor1A

data ExportDataType2_AndOneOfItsConstructors
  = Constructor2A
  | Constructor2B

data ExportDataType3_AndSomeOfItsConstructors
  = Constructor3A
  | Constructor3B
  | Constructor3C

data ExportDataType3_AndAllOfItsConstructors
  = Constructor3A
  | Constructor3B

type ExportedTypeAlias = Int

data ExportedDataType4_InfixNotation = Constructor4

infixr 4 ExportedDataType4_InfixNotation as <|_|>

type ExportedTypeAlias_InfixNotation = String

infixr 4 type ExportedTypeAlias_InfixNotation as <_|_>

-- TODO: export kinds and add this to full syntax
data ValueLevel_to_TypeLevelType ( typelevel :: CustomKind)
