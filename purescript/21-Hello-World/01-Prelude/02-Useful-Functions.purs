const :: forall a b. a -> b -> a
const x _ = x

-- Example
const 1 "hello" = 1
const 1 true    = 1
const 1 42      = 1

-- Flip the argument order
flip :: forall a b c. (a -> b -> c) -> b -> a -> c
flip twoArgFunction secondArg firstArg = twoArgFunction firstArg secondArg

-- example
     (append "world!" "Hello ") == "world!Hello "
(flip append "world!" "Hello")  == "Hello world!"

-- Reduce the number of parenthesis
apply :: (a -> b) -> a -> b
apply function arg = function arg

infix 0 apply as ($)

-- example
print (5 + 5) == print $ 5 + 5

-- apply with its arguments flipped
applyFlipped :: forall a b. a -> (a -> b) -> b
applyFlipped = flip apply

infxl 1 applyFlipped as (#)

-- apply a function with the given arg totalTimes
applyN :: forall a. (a -> a) -> Int -> a -> a
applyN function totalTimes arg = -- implementation
-- no infix

-- When the desired function takes b, but you have 'a'.
-- So, we change 'a' to 'b' and then call the function
on :: forall a b c. (b -> b -> c) -> (a -> b) -> a -> a -> c
on function changeAToB a1 a2 = function (changeAToB a1) (changeAToB a2)
