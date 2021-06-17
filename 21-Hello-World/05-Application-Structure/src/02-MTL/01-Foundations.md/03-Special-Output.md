# Special Output

Previously, we wrote the instances for a normal `(a -> b)` function. But this is only one possible function! What if we modified that function, so that it outputted something different than just `b`? The reader might ask, "But if `map`, `apply`, `pure`, and `bind` all require the output/`b` type to be polymorphic (i.e. it should work for all `b`s), what type could we possibly return?"

Since `b` must still be polymorphic, why don't we wrap it in a higher-kinded type? For example, why not change `(a -> b)` to `(a -> Box b)`? How would we implement those type class instances?

## Newtyping our `Function`

If our goal is to write instances for the function, `(a -> Box b)`, how can we ensure this function's type signature never changes? We can wrap the function in a newtype:
```haskell
newtype OutputBox a b = OutputBox (a -> Box b)
```
This creates a new problem. When we originally evaluated a monadic function, we could pass the value to the function without problem: `produceValue = someComputation 4`.

Since our above function is now wrapped in a newtype, we need a way to easily unwrap the newtype and pass the argument to the function. Why don't we create a function called `runOutputBox` to do just that?
```haskell
runOutputBox :: forall a b. OutputBox a b -> a -> Box b
runOutputBox (OutputBox function) argument = function argument
```

Now we're ready to implement instances for `OutputBox`

## Functor

### Implementing `map`

Let's look at `Functor` again.
```haskell
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b
```

Following the same idea as before, we can convert `m` into `OutputBox input` and get this type signature:
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = -- implementation
```

Let's see how to implement it.

1. Since `map` returns an `OutputBox` type, let's start by first creating a newtype constructor:
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox
```

2. The type, `OutputBox`, wraps a function, so let's use lambda syntax to create a new one:
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox (\input -> {- body of function -})
```

3. Since `f` is the only argument that can receive the `input` value, let's pass `input` into `f` and store its output in a let binding:
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox (\input ->
    let boxStoringOriginalOutput = f input
    in {- body of function -})
```

We have a problem. Do you know what it is? `OutputBox a b` is really `(a -> Box b)`. So, `f` in the code above produces a value of the type, `Box originalOutput`.

Hmm... When we defined `map` for `Function input`, we could pass `originalOutput` directly into `originalToNew` at this point. However, `originalOutput` is currently stuck inside of `Box`. So, we have two questions.
1. How do we get `originalOutput` out of the `Box`?
2. Once we get a value of the desired type, `newOutput`, how do we stick it back into the `Box`?

In other words, our situation can be expressed in a type signature:
```haskell
someFunction :: Box originalOutput -> Box newOutput
```

Wait! Doesn't that look very similar to `Functor`'s `map`?
```haskell
map :: (originalOutput -> newOutput) -> Box originalOutput -> Box newOutput
```

And isn't `originalToNew` a function with this exact type signature: `(originalOutput -> newOutput)`? And doesn't `Box` itself have an instance for `Functor`.

4. Use `Box`'s `map` to finish implementing the function.
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox (\input ->
    let boxStoringOriginalOutput = f input
    in map originalToNew boxStoringOriginalOutput
    )
```

Great! Let's clean it up by inlining `boxStoringOriginalOutput`.
```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox (\input ->
      map originalToNew (f input)
    )
```

### Takeaways

Lessons we learned in this example:
- to implement `Functor` for `(a -> Box b)`, we needed to use `Box`'s `Functor` instance.

## Apply

Let's now look at `Apply`.
```haskell
class (Functor f) <= Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b
```

Our function will have this type signature:
```haskell
instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = -- implementation
```

1. As before, let's implement the shell of our return type: a newtype wrapper around a function created using lambda syntax:
```haskell
instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = OutputBox (\input ->
      {- body of function -}
    )
```

2. Let's pass `input` into `f`:
```haskell
instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = OutputBox (\input ->
      let boxStoringOriginalOput = f input
      in {- body of function -}
    )
```

3. Let's pass `input` into `inputToFunction` to expose function:
```haskell
instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = OutputBox (\input ->
      let
        boxStoringOriginalOutput = f input
        boxStoringOriginalToNew = inputToFunction input
      in {- body of function -}
    )
```

Hmm... This seems similar to what happened before. We have two boxes that are both storing values. When we tried implementing the `Functor` instance for our function, we used `Box`'s `Functor` definition. If we look at the types of our `Box`es, we'll see that this coincidence applies here, too. `boxStoringOriginalToNew` has type, `Box (originalOutput -> newOutput)` while `boxStoringOriginalOutput` has type, `Box originalOutput`. So, let's use `Box`'s `Apply` instance to finish the funciton!

```haskell
instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = OutputBox (\input ->
      let
        boxStoringOriginalOutput = f input
        boxStoringOriginalToNew = inputToFunction input
      in apply boxStoringOriginalToNew boxStoringOriginalOutput
    )
```

### Takeaways

Lessons we learned in this example:
- to implement `Apply` for `(a -> Box b)`, we needed to use `Box`'s `Apply` instance.

## Applicative

You've probably noticed a pattern by now. To implement a type class for our function, we need to use `Box`'s corresponding instance for that type class.

We'll do this one quickly.

```haskell
class (Apply f) <= Applicative f where
  pure :: forall a. a -> f a


instance (Apply (OutputBox input)) <= Applicative (OutputBox input) where
  pure :: forall a. a -> (OutputBox input) a
  pure value = OutputBox (\_ -> pure value {- Box's `pure` -})
```

## Bind

We'll do this one a bit more slowly.

```haskell
class (Apply m) <= Bind m where
  bind :: forall a b. m a -> (a -> m b) -> m b

-- convert `f` into `OutputBox input`
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = -- implementation

-- Write the initial newtype constructor wrapping a function created
-- via lambda syntax
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = OutputBox (\input ->
      {- body of function -}
    )

-- expose the `boxOriginalOutput` value
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = OutputBox (\input ->
      let boxOriginalOutput = inputToOriginal input
      in {- body of function -}
    )

-- use `Box`'s `bind` to reveal `originalOutput`
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = OutputBox (\input ->
      let boxOriginalOutput = inputToOriginal input
      in bind boxOriginalOutput (\originalOutput ->
           {- body of function -}
         )
    )

-- pass `originalOutput` into `originalToFunction`
-- and use pattern matching to expose the function wrapped in the `OutpuBox`
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = OutputBox (\input ->
      let boxOriginalOutput = inputToOriginal input
      in bind boxOriginalOutput (\originalOutput ->
           let (OutputBox inputToNew) = originalToFunction originalOutput
           in {- body of function -}
         )
    )

-- pass `input` into `inputToNew`, which produces `Box newOutput` and
-- satisfies the type signature of `bind`.
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction = OutputBox (\input ->
      let boxOriginalOutput = inputToOriginal input
      in bind boxOriginalOutput (\originalOutput ->
           let (OutputBox inputToNew) = originalToFunction originalOutput
           in inputToNew input
         )
    )
```

If we were to clean up the finished code above, we would write this:
```haskell
instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction =
    OutputBox (\input -> do
      originalOutput <- inputToOriginal input
      let (OutpuBox inputToNew) = originalToFunction originalOutput
      inputToNew input
    )
```

## Generalizing `Box` to any `Monad`

If we look at our final instances below (they were copied from above), we'll see that we never once used `Box` explicitly. Rather, we could have replaced `Box` with any monadic data type and we would still be able to implement instances of these type class' functions that satisfy their type signatures.

```haskell
instance Functor (OutputBox input) where
  map :: forall originalOutput newOutput.
         (originalOutput -> newOutput) ->
         OutputBox input originalOutput ->
         OutputBox input newOutput
  map originalToNew (OutputBox f) = OutputBox (\input ->
      map originalToNew (f input)
    )

instance (Functor (OutputBox input)) <= Apply (OutputBox input) where
  apply :: forall originalOutput newOutput.
           OutputBox input (originalOutput -> newOutput) ->
           OutputBox input originalOutput ->
           OutputBox input newOutput
  apply (OutputBox inputToFunction) (OutputBox f) = OutputBox (\input ->
      let
        boxStoringOriginalOutput = f input
        boxStoringOriginalToNew = inputToFunction input
      in apply boxStoringOriginalToNew boxStoringOriginalOutput
    )

instance (Apply (OutputBox input)) <= Applicative (OutputBox input) where
  pure :: forall a. a -> (OutputBox input) a
  pure value = OutputBox (\_ -> pure value)

instance (Apply (OutputBox input)) <= Bind (OutputBox input) where
  bind :: forall originalOutput newOutput.
          OutputBox input originalOutput ->
          (originalOutput -> OutputBox input newOutput) ->
          OutputBox input newOutput
  bind (OutputBox inputToOriginal) originalToFunction =
    OutputBox (\input -> do
      originalOutput <- inputToOriginal input
      let (OutpuBox inputToNew) = originalToFunction originalOutput
      inputToNew input
    )
```

If we were to generalize our function to a monad, it would look like this:
```haskell
newtype OutputMonad a m b = (a -> m b)

runOutputMonad :: forall m a b. Monad m => OutputMonad a m b -> a -> m b
runOutputMonad (OutputMonad function) arg = function arg
```
