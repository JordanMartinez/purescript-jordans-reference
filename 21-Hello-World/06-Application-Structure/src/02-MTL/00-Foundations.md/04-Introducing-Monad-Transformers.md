# Introducing Monad Transformers and Capabilities

When we initially covered the original monadic function, `(a -> b)`, we discovered that it's "do notation" could be read like this:
```purescript
produceValue = someComputation 4
  where
  someComputation = do
    five <- (\four -> 1 + four)
    three <- (\fourAgain -> 7 - fourAgain)
    two <- (\fourOnceMore -> 13 + fourOnceMore - five * three)
    (\fourTooMany -> 8 - two + three)
```

The above computation demonstrates something important: the argument, `4`, passed to `someComputation` is always available in its do notation despite the argument, `4`, never appearing as an argument in `someComputation`'s definition.
```purescript
-- In other words, we have this...
someComputation = do
  -- code...

-- ... not this...
someComputation argumentThatIsFour = do
  -- some code
```

The normal `(a -> b)` function allows us to reference the argument we pass into the function at any point in its do notation. Unfortunately, since the return value of that function is `b`, we are limited to only writing pure code. In other words, `someComputation` can never interact with the outside world.

But what happens if we use the `OutputMonad`/`(a -> monad b)` function? Since it outputs a monadic data type, what if that monadic data type was `Effect` or `Aff`? If so, our code would look like something below, definitely not readable.

```purescript
produceComputation = runOutputEffect someComputation 4
  where                                                                     {-
  someComputation :: OutputMonad a   m      b                               -}
  someComputation :: OutputMonad Int Effect String
  someComputation = do
    five <- (\four -> pure $ 1 + four)
    three <- (\fourAgain -> pure $ 7 - fourAgain)
    intBetween0And2 <- (\fourOnceMore -> randomInt 0 $ 13 + fourOnceMore - five)
    (\fourTooMany -> log $ show $ 8 - intBetween0And2)
```

But what if we expressed the same idea using capabilities via type class constraints? This is the same code as above:
```purescript
produceComputation = runOutputMonad someComputation 4
  where
  someComputation :: forall m. Monad m =>
                     MonadReader Int m =>
                     MonadEffect m =>
                     m String
  someComputation = do
    four <- ask
    let five = 1 + four
    let three = 7 - four
    intBetween0And2 <- liftEffect $ randomInt 0 $ 13 + four - five
    liftEffect $ log $ show $ 8 - intBetween0And2
```

This is the whole point of using monadic functions that output monadic data types: **they allow us to encode all of our business logic as one massive pure function.**

| If the underlying outputted monadic data type is... | then running our code will ...
| - | - |
| `Effect`/`Aff`<br>("impure" monads) | execute a program |
| `Box`<br>("pure" monad) | allow us test our business logic |

With one monad, we can prove that our business logic works as expected and does not have any bugs, and with another monad, we can execute that same business logic as a useful program.

Thus, monadic functions that return other monadic data types (i.e. `a -> m b`) are called "Monad Transformers" because they transform (or augment) the monad with additional capabilities. They are the "implementation" that makes all of this work.

However, we use type classes like `MonadReader`, `MonadState`, `MonadWriter`, etc. to express that a given computation can only be run if their implementation can satisfy the required capabilities.

In short, we use type classes above to "write" our business logic and monad transformers to "run" our business logic.

## Introducing `ReaderT`

`OutputMonad` is better known as [`ReaderT`](https://pursuit.purescript.org/packages/purescript-transformers/4.2.0/docs/Control.Monad.Reader.Trans#t:ReaderT).

It's corresponding type class is [`MonadReader`](https://pursuit.purescript.org/packages/purescript-transformers/4.2.0/docs/Control.Monad.Reader.Class)

To see how this works in practice, see the natural "evolution" one would take to use it: [the Monad Reader Example](https://gist.github.com/rlucha/696ca604c9744ad11aff7d46b1706de7)
