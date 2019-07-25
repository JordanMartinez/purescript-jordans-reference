# Useful Functions

These all come from `Data.Function` in Prelude.

## Const

```purescript
const :: forall a b. a -> b -> a
const x _ = x

-- Example
const 1 "hello" = 1
const 1 true    = 1
const 1 42      = 1
```

## Flip

```purescript
-- Flip the argument order
flip :: forall a b c. (a -> b -> c) -> b -> a -> c
flip twoArgFunction secondArg firstArg = twoArgFunction firstArg secondArg

-- example
     (append "world!" "Hello ") == "world!Hello "
(flip append "world!" "Hello ") == "Hello world!"
```

## Apply

Forewarning: `apply` via `$` shows up EVERYWHERE! Bookmark this until you get it.

I read somewhere (I think `@garyb` mentioned this on the FP Slack, maybe...?) that `$` was chosen because it's two parenthesis with a line through it, symbolizing that it removes the need to use parenthesis.

```purescript
-- Reduce the number of parenthesis needed
apply :: (a -> b) -> a -> b
apply function arg = function arg

infix 0 apply as $

-- example
print (5 + 5) == print $ 5 + 5

print (append "foo" (4 + 4)) == print $ append "foo" $ 4 + 4
```

## Other Less-Used Functions

```purescript
-- apply with its arguments flipped
applyFlipped :: forall a b. a -> (a -> b) -> b
applyFlipped = flip apply

infxl 1 applyFlipped as #

-- example
print (5 + 5) == 5 + 5 # print

-- apply a function with the given arg totalTimes
applyN :: forall a. (a -> a) -> Int -> a -> a
applyN function totalTimes arg = -- implementation
-- no infix

-- Example
applyN (+) 2 2       -- reduces to...
2 + (applyN (+) 1 2) -- reduces to...
2 + 2

-- When the desired function takes b, but you have 'a'.
-- So, we change 'a' to 'b' and then call the function
on :: forall a b c. (b -> b -> c) -> (a -> b) -> a -> a -> c
on function changeAToB a1 a2 = function (changeAToB a1) (changeAToB a2)

-- Example

on (+) stringToInt "4" "5" == 9
