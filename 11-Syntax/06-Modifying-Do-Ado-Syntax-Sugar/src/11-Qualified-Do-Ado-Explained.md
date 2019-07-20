# Qualified Do/Ado

There are generally three problems with Rebindable do/ado notation.

First, each function that uses this feature must rebind do/ado notation to the correct definition. If one was building a library where each function used this, it would get very tedious.

For example,
```purescript
comp1 :: Box Int
comp1 = do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)
  where
    bind = NormalBind.bind

comp2 :: Box Int
comp2 = do
  three <- Box 3
  pure (three + two)
  where
    bind = NormalBind.bind

-- ok, this is really getting tedious...
comp3 :: Box Int
comp3 = do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)
  where
    bind = NormalBind.bind
```

Second, it isn't immediately clear whether `do notation` refers to the standard `bind` or some remapped version. For example,

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

Third (and related to the prior two), it is very easy to forget to add the necessary `where` clause to remap do/ado notation to the desired defintion. For example,
```purescript
comp1 :: Box Int
comp1 = do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)
  where
    bind = NormalBind.bind

comp2 :: Box Int
comp2 = do
  three <- Box 3
  Box unit
  two <- Box 2
  pure (three + two)
  where
    someValue = "some really long boilerplate-y string..."

    anotherComputation = case _ of
      Just x -> Right $ foldl ((:)) Nil x
      Nothing -> Left "Not sure what went wrong here..."

    -- whoops, I forgot to remap bind here.
```

Qualified Do/Ado "solves" each of these problems. Since we mentioned it earlier, here's what the IndexedMonad looks like: [IxMonad](https://pursuit.purescript.org/packages/purescript-indexed-monad/1.0.0/docs/Control.IxMonad#t:IxMonad).

Since `0.12.2`, we can now use a feature called "Qualified Do" / "Qualified Ado" syntax that allows us to re-use this syntax sugar. What follows is the requirements one needs to implement before this feature will work.
