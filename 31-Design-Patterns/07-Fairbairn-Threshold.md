# Fairbairn Threshold

> The Fairbairn threshold is the point at which the effort of looking up or keeping track of the definition is outweighed by the effort of rederiving it or inlining it. (Source: https://wiki.haskell.org/Fairbairn_threshold)

Or, why it's not worth it to try to reduce boilerplate by naming every possible variation of something.
```haskell
-- This is more modular and can easily be adjusted when things change
          map (_ + 1)               (Just 4)   == 5
     map (map (_ + 1))        (Just (Just 4))  == 5
map (map (map (_ + 1))) (Just (Just (Just 4))) == 5

-- Rather than these variations, which aren't worth the work of looking up later
-- because the implementation can readily be rewritten/inlined
map1 f =           map f
map2 f =      map (map f)
map3 f = map (map (map f))
```
