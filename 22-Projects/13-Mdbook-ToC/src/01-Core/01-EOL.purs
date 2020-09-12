-- | FFI for Node's platform independent end-of-line String value.
module ToC.Core.EOL where

-- | This is the 'String' version of `purescript-node-os`'s `eol` value,
-- | a `Char` type.
foreign import endOfLine :: String
