-- This module uses syntax that hasn't been explained this far into
-- this reference work. It'll make more sense after one understands
-- - Let bindings (e.g. `example1` and `example2`)
-- - do notation (e.g. `example4`)
-- - ado notation (e.g. `example5`)
module Syntax.Basic.SpecialCompilerFeatures.HolesOnComplexExpressions where

import Prelude

-- The previous examples in this folder showed
-- how to use typed holes in one direction:
--    `Type Signature --> Expression`
--
-- This workflow helps one know what expression to provide to "fill"
-- the typed hole.
--
-- One can also go in the opposite direction. Sometimes, a developer
-- will write a complex expression. It can be hard for the developer
-- to determine what the type signature for that expression is.
-- Thus, one can go in the opposite direction:
--    `Expression --> Type Signature`
--
-- This can be accomplished via type annotations on bindings.
-- Since the typed holes produce compiler errors, the below
-- code will not compile. Uncomment the code to see the result.

-- example1ViaWhere :: Int
-- example1ViaWhere = 4
--   where
--   -- Verbose way
--   example1 :: ?Help
--   example1 = "foo"

--   -- one-liner way
--   example2 :: ?Help = "foo"

-- example2ViaLet :: Int
-- example2ViaLet =
--   let
--     -- Verbose way
--     example1 :: ?Help
--     example1 = "foo"

--     -- one-liner way
--     example2 :: ?Help = "foo"
--   in
--     4

-- These work in `case _ of` expressions
-- example3ViaCase :: Int
-- example3ViaCase = 4
--   where
--   foo = case 4 + 4 :: ?Help of
--     eight -> eight

-- These also work when using "do notation" and "ado notation".
-- example4InDo :: Int -> Int
-- example4InDo = do
--   four :: ?Help <- (\inputArg -> 4)
--   pure 4

-- example5InAdo :: Int -> Int
-- example5InAdo = ado
--   four :: ?Help <- (\inputArg -> 4)
--   in four
