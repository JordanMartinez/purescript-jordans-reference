-- Work in Progress

-- Composition
f :: Int -> Int
f x = x + 1

g :: Int -> Int
g x = x * 4

f(g(a)) == (f <<< g)(a) -- Haskell: (f . g)(a)
g(f(a)) == (f >>> g)(a) -- Haskell: (g . f)(a)

flip :: forall a b c. (a -> b -> c) -> b -> a -> c
flip twoArgFunction secondArg firstArg = twoArgFunction firstArg secondArg

dollar :: (a -> b) -> a -> b
dollar function arg = function arg

infix precendence dollar as $

print (5 + 5) == print $ 5 + 5
