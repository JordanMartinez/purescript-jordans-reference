# An Explanation

The following explanation builds upon and modifies [this article's explanation](http://www.haskellforall.com/2012/12/the-continuation-monad.html):
- Name of original author: Gabriel Gonzalez
- License: [CC 4.0 International License](https://creativecommons.org/licenses/by/4.0/)
- Changes:
    - Convert code examples to Purescript
    - Renamed `attackUnit` to `attack` to reduce characters per line in code sections
    - Omitted section on Algebraic Data Types
    - Omitted section on Kleisli Composition

## Why Callbacks Exist

When writing a library (e.g. GUI toolkit, game engine, etc.), one may want the end-developer to be able to run their own custom code at some point. In the example below, the custom code is represented by the type hole, `?doSomething`:
```haskell
attack :: Target -> Effect Unit
attack target = do
  valid <- isTargetValid target
  if valid
  then ?doSomething target
  else ignoreAttack
```
Since the library developer does not know how the end-developer will use this function, they can convert `?doSomething` into a callback function that the end-developer supplies:
```haskell
-- library developer's code
attack :: Target -> (Target -> Effect Unit) -> Effect Unit
attack target doSomething = do
  valid <- isTargetValid target
  if valid
  then doSomething target
  else ignoreAttack

-- end-developer's code
attack orc reduceLifeBy50
```
This makes life easy for the library-developer, but not for the end-developer as a large number of nested callbacks can make code very unreadable. (We only need to look at Node.js for an example)

## The Continutation Solution

The problem is not the callback function; there is no other solution for the library-developer. The problem is "where" that function appears in `attackUnit`. In short, the type appears in the argument part of the function (`attackUnit_arg`) instead of in the return part of the function (`attackUnit_return`):
```haskell
-- original version (curried function)
attack ::           Target ->  (Target -> Effect Unit)  -> Effect Unit

-- original version (uncurried function)
attack ::          (Target ->  (Target -> Effect Unit)) -> Effect Unit

-- desugar the last "->" into "Function"
attack :: Function (Target ->  (Target -> Effect Unit))    Effect Unit

-- make function appear in return type
attack :: Function  Target    ((Target -> Effect Unit)  -> Effect Unit)

-- resugar "->"
attack ::           Target -> ((Target -> Effect Unit)  -> Effect Unit)
```

`Effect` is a monad, so we can chain multiple sequential computations like that together using `bind`/`>>=`. If we can do that for `Effect`, why not do so for every monad? This changes our type signature of `attack`:
```haskell
attack_no_monad ::  Target -> ((Target -> Effect Unit) -> Effect Unit)
attack_monad    ::  Target -> ((Target -> monad  Unit) -> monad  Unit)
```
That's a lot of code to write each time, so it can be converted into a `newtype`:
```haskell
newtype ContT return monad input =
  ContT ((input -> monad return) -> monad return)

attack_no_monad ::  Target -> ((Target -> Effect Unit) -> Effect Unit)
attack_monad    ::  Target -> ((Target -> monad  Unit) -> monad  Unit)
attack_cont     ::  Target -> ContT Unit Effect Target
```
To create a `ContT`, we create a function whose only argument is the callback function:
```haskell
ContT (\callbackFunction -> do
  -- everything else we did beforehand...
  callbackFunction arg
  -- everything else we did afterwards...
)
```
Let's implement it for `attack` and compare the two approaches:
```haskell
attack_original :: Target -> (Target -> Effect Unit) -> Effect Unit
attack_original target doSomething = do
  valid <- isTargetValid target
  if valid
  then doSomething target
  else ignoreAttack

attack_contT ::  Target -> ContT Unit Effect Target
attack_contT target = ContT (\doSomething -> do
    valid <- isTargetValid target
    if valid
    then doSomething target
    else ignoreAttack
  )
```
And if we didn't want to use a monad, we could use `Identity` as a placeholder monad:
```haskell
type Cont return input = ContT return Identity input
```

## Comparing ContT to Another Function

Let's play with `ContT` for a bit and see what it reminds us of:
```haskell
-- Original version
newtype ContT return monad input =
  ContT ((input -> monad return) -> monad return)

-- Let's newtype a version of `ContT` when `Identity` is its monad:
newtype ContIdentity return input =
  ContIdentity ((input -> Identity return) -> Identity return)

-- Since `Identity` is merely a placeholer monad,
-- let's remove it, and see what the resulting function's signature is:
contDesugared :: forall input return. ((input -> return) -> return)

-- and if we wanted to run `contDesugared`,
-- we'd need an initial `input` value:
runCont :: forall i r. ((i -> r) -> r) -> (i -> r) -> r
runCont contDesugared callbackFunction = contDesugared callbackFunction

-- Hmm... Doesn't that function's type and body look familiar?
--                   ((i -> r) -> r) -> (i -> r) -> r
apply :: forall a b. (a        -> b) -> a        -> b
apply function arg = function arg

infixr 0 apply as $
```
Exactly. `ContT` is just a monad transformer for the `apply`/`$` function. Let's compare them further:
```haskell
print   10
-- ==
print $ 10
-- ==
apply                print (10)
-- ==
runCont (Cont (\f -> f     (10))) print
-- which reduces to
              (\f -> f     (10))  print
-- which reduces to
                     print (10)
```

## When You Need Two or More Callback Functions

If `attack` is modified, so that it requires two callback functions, `?doSomethingWithDamage` and `doSomethingWithBoth`, it would seem that our nice solution from above would no longer work since we can only specify one of the two functions:
```haskell
attackWith :: Target -> Weapon -> ContT Unit Effect Target
attackWith target weapon = ContT (\only1CallbackFunction -> do
    damage <- calculateDamageFor weapon (modifiedBy 1.5)
    ?doSomethingWithDamage damage
    valid <- isTargetValid target
    if valid
    then ?doSomethingWithBoth target damage
    else ignoreAttack
  )
```

The solution is to pass in a callback function that takes a sum type as its argument. When using `ContT`/`Cont`, the callback function is usually called `k`, so we'll do that here, too:
```haskell
data AllPossibleInputs
  -- where each constructor wraps the arguments
  -- that will be used in a function
  = DoSomethingWithDamage Damage
  | DoSomethingWithBoth Target Damage

-- Note: This approach requires the callback function to return the same
-- `monadType returnType` type for each output.
callbackFunction :: AllPossibleInputs -> Effect Unit
callbackFunction (DoSomethingWithBoth t d) = doSomethingWithBoth t d
callbackFunction (DoSomethingWithDamage d) = doSomethingWithDamage d

doSomethingWithBoth :: Target -> Damage -> Effect Unit
-- implementation

doSomethingWithDamage :: Target -> Effect Unit
-- implementation

attackWith :: Target -> Weapon -> ContT Unit Effect Target
attackWith target weapon = ContT (\callback -> do
    damage <- calculateDamageFor weapon (modifiedBy 1.5)
    callback (DoSomethingWithDamage damage)
    valid <- isTargetValid target
    if valid
    then callback (DoSomethingWithBoth target damage)
    else ignoreAttack
  )
```
(I think one might be able to get around the runtime box overhead imposed by `AllPossibleInputs` by using type-level programming and `Variant`, the open `Either` type.)

## Consider Your Perspective

| If you are... | ... and you come across a situation where... | ... then you should... |
| - | - | - |
| a library developer | you want to use a callback function | move it from the function's LHS to its RHS using `ContT`. If it should take different kinds of input, define a sum type as demonstrated above.
| a developer using a library | you need to use a function that requires or returns a `ContT` | understand that you need to specify what to do at specific points by passing in a callback function via `runCont`/`runContT`. You may also need to write a callback function that takes a sum type like that demonstrated above as its input
