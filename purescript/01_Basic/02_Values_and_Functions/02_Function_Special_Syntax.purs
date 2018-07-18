-- ABBREVIATED FUNCTIONS
-- the argument will be appended to the body
abbreviatedFunction :: Int -> Int
abbreviatedFunction   = 3 +    {- is the same as...
abbreviatedFunction i = 3 + i  -}

abbreviatedFunction2 :: Int -> Int -> Int
abbreviatedFunction2 x   = x +   {- is the same as...
abbreviatedFunction2 x i = x + i -}

-- example
(abbreviatedFunction 4) == 7
(abbreviatedFunction2 4 3) == 7

--
genericFunction1 :: a -> a -- Compiler error!
-- we need to explicitly say it work for any kind of type
-- using the "forall a. Type Signature" syntax:
genericFunction1 :: forall a {- b c ... n -}. a -> a

genericFunction2 :: forall a b c. a -> b -> c

-- USING WHERE AND LET IN SYNTAX
whereFunction :: Int -> Int -> String
whereFunction arg1 arg2 = madeUpFunction arg1
  where
    madeUpFunction :: Int -> String
    madeUpFunction i = show (arg2 - i)

let_in_function1 :: Int -> Int -> String
let_in_function1 arg1 arg2 =
  let binding = expression
  in bodyThatUses binding -- let_in_function's body

let_in_function2 :: Int -> Int -> String
let_in_function2 arg1 arg2 =
  let
    binding1 = expression
    binding2 = expression
  in
    bodyThatUses binding1 and binding2 -- let_in_function2's body
