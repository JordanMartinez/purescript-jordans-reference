# Reading Do Notation as Nested Binds

Be aware of where the parenthesis appear when using multiple bind expressions (e.g. `m a >>= aToMB >>= bToMC`). Below provides a summary of the section called "Do notation" in [this article](https://sras.me/haskell/miscellaneous-enlightenments.html):
```purescript
data Maybe a
  = Nothing
  | Just a

instance b :: Bind Maybe where
  bind (Just a) f = f a
  bind Nothing f = Nothing

half :: Int -> Maybe Int
half x | x % 2 == 0 = Just (x / 2)
       | otherwise = Nothing

-- This statement
(Just 128) >>= half >>= half >>= half == Just 16
-- desugars first to
(Just 128) >>= (\original -> half original >>= half >>= half ) == Just 16
-- which can be better understood as
(Just 128) >>= aToMB == Just 16
-- since the latter ">>=" calls are nested inside of the first one, as in
-- "Only continue if the previous `bind`/`>>=` call was successful."


-- Similarly
Nothing    >>= half >>= half >>= half == Nothing
-- desguars first to
Nothing    >>= (\value -> half value >>= half >>= half) == Nothing
-- which can be better understood as
Nothing    >>= aToMB == Nothing
-- and, looking at the instance of Bind above, reduces to Nothing
--
-- bind instance has this definition:
-- bind Nothing aToMB = Nothing

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
```
