# Monadic Function Examples

This file will help you learn how to read a monadic function's "do notation." We'll take some very simple examples and do a graph reduction on them to show how a series of `bind`/`>>=` calls are evaluated into a final value.

## Function Implementations

To help us evaluate these examples manually, we'll include our verbose "not cleaned up" solutions from the previous file here (except for the `Applicative` one):
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType ->
         Function inputType newOutputType
  map originalToNew f = (\input ->
    let originalOutput = f input
    in originalToNew originalOutput)

class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input ->
    let
      originalOutput = f input
      originalToNew = functionInFunction input
    in originalToNew originalOutput)

-- Since pure ignores its argument, I'll use the cleaned up version
-- here because it's easier to understand
class (Apply (Function inputType)) <= Applicative (Function inputType) where
  pure :: forall outputType. outputType -> Function inputType outputType
  pure value = (\_ -> value)

class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input ->
    let
      originalOutput = f input
      inputToNewOutput = originalToFunction originalOutput
    in inputToNewOutput input)
```

## Example 1: `pure`

Let's say I have the following code using "do notation"
```haskell
someComputation = do
  pure 1
```

Let's break it down:
```haskell
pure 1

-- replace `pure` with implementation
(\_ -> 1)
```

This reveals the first issue with learning how to read "do notation" for monadic functions: the entire thing is one massive function. `someComputation` is not a value; it's a function that expects an input.

To actually use it, we'd need to write something like this:
```haskell
produceAValue = someComputation "example input"
  where
  someComputation = do
    pure 1
```

## Example 2: single `bind`

Let's say I have the following code using "do notation"
```haskell
produceValue = someComputation 4
  where
  someComputation = do
    value <- \four -> 1 + four
    pure (value + 5)
```

Let's break it down:
```haskell
produceValue = someComputation 4
  where
  someComputation = do
    value <- \four -> 1 + four
    pure (value + 5)

-- hide the "produceValue" part and focus only on the 'someComputation' part
do
  value <- \four -> 1 + four
  pure (value + 5)

-- desugar do notation into nested >>= calls
(\four -> 1 + four) >>= (\value ->
  pure (value + 5)
)

-- desguar >>= into bind
bind (\four -> 1 + four) (\value ->
  pure (value + 5)
)

-- replace `bind` with definition
(\input ->
  let
    originalOutput = (\four -> 1 + four) input
    originalToFunction = (\value -> pure (value + 5))
    inputToNewOutput = originalToFunction originalOutput
  in inputToNewOutput input
)

-- replace `pure` with definition
(\input ->
  let
    originalOutput = (\four -> 1 + four) input
    originalToFunction = (\value -> (\_ -> value + 5))
    inputToNewOutput = originalToFunction originalOutput
  in inputToNewOutput input
)

-- uncurry the curried function due to `pure` definition replacement
(\input ->
  let
    originalOutput = (\four -> 1 + four) input
    originalToFunction = (\value _ -> value + 5)
    inputToNewOutput = originalToFunction originalOutput
  in inputToNewOutput input
)

-- apply argument to `originalOutput` (`four` becomes `input`)
(\input ->
  let
    originalOutput = (\input -> 1 + input)
    originalToFunction = (\value _ -> value + 5)
    inputToNewOutput = originalToFunction originalOutput
  in inputToNewOutput input
)

-- evaluate `originalOutput`
(\input ->
  let
    originalOutput = 1 + input
    originalToFunction = (\value _ -> value + 5)
    inputToNewOutput = originalToFunction originalOutput
  in inputToNewOutput input
)

-- replace `originalOutput` with its implementation
(\input ->
  let
    originalToFunction = (\value _ -> value + 5)
    inputToNewOutput = originalToFunction (1 + input)
  in inputToNewOutput input
)

-- inline `originalToFunction`'s definition
(\input ->
  let
    inputToNewOutput = (\value _ -> value + 5) (1 + input)
  in inputToNewOutput input
)

-- apply the first argument to the function
(\input ->
  let
    inputToNewOutput = (\(1 + input) _ -> (1 + input) + 5)
  in inputToNewOutput input
)

-- Remove the applied argument
(\input ->
  let
    inputToNewOutput = (\            _ -> (1 + input) + 5)
  in inputToNewOutput input
)

-- inline `inputToNewOutput`
(\input ->
  (\_ -> (1 + input) + 5) input
)

-- apply the `input` argument, which gets ignored
(\input ->
         (1 + input) + 5)
)

-- finish cleaning up the code
(\input -> (1 + input) + 5))
(\input ->  1 + input  + 5)

-- re-reveal the "produceValue" part
produceValue = someComputation 4
  where
  someComputation = (\input -> 1 + input + 5)

-- inline `someComputation`
produceValue = (\input -> 1 + input + 5) 4

-- apply the argument
produceValue = (\4 -> 1 + 4 + 5)

-- remove the lambda argument
produceValue = 1 + 4 + 5

-- Evaluate it
produceValue = 10
```

## Example 3: multiple `bind`

I'll leave this up to the reader to reduce, but the syntax should make it clear how it works (4 is always the initial input in each function below):
```haskell
produceValue = someComputation 4
  where
  someComputation = do
    five <- (\four -> 1 + four)
    three <- (\fourAgain -> 7 - fourAgain)
    two <- (\fourOnceMore -> 13 + fourOnceMore - five * three)
    (\fourTooMany -> 8 - two + three)
```
