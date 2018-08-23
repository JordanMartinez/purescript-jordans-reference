module Syntax.TypeLevel.Symbol where


{-
Original credit: @LiamGoodacre
Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/9.markdown
Changes made:
  - use meta-language to explain newtype class derivation syntax
  -

Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
  https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
-}
-- When we write the following code, we are indicating a value
-- that exists at runtime

-- "a string value that exists at runtime"

-- During the runtime, we can manipulate this string by doing things like
-- adding things to it, or getting a specific character somewhere within it.
-- However, these kinds of things can only be done during the runtime.

-- Symbol is like a compile-time version of a runtime String.
-- You can manipulate it during compile-time in various ways, such as
-- appending Symbols together. Why might this be useful? Because it enables
-- what's called "type-level programming."

-- A Symbol does not have a 'type'. Rather, a Symbol has kind "*".
