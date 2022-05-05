# Explicit Tail-Call Optimization

## An Example of Stack-Unsafe Code

In FP, we often use recursive functions to solve problems:
- changing all elements in a container-like type (e.g. `List`, `Tree`, `Array`, etc.) from one thing to another
- running some computation and, if it fails, retrying it again until it succeeds

For example, the below `factorial` function calculates its result by calling itself recursively.
```haskell
factorial :: Int -> Int
factorial n = n * (factorial (n - 1))
```

However, this design choice comes with an annoying problem: stack-safety. While this recursive function will theoretically always "return," the number of stacks it takes depends on its input. Unfortunately, computers have limited resources and cannot always provide the total number of stacks such a function needs. If we call `factorial` with a "large" enough input (e.g. `99999`), the computer will "blow the stack" and produce a StackOverflow runtime error.

So, how do we prevent this?

## Tail-Call Optimization for Pure Functions via the Last Branch

Our first defense against this is "tail-call optimization." In short, we indicate that a recursive function should be converted into a stack-friendly `while` loop. When writing simple recursive functions, we can trigger the tail-call optimization only if we call the function recursively in the final "branch." For example, if we rewrote the above computation to store the "accumulated value" as another argument to the function, then we could call the function recursively in the last branch:
```haskell
factorial :: Int -> Int
factorial n = go n 1
  where
  go :: StartingInt -> AccumulatedInt -> AccumulatedInt
  go 1 finalResult = finalResult
  go loopsRemaining accumulatedSoFar =
    go (loopsRemaining - 1) (loopsRemaining * accumulatedSoFar)
```
If we called `factorial 4`, this is how the code would execute where each line is another loop in the `while` loop:
```
go 4 1
go (4 - 1) (4 * 1)
go (4 - 1 - 1) (3 * 4 * 1)
go (4 - 1 - 1 - 1) (2 * 3 * 4 * 1)
go (4 - 1 - 1 - 1 - 1) (1 * 2 * 3 * 4 * 1)
go (1) (24)
24
```

## Tail-Call Optimization for Pure Functions via Multiple Branches

The above recursive function is stack-safe only because the recursion occurs once in the last pattern match branch. However, what if we had multiple branches where we needed to call it recursively? In such situations, the tail-call optimization won't be triggered.

Recursive functions always have a "base case" that ends the recursion and a "recursive case" that continues it. In PureScript, we use a special function called [`tailRec`](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#v:tailRec) alongside of a data type called `Step` to achieve stack-safety at the cost of some performance. `Step` indicates whether our function has finished (base case) or needs to continue looping (recursive case):
```haskell
data Step accumulatedValue finalValue
  -- recursive case: keep looping
  = Loop accumulatedValue
  -- base case: we're done; it's time to return a value
  | Done finalValue
```

Here is our previous stack-safe `factorial` function:
```haskell
factorial :: Int -> Int
factorial n = go n 1
  where
  go :: StartingInt -> AccumulatedInt -> AccumulatedInt
  go 1 finalResult = finalResult
  go loopsRemaining accumulatedSoFar =
    go (loopsRemaining - 1) (loopsRemaining * accumulatedSoFar)
```

Here is the same implementation via `tailRec`:
```haskell
factorial :: Int -> Int
factorial n = tailRec go { loopsRemaining: n, accumulatedSoFar: 1 }
  where
  go ::      { loopsRemaining :: Int, accumulatedSoFar :: Int }
     -> Step { loopsRemaining :: Int, accumulatedSoFar :: Int } Int
  go { loopsRemaining: 1,         accumulatedSoFar: acc } = Done acc
  go { loopsRemaining: remaining, accumulatedSoFar: acc } =
    Loop { loopsRemaining: remaining - 1, accumulatedSoFar: remaining * acc }
```

Let's write the same function but utilize more branches without losing stack-safety. In the below example, if one calls `factorial 1`, `factorial 2`, or `factorial 3`, the function will return in one "loop." If one calls `factorial n` where `n` is greater than 3, the function will return in 2 less loops than our previous implementation at the cost of more checks per loop:
```haskell
factorial :: Int -> Int
factorial n = tailRec go { loopsRemaining: n, accumulatedSoFar: 1 }
  where
  go ::      { loopsRemaining :: Int, accumulatedSoFar :: Int }
     -> Step { loopsRemaining :: Int, accumulatedSoFar :: Int } Int
  go { loopsRemaining: 1,         accumulatedSoFar: acc } = Done acc
  go { loopsRemaining: 2,         accumulatedSoFar: acc } = Done (2 * acc)
  go { loopsRemaining: 3,         accumulatedSoFar: acc } = Done (6 * acc)
  go { loopsRemaining: remaining, accumulatedSoFar: acc } =
    Loop { loopsRemaining: remaining - 1, accumulatedSoFar: remaining * acc }
```

## Tail-Call Optimization for Monadic Computations

But what happens when we need to run a side-effectful monadic computation recursively? For example, let's say we wanted to print the same message to the console a specific number of times and then stop:
```haskell
printMessageAndLoop :: Int -> Effect Unit
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
```haskell
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
```haskell
printMessageAndLoop :: Effect Unit
printMessageAndLoop 0 = pure unit
printMessageAndLoop loopsRemaining = do
  log "Printing a message to the console!"
  printMessageAndLoop (loopsRemaining - 1)

main :: Effect Unit
main = printMessageAndLoop 10000
```
Now our modified stack-safe code:
```haskell
printMessageAndLoop ::              { loopsRemaining :: Int }
                    -> Effect (Step { loopsRemaining :: Int } Unit )
printMessageAndLoop 0 = pure (Done unit)
printMessageAndLoop { loopsRemaining } = do
  log "Printing a message to the console!"
  pure (Loop { loopsRemaining: loopsRemaining - 1 })

main :: Effect Unit
main = tailRecM printMessageAndLoop { loopsRemaining: 10000 }
```

### Using `PureScript-Safely`

Let's say you wrote some recursive code and then later realized that it's not stack-safe. Let's also say that you have to use `MonadRec` to make it stack-safe. If you want to make the code stack-safe without modifying it, you could use the [`purescript-safely`](https://pursuit.purescript.org/packages/purescript-safely/4.0.0) library.

As `@hdgarrood` points out:

> The benefit is that you can take existing code which uses monadic recursion in a potentially stack-unsafe way and have it work without having to modify that code. ([source](https://discourse.purescript.org/t/how-to-avoid-stack-overflow-with-monads/1209/13))

For example, see [safely](https://pursuit.purescript.org/packages/purescript-safely/4.0.0/docs/Control.Safely#v:safely).

However, this comes with a tradeoff. `@hdgarrood` also states:

> [purescript-safely] is probably one of the simplest ways of making a recursive monadic computation stack-safe, but probably has some of the highest overheads too. ([source](https://discourse.purescript.org/t/how-to-avoid-stack-overflow-with-monads/1209/8))

### Three Caveats of Using `tailRecM`

There are two main drawbacks to `MonadRec`:
- Performance: there's additional overhead because we have to box and unbox the `Loop`/`Done` data constructors
- Support: as `MonadRec`'s documentation implies, not all monadic types support tail-call optimization. Only some monadic types can do this.

The third caveat is that `tailRecM` isn't always heap-safe. Responding to another's question in the PureScript chatroom:
> the `tailRecM` basically moves the stack usage you'd usually get for recursion onto the heap. If you use too much, you run out of heapspace. I'd suggest taking a heap snapshot before [your code] explodes (I think there's an `--inspect` flag for node) and seeing what's taking up that space.
> If it's the JSON structure you're building up, you'll need to write it out in chunks, so you can free up some memory for your process. Or if it's the `tailRecM` allocations, you can look into not using `tailRecM` and using `Ref`s + `whileE`/`forE` to write `Effect` code that doesn't hold on to thunks.

We'll cover the `Ref`s + `whileE`/`forE` in a later section.

## Use `Trampoline`

Another solution is to use laziness. **Note: this approach still trades stack for heap and is possibly head-unsafe.**

You'll "suspend" the computation in a "thunk" (i.e. `let thunk = \_ -> valueWeNeed`) that we can later evaluate by "forcing the thunk" (i.e. `thunk unit`). Such a solution is provided via [`Trampoline`](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Trampoline#t:Trampoline)

Putting it into more familiar terms:

| `Step a b` data constructor | `Trampoline`'s corresponding function |
| - | - |
| `Done finalValue` | `done finalValue` |
| `Loop accumulator` | `delay \_ -> accumulator` |

Similarly, `tailRecM` corresponds to `runTrampoline`.

## Use Mutable State (`Ref`s) and `whileE`/`untilE`/`forE`

As the previous comment suggested, you might want to call a spade a spade and just admit that you need to use mutable state. In such a situation, look at...
- the [`Ref`](https://pursuit.purescript.org/packages/purescript-refs/4.1.0/docs/Effect.Ref#t:Ref) type and its related functions
- [`whileE`](https://pursuit.purescript.org/packages/purescript-effect/2.0.1/docs/Effect#v:whileE)
- [`untilE`](https://pursuit.purescript.org/packages/purescript-effect/2.0.1/docs/Effect#v:untilE)
- [`forE`](https://pursuit.purescript.org/packages/purescript-effect/2.0.1/docs/Effect#v:forE)

## A Note on `Aff`

`Aff` is stack-safe by default. So, we don't need to pay for the overhead of `Step`.
