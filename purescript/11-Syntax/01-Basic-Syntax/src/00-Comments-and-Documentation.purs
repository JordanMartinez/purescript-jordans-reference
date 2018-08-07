-- This is a single-line comment
-- Anything past the "--" syntax is regarded as a comment

{-
This is a multi-line comment
Anything between the bracket-dash syntax is regarded as a multi-line comment
-}

{- It can also be used to add a comment in-between stuff -}

-- | This is documentation, not a single-line comment.
-- | Anything past the "-- |" syntax is regarded as documentation


-- Every Purescript file in this repo will have the following two lines,
-- so that we can compile this repo and insure it is correct for a given
-- Purescript version
module CommentsAndDocumentations where

import Prelude
