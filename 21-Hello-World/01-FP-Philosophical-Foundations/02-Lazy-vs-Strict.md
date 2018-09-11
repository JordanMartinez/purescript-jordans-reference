# Lazy vs Strict

A computation can either be lazy or strict:
| Term | Definition | Pros | Cons
| - | - | - | - |
| Strict | computes its results immediately | Expensive computations can be run at the most optimum time | Wastes CPU cycles and memory for storing/evaluating expensive compuations that are unneeded/unused |
| Lazy | defers compututation until its needed | Saves CPU cycles and memory: unneeded/unused computations are never computed | When computations will occur every time, this adds unneeded overhead

To make something lazy, we add `Unit ->` in front of it.
```purescript
strictComputation :: Int -> Int
strictComputation x = x + 4

lazyComputation :: Int -> (Unit -> Int)
lazyComputation x = (\_ -> x + 4)

-- somewhere in our code
needsUnitToReturn = lazyComputation 5

-- somewhere else in our code, when we finally need it
result = needsUnitToReturn unit
```
