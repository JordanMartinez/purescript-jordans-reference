# Lazy vs Strict

A computation can either be lazy or strict:

| Term | Definition | Pros | Cons
| - | - | - | - |
| Strict | computes its results immediately | Expensive computations can be run at the most optimum time | Wastes CPU cycles and memory for storing/evaluating expensive compuations that are unneeded/unused |
| Lazy | defers compututation until its needed | Saves CPU cycles and memory: unneeded/unused computations are never computed | When computations will occur every time, this adds unneeded overhead

To make something lazy, we add `Unit ->` in front of it. This is called a `thunk`: a computation that we know how to do but have not yet executed yet. When we are ready to execute it, we call it `forcing the thunk`.
```purescript
strictlyCompute :: Int -> Int
strictlyCompute x = x + 4

-- otherwise known as 'thunking'
lazilyCompute :: Int -> (Unit -> Int)
lazilyCompute x = (\_ -> x + 4)

forceThunk :: (Unit -> Int) -> Int
forceThunk thunk = thunk unit

-- somewhere in our code
thunk = lazyComputation 5

-- somewhere else in our code, when we finally need it
result = forceThunk thunk
```
