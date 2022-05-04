module Syntax.TypeLevel.IntegerSyntax where

-- value level integers
vl_int1 :: Int
vl_int1 = 1

vl_int2 :: Int
vl_int2 = 0x01 -- alternative way to write them

vl_int3 :: Int
vl_int3 = 1_000_000 -- use underscores for thousands character


-- `Int` are type-level integers

-- Compiler imports kind `Int` automatically via the Prim module
data Int_

-- This proxy type is defined in the purescript-prelude package
data Proxy :: forall k. k -> Type
data Proxy kind = Proxy

-- use literal int syntax
tl_literalInt1 :: Proxy 1234
tl_literalInt1 = Proxy

-- use hexadecimal syntax!
tl_literalInt2 :: Proxy 0x01
tl_literalInt2 = Proxy

-- use underscore syntax
tl_literalInt3 :: Proxy 1_000_000
tl_literalInt3 = Proxy

-- negative values must be wrapped in parenthesis
-- use literal int syntax
tl_literalInt1' :: Proxy (-1234)
tl_literalInt1' = Proxy

-- use hexadecimal syntax!
tl_literalInt2' :: Proxy (-0x01)
tl_literalInt2' = Proxy

-- use underscore syntax
tl_literalInt3' :: Proxy (-1_000_000)
tl_literalInt3' = Proxy

{-
Int's other type-level programming constructs are in other modules
that must be imported to work:
  - purescript-prelude:
      - `Reflectable` typeclass
      - `reflectType` function
      - `reifyType` function
  - prim (type-level functions)
      - Add: "a" compare "b" == LT
      - Mul:  "hello" append "world" == "hello world"
      - ToString:    "a" cons "pple" = "apple"
-}
