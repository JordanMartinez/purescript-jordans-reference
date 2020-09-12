# Monad Transformer Stacks

You will want to bookmark this page.

Generalizing the idea we discovered in the previous file into a pattern, we get something like this:
```haskell
program :: forall m
         . MonadState StateType m
        => MonadWriter NonOutputData m
     -- => other needed type classes here in any order...
        => m ProgramFinalOutputType
program = do
  -- use all the functions from the type classes

--  StateT state         monad output
-- "IndexN possibleInput monad typeClassOutput"
runProgram :: Index3 input3 (       -- top of the stack
                Index2 input2 (
                  Index1 input1 (
                    Index0 input0   -- =
                      Identity      -- | bottom of the stack (the base monad)
                    output0         -- =
                  ) output1
                ) output2
              ) output3
        -- -> input0      -- =
        -- -> input1      -- | all needed initial args to
        -- -> input2      -- | `run[Word]T`/`runWord` go here
        -- -> input3      -- =
           -> Tuple (
                Tuple (
                  Tuple (
                    Tuple (
                      computationOutput
                      output3
                    )
                    output2
                  )
                  output1
                )
                output0
              )
runProgram program {- args -} =
  runIndex0 (                               -- bottom of the stack
    runIndex1T (
      runIndex2T (
        runIndex3T program index3Args   -- top of the stack
      ) index2Args
    ) index1Args
  ) index0Args
```

Note: when using `ExceptT`, `MaybeT`, or `ListT`, the outputs won't necessarily be `Tuple`s.
