# Useful Functions

These all come from `Data.Function` in Prelude.

## `const`

```haskell
const :: forall a b. a -> b -> a
const x _ = x

-- Example
const 1 "hello" = 1
const 1 true    = 1
const 1 42      = 1
```

## `flip`

```haskell
-- Flip the argument order
flip :: forall a b c. (a -> b -> c) -> b -> a -> c
flip twoArgFunction secondArg firstArg = twoArgFunction firstArg secondArg

-- example
     (append "world!" "Hello ") == "world!Hello "
(flip append "world!" "Hello ") == "Hello world!"
```

## `apply`

Forewarning: `apply` via `$` shows up EVERYWHERE! Bookmark this until you get it.

I read somewhere (I think `@garyb` mentioned this in the PureScript chatroom) that `$` was chosen because it's two parenthesis with a line through it, symbolizing that it removes the need to use parenthesis.

```haskell
-- Reduce the number of parenthesis needed
apply :: (a -> b) -> a -> b
apply function arg = function arg

infix 0 apply as $

-- example
print (5 + 5) == print $ 5 + 5

print (append "foo" (4 + 4)) == print $ append "foo" $ 4 + 4

-- control flow reads bottom-to-top
print
  $ append "foo"
  $ 4 + 4
```

## `applyFlipped`

```haskell
-- apply with its arguments flipped
applyFlipped :: forall a b. a -> (a -> b) -> b
applyFlipped = flip apply

infxl 1 applyFlipped as #

-- example
append "foo" (print (5 + 5)) == 5 + 5 # print # append "foo"

-- control flow reads top-to-bottom
-- looks similar to `foo.function().someOtherFunction(arg)`
-- in a C-style or Java language.
5 + 5
  # print
  # append "foo"
```
## Other Less-Used Functions

### `applyN`

```haskell
-- apply a function with the given arg totalTimes
applyN :: forall a. (a -> a) -> Int -> a -> a
applyN function totalTimes arg = -- implementation
-- no infix

-- Example
applyN (+) 2 2       -- reduces to...
2 + (applyN (+) 1 2) -- reduces to...
2 + 2
```

### `on`

```haskell
-- When the desired function takes b, but you have 'a'.
-- So, we change 'a' to 'b' and then call the function
on :: forall a b c. (b -> b -> c) -> (a -> b) -> a -> a -> c
on function changeAToB a1 a2 = function (changeAToB a1) (changeAToB a2)

-- Example

on (+) stringToInt "4" "5" == 9
```

## Rarely-Used Functions

### Natural Transformations

Changes the `Box`-like type that wraps some `a`. Since the `a` isn't relevant, `~>` emphasizes the box types that are being changed. It's not used frequently, but knowing about `~>` helps you to read code.

```haskell
-- Data.NaturalTransformation (NaturalTransformation, (~>))

-- Given this code
data Box1 a = Box1 a
data Box2 a = Box2 a

-- This function's type signature...
box1_to_box2 :: forall a. Box1 a -> Box2 a
box1_to_box2 (Box1 a) = Box2 a
-- ... has a lot of noise and could be re-written to something
-- that communicates our intent better via Natural Transformations...

-- Read: change the container F to container G.
-- I don't care what type 'a' is since it's irrelevant
type NaturalTransformation f g = forall a. f a -> g a

infixr 4 NaturalTransformation as ~>

box1_to_box2 ::           Box1   ~> Box2 {- much less noisy than
box1_to_box2 :: forall a. Box1 a -> Box2 a -}
box1_to_box2             (Box1 a) = Box2 a
```
