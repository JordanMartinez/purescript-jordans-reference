# Introducing Monad Transformers and Capabilities

## Comparing `Function input output` to `OutputBox input output`

When we initially covered the original monadic function, `(a -> b)`, we discovered that it's "do notation" could be read like this:
```haskell
produceValue = someComputation 4
  where
  someComputation = do
    five <- (\four -> 1 + four)
    three <- (\fourAgain -> 7 - fourAgain)
    two <- (\fourOnceMore -> 13 + fourOnceMore - five * three)
    (\fourTooMany -> 8 - two + three)
```

The above computation demonstrates something important: the argument, `4`, passed to `someComputation` is always available in its do notation despite the argument, `4`, never appearing as an argument in `someComputation`'s definition.
```haskell
-- In other words, we have this...
someComputation = do
  -- code...

-- ... not this...
someComputation argumentThatIsFour = do
  -- some code
```

The normal `(a -> b)` function allows us to reference the argument we pass into the function at any point in its do notation. Unfortunately, since the return value of that function is `b`, we are limited to only writing pure code. In other words, `someComputation` is a computation that can never interact with the outside world.

But what happens if we use the `OutputMonad`/`(a -> monad b)` function? Since it outputs a monadic data type, what if that monadic data type was `Effect` or `Aff`? If so, the resulting code would be very hard to read:

```haskell
produceComputation = runOutputEffect someComputation 4
  where                                                                     {-
  someComputation :: OutputMonad a   m      b                               -}
  someComputation :: OutputMonad Int Effect String
  someComputation = do
    five <- (\four -> pure $ 1 + four)
    three <- (\fourAgain -> pure $ 7 - fourAgain)
    intBetween0And12 <- (\fourOnceMore -> randomInt 0 $ 13 + fourOnceMore - five)
    (\fourTooMany -> log $ show $ 8 - intBetween0And12)
```

But what if we expressed the same idea using capabilities via type class constraints? This is the same code as above:
```haskell
produceComputation = runOutputMonad someComputation 4
  where
  someComputation :: forall m. Monad m =>
                     MonadReader Int m =>
                     MonadEffect m =>
                     OutputMonad Int m String
  someComputation = do
    four <- ask
    let five = 1 + four
    let three = 7 - four
    intBetween0And12 <- liftEffect $ randomInt 0 $ 13 + four - five
    liftEffect $ log $ show $ 8 - intBetween0And12
```

## Introducing `ReaderT`

To see this from a slighty different angle, we'll cover a few things before linking to an example showing how a computation "evolves" into the `Reader` monad.

`OutputMonad` is better known as `ReaderT`:
- when `ReaderT`'s monadic type is a real monad, we call it [`ReaderT`](https://pursuit.purescript.org/packages/purescript-transformers/4.2.0/docs/Control.Monad.Reader.Trans#t:ReaderT)
- when `ReaderT`'s monadic type is `Identity` (placeholder monadic type), we call it [`Reader`](https://pursuit.purescript.org/packages/purescript-transformers/4.2.0/docs/Control.Monad.Reader).

It's corresponding type class is [`MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.2.0/docs/Control.Monad.Reader.Class).

Watch a computation "evolve" into the `Reader` monad in [the Monad Reader Example](https://gist.github.com/rlucha/696ca604c9744ad11aff7d46b1706de7).

## Monad Transformers Summarized

### The Main Idea

This is the whole point of using monadic functions that output monadic data types: **they allow us to encode all of our business logic as one massive pure function.**

| If the underlying outputted monadic data type is... | then running our code will ...
| - | - |
| `Effect`/`Aff`<br>("impure" monads) | execute a program |
| `Identity`^/`Trampoline`^^<br>("pure" monad) | allow us test our business logic |

^ `Identity` is what you get if `Box` was a newtype rather than data. In other words, `newtype Identity a = Identity a`. `identity` is a function that returns as output its input. Thus, it's often used as a "placeholder" / `mempty` function value. Similarly, `Identity a` is a type that reduces to the `a` type at runtime. Thus, it's often used as a "placeholder" / `mempty`-like monadic type.
^^ `Trampoline` is a monad that we haven't introduced yet.

With one monad, we can prove that our business logic works as expected and does not have any bugs, and with another monad, we can execute that same business logic as a useful program.

This helps us understand the name behind "Monad Transformers". Monadic functions that return other monadic data types (i.e. `a -> m b`) are called "Monad Transformers" because they transform (or augment) the base monad with additional capabilities. They are the "implementation" that makes all of this work.

However, we use type classes like `MonadReader`, `MonadState`, `MonadWriter`, etc. to express that a given computation can only be run if their implementation can satisfy the required capabilities.

In short, we use type classes above to "write" our business logic and monad transformers to "run" our business logic.

### Breaking It Down

First, there is a type class that indicates that some underlying monad has the **capability** to do some effect (e.g. state manipulation via `MonadState`).

Second, there is a default implementation for that class via a monadic newtyped function (e.g. `ReaderT`). As we will see later, such functions add in specific effects, reduce some of the syntax boilerplate one might write, and make impossible states impossible.
When we wish to transform some other monad, we use the newtyped monadic functions that end with `T` as in "transformer" (e.g. `ReaderT`). However, if we don't want to transform a monad (i.e. just use `Identity` to act as a placeholder monadic type), then we remove that `T` (e.g. `Reader`).

Third, the general pattern (there are exceptions!) that we will see reappear when overviewing the other Monad Transformers:
- There is a type class called `Monad[Word]` where `[Word]` clarifies what functions the type class provides. This type class indicates that some underlying monad has some **capability**.
- There is a single default implementation for `Monad[Word]` called `[Word]T`. When the monad type is specialized to `Identity`, it's simply called `[Word]`.
- To run a computation using `Monad[Word]`, we must use either `run[Word] computation arg` (i.e. the monad is `Identity`) or `run[Word]T computation arg` (i.e. a non-`Identity` monad).

Putting it into a table, we get this.

| Type Class | Sole Implementation<br>(`m` is real monad)<br><br>function that runs it | Sole Implementation<br>(`m` is `Identity`)<br><br>function that runs it |
| - | - | - |
| `Monad[Word]`<br>(General Pattern) | `[Word]T`<br><br>`run[Word]T` | `[Word]`<br><br>`run[Word]` |
| `MonadState` |  `StateT`<br><br>`runStateT` | `State`<br><br>`runState` |
| `MonadReader` | `ReaderT`<br><br>`runReaderT` | `Reader`<br><br>`runReader` |
| `MonadWriter` | `WriterT`<br><br>`runWriterT` | `Writer`<br><br>`runWriter` |
| `MonadCont` | `ContT`<br><br>`runCont` | `Cont`<br><br>`runCont` |
| `MonadError` | `ExceptT`<br><br>`runExceptT` | `Except`<br><br>`runExcept` |

To summarize each monad transformer, we'll use another table. **The below terms for "pure" and "impure" refer to whether the computations can interact with the real world.**:

| A basic function... | ... is used to run a **pure** computation ... | can be "upgraded" to a monad transformer... | ... which is used to run an **impure** computation ... |
| - | - | - | - |
| `input -> output` | that depends on its input | `globalValue -> monad outputThatUsesGlobalValue`<br><br>`ReaderT` | that depends on some global configuration
| `state -> Tuple output state` | that does state manipulation | `oldState -> monad (Tuple (output, newState))`<br><br>`StateT` | that does state manipulation
| `function $ arg` | once an argument is fully computed | `\function -> output`<br><br>`ContT` | and periodically use a function passed in as an argument to compute something |

Some monad transformers just specify what their output type will be:

| A basic return value... | ... that is used to run a **pure** computation ... | ... can be put into a Monad and become a monad transformer... | ... which is used to run an **impure** computation ... |
| - | - | - | - |
| `Tuple output additionalOutput` | that also produces additional output | `monad (Tuple (output, accumulatedValue)`<br><br>`WriterT` | that produces accumulated data as additional output |
| `Either e a` | that handles partial functions | `monad (Either e a)`<br><br>`ExceptT` | that may fail and the error matters
| `Maybe a` | that might not return a value | `monad (Maybe a)`<br><br>`MaybeT` | that might not return a value
| `List a` | that produces 0 or more values | `monad (List a)`<br><br>`ListT` | that produces 0 or more values |

Once again, the "base monad" that usually inhibits `m` in the "stack" of nested monad transformers is usually one of two things:
- `Effect`/`Aff`: impure monads that actually make our business logic useful
- `Identity`/`Free`: pure monads that test our business logic.
