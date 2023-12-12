# A Magical Monad

We reached these conclusions previously:
- we need `Monad`'s `bind`/`>>=` to enable multiple different state-manipulating functions to work
- we need to hide the `state` from the actual function, so that developers can't pass in the wrong state value accidentally (i.e. make impossible states impossible). This came with two implications:
    - Calling `bind`/`>>=` should return just `value`, not `Tuple value state`
    - Running the computation via `runSomeFunction` should return `Tuple value state`.

In short, we need to implement the following two functions with these type signatures:
```haskell
class (Monad m) <= MonadState state monad | monad -> state where
  state :: forall value. (state -> Tuple value state) -> monad value

runStateFunction :: forall state value.
                   (state -> Identity (Tuple value state)) ->
                    state ->
                    Tuple value state
runStateFunction stateManipulation initialState =
  let (Identity tuple) = stateManipulation initialState
  in tuple
```

## Introducing the Function Monad

What if `Function` was a `Monad`? This might sound surprising at first, but it's actually true.

Recall that a `Monad` is any type that has lawful instances for the `Functor`, `Apply`, `Applicative`, `Bind`, and `Monad` (FAABM) type classes. As long as a type can successfully implement lawful functions for them, the type can be called monadic.

How might this be possible?

First, a `Monad` has kind `Type -> Type` whereas a `Function` has kind `Type -> Type -> Type`.

We can make `Function`'s kind one less by specifying either the input type or the output type:
- `Function Int a`/`(Int -> a)` has kind `Type -> Type`
- `Function a Int`/`(a -> Int)` has kind `Type -> Type`

In other words, we need to turn `Function` into a completely new type (`data`, `type`, or `newtype`) that should only exist at compile time to reduce runtime overhead (e.g. `type` or `newtype`) that can also implement type classes (i.e. only `newtype`). Using a newtyped version of `Function`, we can specify all the types in the function:
```haskell
newtype TypedFunction input output =
  TypedFunction (input -> output)

specifiesInput :: forall a. TypedFunction Int b -- Kind: Type -> Type

specifiesOutput :: forall a. TypedFunction a Int  -- Kind: Type -> Type
```

Second, since `Function` can refer to any function, what should our newtyped function's type signature be? We'll use the state-manipulating function's type signature itself!
`(state -> monad (Tuple value state))`

We will call this the `StateT` monad. The `T` part of the name will become clearer later.

## Monadic Instances

Let's now implement the FAABM type classes by using pattern matching to expose the inner function. The `value` type will be left undefined (i.e. it's the `a` in everything), making `StateT` have the necessary kind, `Type -> Type`:

### Functor

```haskell
newtype StateT state monad value =
  StateT (state -> monad (Tuple value state))

-- Let's follow the types. We'll need to return a `StateT` value
-- so we'll start by doing that:
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT -- todo

-- Since StateT wraps a function whose only argument
-- is state, we'll add that now:
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\state ->
      -- todo
    )

-- We need to use that function, but it only takes an `a`
-- argument. So, we need to get that `a` by using `g`
-- Thus, we'll pass the returning StateT's state argument into `g`
-- Then we get a `monad (Tuple a state)`
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\state ->
      let
        ma = g state
      in
        -- todo
    )
-- So we can use `bind/>>=` to expose the Tuple within this monad
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\state ->
      let
        ma = g state
      in
        ma >>= (\(Tuple value state2) ->
          -- todo
        )
    )

-- Great. Now let's pass `value` into the `f` function
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\state ->
      let
        ma = g state
      in
        ma >>= (\(Tuple value state2) ->
          let 
            b = f value
          in 
            --todo
        )
    )

-- Now we have our `b`. However, the returned `StateT` needs
-- to wrap a function that returns `monad (Tuple value state)`
-- Let's do that now and finish implementing Functor for StateT
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\state ->
      let
        ma = g state
      in
        ma >>= (\(Tuple value state2) ->
          let
            b = f value
          in
            pure (Tuple b state2)
        )
    )
```

### Apply

Since `Apply` is very similar to `Functor` (actually the exact same, but we just unwrap the `f` now, too), we'll just show the code.

```haskell
instance (Monad monad) => Apply (StateT state monad) where
  apply :: forall a b
        -- (state -> Tuple (a -> b) state)
         . StateT state monad (a -> b)
        -> StateT state monad a
        -> StateT state monad b
  apply (StateT f) (StateT g) = StateT (\s1 ->
    let
      (Tuple value1 s2) = g s1
    in
      let
        (Tuple function s3) = f s2
      in
        let
          mappedValue = function value1
        in
          pure $ Tuple mappedValue s3
        )
      )
    )
```

### Applicative

The Applicative instance is actually quite straight forward:
```haskell
instance (Monad monad) => Applicative (StateT state monad) where
  pure :: forall a. a -> StateT state monad a
  pure a = StateT (\s -> pure $ Tuple a s)
```

### Bind & Monad

```haskell
instance (Monad monad) => Bind (StateT state monad) where
  bind :: forall a b
        . StateT state monad a
       -> (a -> StateT state monad b)
       -> StateT state monad b
  bind (StateT g) f = StateT (\s1 ->
    let
      (Tuple value1 s2) = g s1
    in
      let
        (State h) = f value1
      in
        h s2
      )
    )

-- The Monad instance is just declared since there is nothing to implement.
instance (Monad m) => Monad (StateT state monad)
```

### MonadState

```haskell
instance (Monad monad) => MonadState state (StateT state monad) where
  state :: forall value. (state -> Tuple value state) -> StateT state monad value
  state f = StateT (\s -> pure $ f s)
```

## FAABM Using Bind

Notice, however, that the above `let ... in` syntax is really just a verbose way of doing `bind`/`>>=`. If we were to rewrite our instances using `bind`, they now look like this:

```haskell
instance (Monad monad) => Functor (StateT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateT state monad a
      -> StateT state monad b
  map f (StateT g) = StateT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        pure $ Tuple (function value1) s2
      )
    )

instance (Monad monad) => Apply (StateT state monad) where
  apply :: forall a b
        -- (state -> Tuple (a -> b) state)
         . StateT state monad (a -> b)
        -> StateT state monad a
        -> StateT state monad b
  apply (StateT f) (StateT g) = StateT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        (f s2) >>= (\(Tuple function s3) ->
          pure $ Tuple (function value1) s3
        )
      )
    )

instance (Monad monad) => Applicative (StateT state monad) where
  pure :: forall a. a -> StateT state monad a
  pure a = StateT (\s -> pure $ Tuple a s)

instance (Monad monad) => Bind (StateT state monad) where
  bind :: forall a b
        . StateT state monad a
       -> (a -> StateT state monad b)
       -> StateT state monad b
  bind (StateT g) f = StateT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        let (StateT h) = f value1 in h s2
      )
    )

instance (Monad m) => Monad (StateT state monad)
```

## Reviewing StateT's Bind Instance

Let's look in particular at `StateT`'s `bind` implmentation as this is crucial to understanding how it enables the syntax we desire:
```haskell
instance (Monad monad) => Bind (StateT state monad) where
  bind :: forall a b
        . StateT state monad a
       -> (a -> StateT state monad b)
       -> StateT state monad b
  bind (StateT g) f = StateT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        let
          (StateT h) = f value1
        in
        -- h :: (state -> monad (Tuple value state))
           h s2
      )
    )
```

Behind the scenes, `StateT` is still using `Tuple value state` as normal. However, the value that is passed to `f` is the `value` type (i.e. `a`) and not `Tuple value state`.  This is what enables the syntax we desire.

In other words, recall that
```haskell
bind (Box 4) (\four -> body)
-- converts to
(Box 4) >>= (\four -> body)
-- which in 'do notation' looks like
four <- (Box 4)
body four
```

In the next file, we'll show how this actually works via a graph reduction.
