module TLP.RowList.Advanced where

import Prelude

import Prim.Row as Row
import Prim.RowList as RL
import Prim.Symbol (class Append)

                                                                              {-
Now that we understand how `RowList`s work, let's use them to
map row kinds. In other words, given some input rows, produce
some output rows that have been modified slightly.                            -}

-- Given an input row (and the rowlist produced by `RL.RowToList inputrows rowList`)
-- produce an output row where each label has an "x" appended to it.
class MapRowsAppendXToLabel :: RL.RowList Type -> Row Type -> Row Type -> Constraint
class MapRowsAppendXToLabel rowList inputRows outputRows | rowList inputRows -> outputRows

instance MapRowsAppendXToLabel RL.Nil emptyRow emptyRow
instance (
  -- 1. Use Row.Cons to get the rest of the input rows
  Row.Cons sym a remainingInputRows inputRows,
  -- 2. Append an "x" to the original label
  Append sym "x" symWithXAppended,
  -- 3. Use Row.Cons to update the current label for the output rows.
  Row.Cons symWithXAppended a remainingOutputRows outputRows,
  -- 4. Recursively compute the rest of the rows
  MapRowsAppendXToLabel remainingRowList remainingInputRows remainingOutputRows
  ) => MapRowsAppendXToLabel (RL.Cons sym a remainingRowList) inputRows outputRows

-- | Proves that the 'updated' record is the same as 'original'
-- | record but has an 'x' appended to each label
proof
  :: forall originalRowList original updated
   . RL.RowToList original originalRowList
  => MapRowsAppendXToLabel originalRowList original updated
  => { | original }
  -> { | updated }
  -> Unit
proof _ _ = unit
                                                                            {-
Verify the code compiles via the REPL
---
spago repl
proof1
proof2                                                                      -}
---

proof1 :: Unit
proof1 =
  proof
    { a : 4, b : "", c : false }
    { ax: 4, bx: "", cx: false }

proof2 :: Unit
proof2 =
  proof
    { rowlist : 4, is : "", cool : false }
    { rowlistx: 4, isx: "", coolx: false }

-- This will fail to compile
-- proof3 :: Unit
-- proof3 =
--   proof
--     { rowlist : 4, is : "", cool : false }
--     { rowlist : 4, is : "", cool : false }
