# State-like Transformers

`ReaderT`, `StateT`, and `WriterT` can all be used to simulate state manipuation effects.

`ReaderT` can "modify state" in a top-down direction via `MonadReader`'s `local` function:

```purs
foo :: Reader Int Int
foo = do
  local (_ + 1) do
    local (_ + 1) do
      local (_ + 1) do
        local (_ + 1) do
          stateAtThisPoint <- ask
          pure stateAtThisPoint

bar = foo 0 -- 0 + 1 + 1 + 1 + 1 == 4
```

`WriterT` can "modify state" in a bottom-up direction via `MonadTell`'s `tell` function
```purs
foo :: Int -> WriterT (Array (Array String)) Int
foo i
  | i == 3 = pure 3
  | otherwise = do
      y <- foo (i + 1)
      tell [[ y ]]

bar = foo 0 -- Tuple 1 [ [3], [2], [1] ]
{-
which breaks down to...

bar = do
  one <- do
    two <- do
      three <- pure 3
      tell [ [ three ] ]
    tell [ [ two ] ]
  tell [ [ one ] ]
-}
```

`StateT` can "modify state" in a top-down and/or bottom-up direction via `MonadState`'s `get`/`put`/`modify` functions.

See also [What is the difference between ST effect / Reader / Writer ?](https://discourse.purescript.org/t/what-is-the-difference-between-st-effect-reader-writer/3102/2)