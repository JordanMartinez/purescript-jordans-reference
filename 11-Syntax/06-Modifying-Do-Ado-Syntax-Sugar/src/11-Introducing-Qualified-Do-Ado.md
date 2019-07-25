# Introducing Qualified Do/Ado

## Possible Readability Issue with Rebindable Do/Ado Notation

When using Rebindable do/ado notation, I'd recommend using the `let ... in do/ado` aproach for rebinding function names. Let me give an example why. If we used the 'where' clause approach, it isn't immediately clear whether `do/ado notation` desugars to the standard functions or to some remapped version until the very end. For example,

```purescript
-- Reader thinks, "Oh hey! It's do notation.
-- It's just standard `bind` desugaring."
comp3 :: Box Int
comp3 = do
  a <- Box 1
  b <- Box 1
  c <- Box 1
  d <- Box 1
  e <- Box 1
  f <- Box 1
  g <- Box 1
  h <- Box 1
  i <- Box 1
  j <- Box 1
  k <- Box 1
  l <- Box 1
  m <- Box 1
  n <- Box 1
  o <- Box 1
  p <- Box 1
  q <- Box 1
  r <- Box 1
  pure 5
  where
    someValue = "some really long boilerplate-y string..."

    anotherComputation = case _ of
      Just x -> Right $ foldl ((:)) Nil x
      Nothing -> Left "Not sure what went wrong here..."

    -- Reader now thinks, "Oh crap. My understanding is completely off
    -- now that I know `bind` really means the below definition..."
    bind = -- my custom bind definition...
```
The above problem can be alleviated by bumping `bind` to the top using a let binding.
```purescript
-- Reader thinks, "Oh hey! It's do notation.
-- It's just standard `bind` desugaring."
comp3 :: Box Int
comp3 = do
  -- Reader thinks, "Oh wait. It's using a custom bind definition.
  -- I'll need to read through this next part carefully..."
  let bind = -- my custom bind definition...
  in do
    a <- Box 1
    b <- Box 1
    -- the rest of the code in the example above...
```

## Problems with Rebindable Do/Ado Notation

There are generally two problems with Rebindable do/ado notation.

First, each function that uses this feature must rebind do/ado notation to the correct definition. If one was building a library where each function used this, it would get very tedious.

For example,
```purescript
comp1 :: Box Int
comp1 = let bind = NormalBind.bind in do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)

comp2 :: Box Int
comp2 = let bind = NormalBind.bind in do
  three <- Box 3
  pure (three + two)

-- ok, this is really getting tedious...
comp3 :: Box Int
comp3 = let bind = NormalBind.bind in do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)
```

Second, rebindable do/ado notation might not be easily redable when running computations in various monadic contexts. For example

```purescript
someComputation :: Box Int
someComputation = let bind = NormalBind.bind in do
  -- Box monadic context... use standard bind here
  value1 <- takesMonad1Argument (let bind = customBind in do
    -- Monad1 monadic context... use custom bind here
    value2 <- runMonad1Computation
    takesMonad2Argument (let bind = NormalBind.bind in do
      -- Monad2 monadic context... use a different custom bind here...
      value3 <- runMonad2Computation)
      pure (value3 + 5))
  pure (value1 + 8)
```
As can be seen, "rebindable" do/ado notation is good when functions do not use many lines and one is not switching back and forth between monadic contexts.

Still, Qualified Do/Ado helps "solve" each of these problems. What follows is the requirements one needs to implement before this feature will work. In this example, we'll use a more complicated example: IndexedMonad/[IxMonad](https://pursuit.purescript.org/packages/purescript-indexed-monad/1.0.0/docs/Control.IxMonad#t:IxMonad).
