# Basic Aff Functions

In this file, we'll show the second way to run an `Aff` computation called `runAff` and how to convert `Node.ReadLine`'s `question` function (i.e. an `Effect`-based function that requires a callback) into an `Aff`-based computation using `makeAff`.

## Aff Overview

Let's first overview some of `Aff`'s concepts, so that the upcoming code is easier to understand. To be a truly asynchronous effect monad, `Aff` must support the following features:
- handles errors that may arise during its computation
- returns some computation's output
- can be cancelled if it's no longer needed

To model the possibility for a computation to return an error or actual output, we can use `Either a b`. Handling errors and output implies a function. `Aff` uses the type signature, `Either errorType outputType -> Effect Unit`, for that.

Lastly, cancelling implies what to do when the computation is either no longer needed or it has failed (but we aren't using the function just discussed above). As an example, one will use `Canceler`s to clean up resources (e.g. `clearTimeout`).

```haskell
newtype Canceler = Canceler (Error -> Aff Unit)
```

Since our present interests do not require cancellation, we can use a no-op `Canceler`: `nonCanceler`

## Understanding `runAff`

For our purposes, we need an `Aff` to run inside of an `Effect` monadic context. If one looks through `Aff`'s docs, the only one that does this besides `launchAff` and its variants is `runAff_`:
```haskell
runAff_ :: forall a.
           (Either Error a -> Effect Unit) ->  -- arg 1
           Aff a ->                            -- arg 2
           Effect Unit                         -- outputted value
```
Breaking this down, `runAff_` takes two arguments (explained in reverse):
- an `Aff` computation to run
- a function for handling a possible asynchronous `Error` if the computation fails or the computation's output, `a`, if it succeeds.

Using it should look something like:
```haskell
runAff_ (\either -> case either of
    Left error -> log $ show error
    Right a -> -- do something with 'a' or run cleanup code
  )
  affValue
```
We could make the code somewhat easier by using `Data.Either (either)`
```haskell
runAff_ (either
          (\error -> log $ show error   ) -- Left value
          (\a -> {- usage or cleanup -} ) -- Right value
  )
  affValue
```

## Understanding `makeAff`

Next, we need to convert `question` from an `Effect`-based computation into an `Aff`-based one. Looking through Pursuit again, `makeAff` is the only function that does this:
```haskell
makeAff :: forall a. ((Either Error a -> Effect Unit) -> Effect Canceler) -> Aff a
```

Breaking this down, `makeAff` takes only one argument. However, the argument is a bit quirky since it takes a function as its argument. We should read it as...

```
  Given a function
    that returns an `Effect Canceler`
    by using the function that `runAff_` requires
      (i.e. `(Either Error a -> Effect Unit)`),
output an `Aff` computation that produces a value of type `a` when `bind`ed
```

To create this type signature, we'll write something like this:
```haskell
affValue :: Aff String
affValue = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAff_RequiredFunction = -- implementation
```
Since the implementation will need to return an `Effect Canceler`, we can do one of two things:
1. Lift a canceller into `Effect` via `pure`. This is pointless because then our `Aff` wouldn't do anything.
2. Create an `Effect a` and use Functor's dervied function, `voidRight` (`<$`), with `nonCanceler`

```haskell
-- for a refresher on voidRight
2 `voidRight` (Box 1) == 2 <$ (Box 1) == (Box 2)

-- alias is: "<$"
voidRight :: forall f a b. Functor f => b -> f a -> f b
voidRight b box = (\_ -> b) <$> box

-- or ignore the monad's inner 'a' and replace it with 'b'
```

Updating our code to use these two ideas, we now have:
```haskell
affValue :: Aff String
affValue = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAff_RequiredFunction = nonCanceler <$ (effectBox runAff_RequiredFunction)

  effectBox :: (Either Error a -> Effect Unit) -> Effect Unit
  effectBox runAffFunction = -- implementation
```
We want to use `question` to print something to the console, get the user's input, and return that value. It's type signature is:
```haskell
question :: String -> (String -> Effect Unit) -> Interface -> Effect String
question message handleUserInput interface = -- Node binding implementation
```
The only place we could insert `runAffFunction` is in `(String -> Effect Unit)`. Thus, we come up with this function:
```haskell
effectBox :: (Either Error String -> Effect Unit) -> Effect Unit
effectBox runAffFunction =
  question message (\userInput -> runAffFunction (Right userInput)) interface
                              -- (runAffFunction <<< Right) -- less verbose; same thing
```
Putting it all together and excluding the required arguments, we get:
```haskell
affValue :: Aff String
affValue = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAff_RequiredFunction = nonCanceler <$ (effectBox runAff_RequiredFunction)

  effectBox :: (Either Error a -> Effect Unit) -> Effect Unit
  effectBox runAffFunction = question message (runAffFunction <<< Right) interface
```
Cleaning it up and including the arguments, we get:
```haskell
affQuestion :: String -> Interface -> Aff String
affQuestion message interface = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAffFunction =
    nonCanceler <$ question message (runAffFunction <<< Right) interface
```
