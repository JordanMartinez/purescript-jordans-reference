# How the Computer Executes FP Programs

Or "What does sequential computation look like using Monads"

Below, we'll be defining a long chain of nested functions. Since functions usually place their argument on the right of the body like this...
```
(\x -> body) actualArgument
```
... we'll be putting it on the left using `#`
```
actualArgument # (\x -> body)
```
In other words...
```haskell
function      arg == arg # function
(\x -> x + 1) arg == arg # (\x -> x + 1)
```
This will help the upcoming examples be much clearer and more understandable.

Using this type and its instance...
```haskell
data Box a = Box a

instance Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box  b
  map f (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply (Box f) (Box a) = Box (f a)

instance Bind Box where
  bind :: forall a b. Box a -> (a -> Box b) -> Box b
  bind (Box a) f = f a

instance Applicative Box where
  pure :: forall a. a -> Box a
  pure a =  Box a
```
... we will translate the Javascript "program" below...
```javascript
const four = 4
const five = 1 + four
const five_string = toString(five); // or whatever the function called
print(five_string); // print the String to the console, which returns nothing
```
... into its corresponding Purescript "program" (next).

In the following snippet of code, you will need to scroll to the right, so that the a previous reduction aligns with the next reduction. **Note: Read through this and practice writing it out multiple times until you get sick of it as this is at the heart of FP programming! Failure to understand this == Failure to write FP code.** Here's the code:
```haskell
unsafePerformEffect :: forall a. Box a -> a
unsafePerformEffect (Box a) = a

-- Compute what the final Box value is in `main`
-- and then call `unsafePerformEffect` on the final Box
runProgram :: Unit
runProgram = unsafePerformEffect main

main :: Box Unit
main =
  (Box 4) >>= (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

-- Step 1: De-infix the first '>>=' alias back to bind
  bind (Box 4)  (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

-- Step 2: Look up Box's bind implementation...
--   ...and replace the left-hand side with the right-hand side
            4 # (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

            -- Step 3: Apply the arg to the function (i.e. replace "four" with 4)
                (\4    -> Box (1 + 4   ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

                -- Step 4: Reduce the function to its body
                          Box (1 + 4   ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 5: Reduce the argument in "Box (1 + 4)" to "Box 5"
                          Box (5       ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 6: Remove the parenthesis
                          Box  5         >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 7: Remove the extra whitespace and push right
                                   Box 5 >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                                   -- Step 8: Repeat Steps 1-7 for the next ">>="
                                   bind (Box 5)  (\five -> Box (show five) >>= (\five_string -> print five_string))

                                             5 # (\five -> Box (show five) >>= (\five_string -> print five_string))

                                                 (\5    -> Box (show 5   ) >>= (\five_string -> print five_string))

                                                           Box (show 5   ) >>= (\five_string -> print five_string)

                                                           Box ("5"      ) >>= (\five_string -> print five_string)

                                                           Box  "5"        >>= (\five_string -> print five_string)

                                                                   Box "5" >>= (\five_string -> print five_string)

                                                                   -- Step 8: Repeat Steps 1-6 for the next ">>="
                                                                   bind (Box "5")  (\five_string -> print five_string)

                                                                             "5" # (\five_string -> print five_string)

                                                                                   (\"5"         -> print "5")

                                                                                                    print "5"

                                                                  -- Step 9: Look up `print`'s definition
                                                                  --
                                                                  --   print :: forall a. a -> Box Unit
                                                                  --   print a =
                                                                  --      -- Assume that 'a' is printed to the console
                                                                  --      Box unit
                                                                  --
                                                                  -- ... and replace the LHS with RHS

                                                                                                     Box unit

                                                                  -- Step 10a: Shift everything to the left again
-- 10b) ... and re-expose the 'main' function:
main :: Unit
main = Box unit -- after all the earlier computations...

-- Step 12: call `unsafePerformEffect` to get the final Box's value
runProgram :: Unit
runProgram = unsafePerformEffect (Box unit)
-- becomes
runProgram :: Unit
runProgram = unit
```

Now go read the code snippet above again and write it out!


## Do and Ado Notation

At this point, you should look back at the `Syntax/Prelude-Syntax` folder and read through its files. Feel free to ignore the `Qualified Do/Ado Explained` file and those that follow.

Once finished, read the next file.
