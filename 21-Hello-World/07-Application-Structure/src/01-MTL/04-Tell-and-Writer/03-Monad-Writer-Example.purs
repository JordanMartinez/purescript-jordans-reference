module ComputingWithMonads.MonadWriter where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Identity (Identity(..))
import Data.Tuple (Tuple(..))
import Control.Monad.Writer.Class (tell, listen, pass, listens, censor)
import Control.Monad.Writer (Writer, runWriter)
import Control.Monad.Writer.Trans (WriterT(..))

main :: Effect Unit
main = case runWriter writeStuff of
  Tuple output otherUsefulData -> do
    log $ "Computation's output: " <> show output
    log $ "Other useful data:\n\n\t" <> otherUsefulData

type Output = Int
type OtherUsefulData = String

                 --   w                 a
           -- WriterT String Identity Int
writeStuff :: Writer  String          Int
writeStuff = do
  (Tuple output1 usefulData) <- listen $ WriterT (
        -- A computation that...
        Identity (
          -- returns this entire object as output,
          -- so that one can use both the computed output
          -- and the OtherUsefulData instance in later computations
          Tuple
            -- the output
            1
            -- the instance, which is appended via `tell` to
            -- the current instance of OtherUsefulData
            "useful data"
        )
    )
  tell $ "\n\n\t" <> "(Listen) 'output1' was: " <> show output1
  tell $ "\n\n\t" <> "(Listen) 'usefulData' was: " <> usefulData
      -- needed to improve reading:
      --  turns "usefulDatasomeData" into
      -- "usefulData" <> "\n\n\t" <> "someData"
      <> "\n\n\t"

  Tuple output2 modifiedData <- listens

    -- 2) ... a modified version of the non-output data
    --          which is not appended via `tell`
    --        before exposing it to the do notation
    (\someData -> "Modified (" <> someData <> ")") $
    WriterT (
        -- 1) A computation...
        Identity (
          -- 2) that returns this entire object as output...,
          -- so that one can use both the computed output and...
          Tuple
            -- the output (this is `output2`)
            2
            -- the instance, which is appended via `tell` to
            -- the current instance of OtherUsefulData
            "someData"
        )
    )
  tell $ "\n\n\t" <> "(Listens) two: " <> show output2
  tell $ "\n\n\t" <> "(Listens) modified Data: " <> show modifiedData

  output3 <- pass $ WriterT (
      -- A computation...
      Identity (

        -- that returns 3 things using a nested Tuple
        --    nested tuple: (Tuple (Tuple one three) two)
        Tuple
          (Tuple
            -- 1) the computation's output (this is `output3`)
            4
            -- 3) a function which modifies the non-output data
            --    before appending it to the current non-output data
            --    instance
            (\value -> "\n\n\t" <> "(in `pass`) Value is: " <> value)
          )
          -- 2) the non-output data
          "value"
        )
    )

  tell $ "\n\n\t" <> "(Pass) output2 was: " <> show output3
    -- needed to improve reading:
    --  turns "4someData" into
    -- "4" <> "\n\n\t" <> "someData"
    <> "\n\n\t"

  output4 <- censor
      -- 3) a function which modifies the non-output data
      --    before appending it to the current non-output data
      --    instance
      (\value -> "(in `censor`) Value is: " <> value) $ WriterT (
        -- 1) A computation...
        Identity (
          -- ...that returns two things
          Tuple
            -- a) the computation's output (this is `output4`)
            2
            -- b) the non-output data, which is...
            "someData"
        )
      )

  tell $ "\n\n\t" <> "(censor) output3 was: " <> show output4

  pure 0
