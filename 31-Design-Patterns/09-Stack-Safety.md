# Stack Safety

## An Example of Stack-Unsafe Code

In FP, we often use recusive functions to solve problems:
- changing all elements in a container-like type (e.g. `List`, `Tree`, `Array`, etc.) from one thing to another
- running some computation and, if it fails, retrying it again until it succeeds

For example, the below `factorial'` function calculates its result by calling itself recursively. Just like any other recursive function, there is a "base case" that stops the recursion and a "recursive case" that continues it. We always pattern match on the "base case" before defaulting to the recursive case.
```purescript
factorial :: Int -> Int
factorial n = go n 1
  where
  go :: StartingInt -> AccumulatedInt -> AccumulatedInt
  go 1 finalResult = finalResult
  go loopsRemaining accumulatedSoFar =
    go (loopsRemaining - 1) (loopsRemaining * accumulatedSoFar)
```

However, this design choice comes with an annoying problem: stack-safety. While this recursive function will theoretically always "return," the number of stacks it takes depends on its input. Unfortunately, computers have limited resources and cannot always provide the total number of stacks such a function needs. If we call `factorial` with a "large" enough input (e.g. `99999`), the computer will "blow the stack" and produce a StackOverflow runtime error.

So, how do we prevent this?

## Tail-Call Optimization for Pure Functions

Our first defense against this is "tail-call optimization." In short, we indicate that a recursive function should be converted into a stack-friendly `while` loop. As long as we keep our function pure and side-effect free, this is no different than our above code.

In our above recursive function, we had a "base case" and a "recursive case." In PureScript, we use the data type `Step` to indicate whether our function has finished (base case) or needs to continue looping (recursive case):
```purescript
data Step accumulatedValue finalValue
  -- recursive case: keep looping
  = Loop accumulatedValue
  -- base case: we're done; it's time to return a value
  | Done finalValue
```

Then, we use a special function called [`tailRec`](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#v:tailRec) to convert our recursive function into a `while` loop.

Here is our original stack-unsafe `factorial` function:
```purescript
factorial :: Int -> Int
factorial n = go n 1
  where
  go :: StartingInt -> AccumulatedInt -> AccumulatedInt
  go 1 finalResult = finalResult
  go loopsRemaining accumulatedSoFar =
    go (loopsRemaining - 1) (loopsRemaining * accumulatedSoFar)
```

Here is our modified stack-safe `factorial` function using `tailRec`:
```purescript
factorial :: Int -> Int
factorial n = tailRec go { loopsRemaining: n, accumulatedSoFar: 1 }
  where
  go ::      { loopsRemaining :: Int, accumulatedSoFar :: Int }
     -> Step { loopsRemaining :: Int, accumulatedSoFar :: Int } Int
  go { loopsRemaining: 1,         accumulatedSoFar: acc } = Done acc
  go { loopsRemaining: remaining, accumulatedSoFar: acc } =
    Loop { loopsRemaining: remaining - 1, accumulatedSoFar: remaining * acc }
```

## Tail-Call Optimization for Monadic Computations

But what happens when we need to run a side-effectful monadic computation recursively? For example, let's say we wanted to print the same message to the console a specific number of times and then stop:
```purescript
printMessageAndLoop :: Effect Unit
printMessageAndLoop 0 = pure unit
printMessageAndLoop loopsRemaining = do
  log "Printing a message to the console!"
  printMessageAndLoop (loopsRemaining - 1)

main :: Effect Unit
main = printMessageAndLoop 10000
```

Fortunately, we can use the [`MonadRec` type class' `tailRecM` function](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#t:MonadRec).

The only change from above is that now we wrap the returned `Step` data type in the monadic type.

In other words:
```purescript
tailRec  go initialValue
  where
  go ::             Accumulator
     ->        Step Accumulator Output

-- now becomes
tailRecM go initialValue
  where
  go ::             Accumulator
     -> monad (Step Accumulator Output)
```

Once again, our original stack-unsafe code:
```purescript
printMessageAndLoop :: Effect Unit
printMessageAndLoop 0 = pure unit
printMessageAndLoop loopsRemaining = do
  log "Printing a message to the console!"
  printMessageAndLoop (loopsRemaining - 1)

main :: Effect Unit
main = printMessageAndLoop 10000
```
Now our modified stack-safe code:
```purescript
printMessageAndLoop ::              { loopsRemaining :: Int }
                    -> Effect (Step { loopsRemaining :: Int } Unit )
printMessageAndLoop 0 = pure (Done unit)
printMessageAndLoop { loopsRemaining } = do
  log "Printing a message to the console!"
  pure (Loop { loopsRemaining: loopsRemaining - 1 })

main :: Effect Unit
main = tailRecM printMessageAndLoop { loopsRemaining: 10000 }
```

### Three Caveats of Using `tailRecM`

There are two main drawbacks to `MonadRec`:
- Performance: there's additional overhead because we have to box and unbox the `Loop`/`Done` data constructors
- Support: as `MonadRec`'s documentation implies, not all monadic types support tail-call optimization. Only some monadic types can do this.

The third caveat is that `tailRecM` isn't always heap-safe. Responding to another's question on the FP Slack channel:
> the `tailRecM` basically moves the stack usage you'd usually get for recursion onto the heap. If you use too much, you run out of heapspace. I'd suggest taking a heap snapshot before [your code] explodes (I think there's an `--inspect` flag for node) and seeing what's taking up that space.
> If it's the JSON structure you're building up, you'll need to write it out in chunks, so you can free up some memory for your process. Or if it's the `tailRecM` allocations, you can look into not using `tailRecM` and using `Ref`s + `whileE`/`forE` to write `Effect` code that doesn't hold on to thunks.

## Use Mutable State (`Ref`s) and `whileE`/`forE`

As the previous comment suggested, you might want to call a spade a spade and just admit that you need to use mutable state. In such a situation, look at...
- the [`Ref`](https://pursuit.purescript.org/packages/purescript-refs/4.1.0/docs/Effect.Ref#t:Ref) type and its related functions
- [`whileE`](https://pursuit.purescript.org/packages/purescript-effect/2.0.1/docs/Effect#v:whileE)
- [`forE`](https://pursuit.purescript.org/packages/purescript-effect/2.0.1/docs/Effect#v:forE)

## Us `Trampoline`

Another solution is to use laziness. You'll "suspend" the computation in a "thunk" (i.e. `let thunk = \_ -> valueWeNeed`) that we can later evaluate by "forcing the thunk" (i.e. `thunk unit`). Such a solution is provided via [`Trampoline`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Trampoline#t:Trampoline)

Putting it into more familiar terms:

| `Step a b` data constructor | `Trampoline`'s corresponding function |
| - | - |
| `Done finalValue` | `done finalValue` |
| `Loop accumulator` | `delay \_ -> accumulator` |

Similarly, `tailRecM` corresponds to `runTrampoline`.

## A Note on `Aff`

`Aff` is stack-safe by default. So, we don't need to pay for the overhead of `Step`.
