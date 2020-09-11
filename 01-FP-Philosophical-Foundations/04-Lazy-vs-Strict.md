# Lazy vs Strict

A computation can either be lazy or strict. Before giving the below table, let's give a real-life example.

This is "Strict evaluation." Your parent tells you to _immediately_ do some chore (e.g. wash dishes, etc.). You go and do so. Sometimes, you learn that this was necessary. Other times, you learn that the dishes were already washed by someone else. Despite telling your parent that they don't need to be washed, your parent insists and overrules you. This especially annoys you on days where "washing the dishes" will take a long time.

This is "Lazy evaluation." Your parent tells you to _remember_ to do some chore but not to start until they tell you. On some days, they never tell you to start because the task wasn't needed after all. You love those days. On other days, they tell you to start in the morning, the afternoon, or the evening.

| Term | Definition | Pros | Cons
| - | - | - | - |
| Strict | computes its results immediately | Expensive computations can be run at the most optimum time | Wastes CPU cycles and memory for storing/evaluating expensive computations that are unneeded/unused |
| Lazy | defers computation until its needed | Saves CPU cycles and memory: unneeded/unused computations are never computed | When computations will occur every time, this adds unneeded overhead

To make something lazy, we turn it into a function. This function takes one argument (`Unit`) and returns the value we desire. This is called a `thunk`: a computation that we know how to do but have not executed yet. To run the code stored in the `thunk`, we use the phrase `forcing the thunk`.
```haskell
-- Given an Int, I can return another Int
strictlyCompute :: Int -> Int
strictlyCompute x = x + 4

-- otherwise known as 'thunking'
-- Given an Int, I can return a 'thunk.' When
-- this thunk is evaluated, it will return an Int.
lazilyCompute :: Int -> (Unit -> Int)
lazilyCompute x = (\unitValue__neverUsed -> x + 4)

forceThunk :: (Unit -> Int) -> Int
forceThunk thunk = thunk unit

-- somewhere in our code
thunk = lazilyCompute 5

-- somewhere else in our code, when we finally need it
result = forceThunk thunk
```

## Other Resources

- This resource is not necessary for you to read it to understand and use PureScript. However, it might satisfy those who are curious. It uses the Lisp language in its examples, so the code might be difficult to understand. Regardless, the book **Structure and Interpretation of Computer Programs (SICP)** (see [this](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html) or [that](https://sarabander.github.io/sicp/)) has [a chapter on lazy evaluation and thunks](https://sarabander.github.io/sicp/html/4_002e2.xhtml).
