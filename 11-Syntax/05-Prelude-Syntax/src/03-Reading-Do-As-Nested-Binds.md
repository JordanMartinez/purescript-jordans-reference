# Reading Do Notation as Nested Binds

Be aware of where the parenthesis appear when using multiple bind expressions (e.g. `m a >>= aToMB >>= bToMC`). Below provides a summary of the section called "Do notation" in [this article](https://sras.me/haskell/miscellaneous-enlightenments.html):
```purescript
data Maybe a
  = Nothing
  | Just a

instance bindMonad :: Bind Maybe where
  bind :: forall a b. Maybe a -> (a -> Maybe b) -> Maybe b
  -- when given a Nothing, stop all future computations and return immediately.
  bind Nothing _ = Nothing
  -- when given a Just, run the function on its contents
  bind (Just a) f = f a

half :: Int -> Maybe Int
half x | x % 2 == 0 = Just (x / 2)
       | otherwise = Nothing

-- This statement
(Just 128) >>= half >>= half >>= half
-- desugars first to
(Just 128) >>= (\original -> half original >>= half >>= half )
-- which can be better understood as
(Just 128) >>= aToMB
-- which can be better understood as
bind (Just 128) >>= aToMB
-- since the latter ">>=" calls are nested inside of the first one, one
-- should read the above computation as "Only continue if the previous
--    `bind`/`>>=` call was successful."
-- In this situation, it is:
bind (Just 128) (\original -> half original >>= half >>= half)
-- reduces to
(\128 -> half 128 >>= half >>= half)
-- reduces to
half 128 >>= half >>= half
-- ... and so forth until we get the result:
Just 16


-- Similarly
Nothing    >>= half >>= half >>= half == Nothing
-- desguars first to
Nothing    >>= (\value -> half value >>= half >>= half) == Nothing
-- which can be better understood as
Nothing    >>= aToMB == Nothing
-- which can be better understood as
bind Nothing aToMB == Nothing
-- and, looking at the instance of Bind above, reduces to Nothing
-- The other `half` computations are never executed.

-- Thus, given this function...
half3Times :: Maybe Int -> Maybe Int
half3Times maybeI = do
  original <- maybeI
  first <- half original    -- ===
  second <- half first      --  | a -> m b
  third <- half second      --  |
  pure third                -- ===
-- ... passing in `Nothing` doesn't compute anything
half3Times Nothing == Nothing

-- Likewise, passing in a bad starting value will also stop the computation
-- as soon as possible:
(Just 3) >>= half >>= (\thisWontRun -> pure thisWontRun)
-- will desugar to
bind (Just 3) half =
-- will desugar to
half 3
-- which desugars to
half 3 | 3 % 2 == 0
       | otherwise = Nothing
-- which tests whether `3 % 2 == 0` (false) the 'otherwise path'
Nothing >>= (\thisWontRun -> pure thisWontRun)
-- which desugars to
bind NOthing (\thisWontRun -> pure thisWontRun)
-- which desugars to
Nothing
```
