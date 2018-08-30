# Basic Aff Functions

## Aff Overview

Before showing what you the equivalent version of our program using `Aff`, let's first overview some of its concepts, so that it's easier to understand the upcoming code.

`Aff` as an effect monad must support the following features to be truly asynchronous:
- handles errors that may arise during its computation
- returns some computation's output
- can be cancelled if it's no longer needed

To model both errors and output, we can use either `Maybe a` or `Either a b`. Since the error might be important for some parties, `Maybe a` can't be used. Rather, we'll use `Either Error outputType`.

Handling errors and output implies a function. `Aff` uses the type signature, `Either errorType outputType -> Effect Unit`, for that.

Lastly, cancelling implies what to do when the computation is no longer needed. Since our present interests do not require cancellation, we can use a no-op Canceler: `nonCanceler`

## Functions We Will Use

For our purposes, we need an `Aff` to run inside of an `Effect` monad context. In other words, we need some function that takes an `Aff` and returns an `Effect a`. If one looks through `Aff`'s docs, the only one that does this is `runAff_`:
```purescript
runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit
```
Breaking this down, `runAff_` takes two arguments (explained in reverse):
- an `Aff` instance to run in the `Effect` monad context
- a function for handling the asynchronous computation that failed with an `Error` instance or a successful output instance, `a`.

Using it should look something like:
```purescript
runAff_ (\either -> case either of
    Left error -> log $ show error
    Right a -> -- do something with 'a' or run cleanup code
  )
  affInstance
```
We could make the code somewhat easier by using `Data.Either (either)`
```purescript
runAff_ (either
          (\error -> log $ show error )   -- left instance
          (\a -> {- usage or cleanup -} ) -- right instance
  )
  affInstance
```

Next, we need to create an `Aff` instance, hence a function that returns an `Aff a`. Looking through Pursuit again, `makeAff` is the only function that does this:
```purescript
makeAff :: forall a. ((Either Error a -> Effect Unit) -> Effect Canceler) -> Aff a
```

Breaking this down, `makeAff` takes only one argument. However, the argument is a bit quirky since it takes a function as its argument. We should read it as...

>   Given a function
>     that returns an `Effect Canceler`
>     by using the function `runAff_` requires
>       (i.e. `(Either Error a -> Effect Unit)`),
> output an `Aff a`

To create this type signature, we'll write something like this:
```purescript
affInstance :: Aff String
affInstance = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAffFunction = -- implementation
```
Since the implementation will need to return an `Effect Canceler`, we can do one of two things:
1. Lift a canceller into `Effect` via `pure`. This is pointless because then our `Aff` wouldn't do anything.
2. Create an `Effect a` and use `voidLeft` (`$>`) with `nonCanceler`

```purescript
-- for a refresher on voidLeft
voidLeft :: forall f a b. Functor f => f a -> b -> f b
voidLeft box b = (\_ -> b) <$> box

-- or ignore the monad's inner 'a' and replace it with 'b'
```

Updating our code to use these two ideas, we now have:
```purescript
affInstance :: Aff String
affInstance = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAff_RequiredFunction = (effectBox runAff_RequiredFunction) $> nonCanceler

  effectBox :: (Either Error a -> Effect Unit) -> Effect Unit
  effectBox raRF = -- implementation
```
We want to use `question` to print something to the console, get the user's input, and return that value.
It's type signature is:
```purescript
question :: String -> (String -> Effect Unit) -> Interface -> Effect String
question message handleUserINput interface = -- implementation
```
The only place we could insert `raF` is in `(String -> Effect Unit)`. Thus, we come up with this function:
```purescript
effectBox :: (Either Error String -> Effect Unit) -> Effect Unit
effectBox raRF =
  question message (\userInput -> raRF (Right userInput)) interface
                              -- (raRF <<< Right) -- less verbose; same thing
```
Putting it all together, we get:
```purescript
affInstance :: Aff String
affInstance = makeAff go
  where
  go :: (Either Error a -> Effect Unit) -> Effect Canceler
  go runAffFunction = (effectBox runAffFunction) $> nonCanceler

  effectBox :: (Either Error a -> Effect Unit) -> Effect Unit
  effectBox raRF = question message (raRF <<< Right) interface
```
