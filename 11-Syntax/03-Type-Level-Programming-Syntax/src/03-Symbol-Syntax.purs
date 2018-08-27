module Syntax.TypeLevel.SymbolSyntax where

vl_string :: String
vl_string = "a value-level string!"

-- `Symbols` are type-level strings

-- Compiler imports this automatically via the Prim module
foreign import kind Symbol_

-- This proxy type is defined in the purescript-prelude package
data SProxy (a :: Symbol) = SProxy

-- use literal string syntax
tl_literalString :: SProxy "a type-level string!"
tl_literalString = SProxy

-- use multi-line string syntax!
tl_multiLineString :: SProxy "a type-level \
                             \string!"
tl_multiLineString = SProxy

-- use triple-quote string syntax
tl_tripleQuoteStringSyntax :: SProxy """triple-quote string syntax
 works as long as each new line is indented, so that the compiler
 doesn't think the string is the definition for
 the 'tl_tripleQuoteStringSyntax' function.

 The string will automatically escape special characters
 (e.g. '.', '*', '/')."""
tl_tripleQuoteStringSyntax = SProxy

{-
Symbol's other type-level programming constructs are in other modules
that must be imported to work:
  - purescript-prelude:
      - `IsSymbol` typeclass
      - `reifySymbol` function
  - prim (type-level functions)
      - Compare: "a" compare "b" == LT
      - Append:  "hello" append "world" == "hello world"
      - Cons:    "a" cons "pple" = "apple"
      - Uncons:  "string" = "s" append "tring"
-}
