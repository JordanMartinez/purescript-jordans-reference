module Syntax.Basic.Unicode where

-- Unicode sytax is supported

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/2.markdown
-- Changes made:
--  - copied type signature that use unicode syntax except for union/intersect
--  - copied links showing unicode syntax in real libraries
--  - added library showing emoji operators in real library
--  - added forall / ∀ comparison
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

data ℕ = Zero | Succ ℕ

add :: ℕ -> ℕ -> ℕ
add _ _ = Zero

ε :: Number
ε = 0.001

{-
Using unicode syntax, instead of using a combination of characters,
one could use a single character to save space:

| Instead of...  | -> | <- | => | <= | :: | forall |
|----------------+----+----+----+----+----+--------+
| you can use... | →  | ←  | ⇒  | ⇐  | ∷  | ∀      |

Using Unicode syntax can make things unreadable, but sometimes it makes things more readable:
- https://github.com/paf31/purescript-isomorphisms/blob/f1a9e59f831cc3150dd9bc7aa66b2661df250ebe/src/Data/Iso.purs#L22
- https://github.com/paf31/purescript-pairing/blob/837638470c58df3971fe2e56395d65f391c9ba00/src/Data/Functor/Pairing.purs#L43

Yes, this does enable emoiji operators. See this library for an example of
why you might and might not want to use that syntax:
- https://pursuit.purescript.org/packages/purescript-prelewd/0.1.0

-}
