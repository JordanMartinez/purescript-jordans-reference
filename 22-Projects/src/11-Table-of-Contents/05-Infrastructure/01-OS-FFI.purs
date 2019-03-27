-- | FFI for Node's platform independent end-of-line String value.
module Projects.ToC.Infrastructure.OSFFI (endOfLine) where

-- | This is the 'String' version of `purescript-node-os`'s `eol` value,
-- | a `Char` type.
foreign import endOfLine :: String
