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
