module BadProgram where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Random (randomInt)

main :: Effect Unit
main = do
  log "This is an example of a program that is written in an FP language, \
      \but which is terribly structured. Why? Because it's impossible to test \
      \or otherwise prove that the code works correctly. All of its pure \
      \business logic is intermixed with impure code that makes the \
      \program work."

  initialState <- randomInt 10 20
  int2 <- randomInt 5 20
  int3 <- randomInt 5 30

  let nextState = initialState + int2 * int3 / initialState

  int4 <- randomInt 200 900
  int5 <- randomInt 45 80
  int6 <- randomInt 2 3

  let finalState = nextState * int6 * int5 - int4 + initialState

  log $ "The final output of the program was: " <> show finalState

{-
There's a few issues with this program as it is currently written:

First, it's hard to test. How would you test this program to ensure
    it works properly?

Maybe we want to guarantee that the code will always produce
    a value that is even. Since all of our functions (i.e. the stuff
    we do before storing the next state) receive random integers,
    how could we ensure these functions are defined correctly?

Second, this program does not tell us whether an error can occur
    and, if so, where such an error would appear.

Third, what if we wanted to use a different random number generator
    than the one provided via `Effect.Random (randomInt)`? Let's say
    the first time we run the program, we do want to use 'randomInt.'
    If so, then this works. However, let's say the next time we run
    this program, we want it to use something more complex. Well,
    we don't have an easy way to quickly swap out a random number generator
    without changing our business logic.

Such problems as these will be fixed/improved if we structure our FP
programs using Modern FP Architecture that is covered in this folder.
-}
