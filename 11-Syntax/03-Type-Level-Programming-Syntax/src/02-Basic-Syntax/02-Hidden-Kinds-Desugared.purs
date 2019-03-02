module Syntax.TypeLevel.HiddenKindsDesugared where

-- In all of the following declarations that use the generic type, `aType`,
-- each hides the kind of `aType`:
data MyType_Kind_Hidden aType

class MyClass_Kind_Hidden aType

-- By using (aType :: Kind) syntax, we can dessugar the syntax
-- to reveal the kind of `aType`

data MyType_Kind_Shown (aType :: Type)

class MyClass_Kind_Shown (aType :: Type)
-- (atype :: Type) can be read as
-- "a type-level value, bound to the name `aType`, that has kind `Type`"

{-
We'll need a way to convert
  - value-level to type-level (reification)
  - type-level to value-level (reflection)

In other words, we need a function.
-}

-- Functions are defined like so
data ValueLevel_to_ValueLevel_Function (input :: Type) (output :: Type)
-- (input :: Type) -> (output :: Type) -- using syntax sugar

-- instead of what we need:
foreign import kind Kind
data TypeLevel_to_ValueLevel_Function (input :: Kind) (output :: Type)
data ValueLevel_to_TypeLevel_Function (input :: Type) (output :: Kind)

-- To fix this, we use a Proxy type,
--    a value-level type that wraps a kind:
data Proxy (kindValue :: Kind) = ProxyValue

-- The above definition will make more sense in the future.

-- We can use Proxy to create type-level values
