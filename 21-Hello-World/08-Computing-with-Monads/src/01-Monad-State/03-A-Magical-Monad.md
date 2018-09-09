# A Magical Monad

Despite getting our code to work for a simple manipulation, we're not done yet. Why? Because of one horrible reason:
> This approach requires every monad type in our monad stack to implement `StateLike` if we want to use it in a monad stack.

In other words, we'll need to write A LOT of `NaturalTransformations` from some source monad to all other target monads. What a waste of time!

## Implementing StateLike for Every Monad

So, what if we could define `StateLike` in such a way that, by defining only one instance for a magical type, we've also implemented it for all other `Monad` types? Crazy, I know! But it's possible! Let's take another look at `stateLike`'s type signature as it reveals an important clue:
```purescript
                                                -- |      Hmm....     |
stateLike :: forall a. (s -> Tuple a s) ->         (s -> m (Tuple a s))

-- Desguar the "->" to see its type
stateLike :: forall a. (s -> Tuple a s) -> Function s   (m (Tuple a s))
```
What if `Function` was a `Monad`? Assuming it was, we would not need to define an instance for any other Monad type because they could all be lifted into this function monad. For now, we'll assume (and later prove) that `Function` is a Monad, try to implement Function's instance for `StateLike`, and see what problems arise:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->    Tuple a s )
             -> (s -> m (Tuple a s))

-- Read this instance as...
--    "I can implement `stateLike` for every monad, `m`"
-- The `?` acts as a place holder for our theory
instance name :: (Monad m) => StateLike s (Function s (m (Tuple ? s))) where
  stateLike :: forall a. (s -> Tuple a s) -> (s -> m (Tuple a s))
  stateLike f = (\s -> pure $ f s) -- pure is the `m`'s pure
```
The above instance has a two problems:
1. It won't compile because of that `?` placeholder.
2. A `Monad` has kind `Type -> Type` whereas a `Function` has kind `Type -> Type -> Type`.

How do we resolve both? For the second problem, we can make `Function`'s kind one less by specifying either the input type or the output type:
- `Function Int a`/`(Int -> a)` has kind `Type -> Type`
- `Function a Int`/`(a -> Int)` has kind `Type -> Type`

In other words, we need to turn `Function` into a completely new type (`data`, `type`, or `newtype`) that should only exist at compile time to reduce runtime overhead (e.g. `type` or `newtype`) that can also implement type classes (i.e. only `newtype`). Using a newtyped version of `Function`, we can specify all the types in the function:
```purescript
newtype TypedFunction input output =
  TypedFunction (input -> output)

specifiesInput :: forall a. TypedFunction Int b -- Kind: Type -> Type

specifiesOutput :: forall a. TypedFunction a Int  -- Kind: Type -> Type
```
Specializing this idea to our case, we need our function to newtype the function
`(state -> monad (Tuple value state))`

Since this monad will make it possible for all other monads to implement StateLike, we'll call it, `StateFunctionT`, because it can transform other monad types into `StateLike`:
```purescript
newtype StateFunctionT stateType monadType valueType =
  StateFunctionT (stateType -> monadType (Tuple valueType stateType))

class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->    Tuple a s )
             -> (s -> m (Tuple a s))

-- and now we can remove the `?` in the instance head,
--    (the "StateLike s (StateFunctionT s m)" part of the instance),
-- and let it's `a` type be defined by `stateLike` via "forall"
instance name :: (Monad m) => StateLike s (StateFunctionT s m) where
  stateLike :: forall a. (s -> Tuple a s) -> StateFunctionT s m a
  stateLike f = StateFunctionT (\s -> pure $ f s)
```
However, the above code will not compile. Instead of returning a function, `(s -> m (Tuple a s))`, we are now returning a `StateFunctionT knownStateType knownMonadType arbitraryType`, which is a Monad. In other words, the return type has the type `forall a. m a`. If we update our `StateLike` type class to return `m a`, we get what's actually written in Purescript, just using different names:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a. (s -> Tuple a s) -> m a

newtype StateFunctionT stateType monadType valueType =
  StateFunctionT (stateType -> monadType (Tuple valueType stateType))

instance onlyInstance :: (Monad m) => StateLike s (StateFunctionT s m) where
  stateLike :: forall a. (s -> Tuple a s) -> StateFunctionT s m a
  stateLike f = StateFunctionT (\s -> pure $ f s)
```

## Proving that StateFunctionT is a Monad

Great! Now comes the next part: how can a `StateFunctionT` be a Monad?

A Monad is a type that has instances for the Functor, Apply, Applicative, and Bind type classes. These type classes, as we saw earlier, only specify the type signatures of their functions and the laws any implementations must satisfy. As long as our implementations for `StateFunctionT` can satisfy those laws, we can call `StateFunctionT` a monad.

Is it possible? Suprisingly, yes, but only if we use pattern matching to expose nested types!
```purescript
newtype StateFunctionT state monad value =
  StateFunctionT (state -> monad (Tuple value state))

instance functor :: (Monad monad) => Functor (StateFunctionT state monad) where
  map :: forall a b
       . (a -> b)
      -> StateFunctionT state monad a
      -> StateFunctionT state monad b
  map f (StateFunctionT g) =
    -- To get the "state" value, we'll need to run all of our code within
    -- the StateFunctionT context
    StateFunctionT (\s1 ->

      -- since "g s1" produces a Monad, we can call `bind`/`>>=` on it
      -- to get the Tuple
      (g s1) >>= (\(Tuple value1 state2) ->

        let mappedValue = f value1

        -- this is the `monad` type's pure, not StateFunctionT's pure because
        -- `StateFunctionT` must return a "monad (Tuple valueType stateType)"
        in pure $ Tuple mappedValue state2
      )
    )

instance apply :: (Monad monad) => Apply (StateFunctionT state monad) where
  apply :: forall a b
        -- (state -> Tuple (a -> b) state)
         . StateFunctionT state monad (a -> b)
        -> StateFunctionT state monad a
        -> StateFunctionT state monad b
  apply (StateFunctionT f) (StateFunctionT g) = StateFunctionT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->

        (f s2) >>= (\(Tuple function s3) ->

          let mappedValue = function value1

          in pure $ Tuple mappedValue s3
        )
      )
    )

instance apctv :: (Monad monad) => Applicative (StateFunctionT state monad) where
  pure :: forall a. a -> StateFunctionT state monad a
  pure a = StateFunctionT (\s -> pure $ Tuple a s)

instance bind :: (Monad monad) => Bind (StateFunctionT state monad) where
  bind :: forall a b
        . StateFunctionT state monad a
       -> (a -> StateFunctionT state monad b)
       -> StateFunctionT state monad b
  bind (StateFunctionT g) f = StateFunctionT (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        let (StateFunctionT h) = f value1
        -- h :: (state -> monad (Tuple value state))
        in h s2
      )
    )

instance monad :: (Monad m) => Monad (StateFunctionT state monad)
```

## Defining StateFunction

Now that we've defined `StateFunctionT`, how we can further specify its monad type to `Identity` when we aren't manipulating higher-kinded data structures (e.g. `Array`, `List`, `Tree`)?

We need a type (e.g. `data`, `type`, or `newtype`) that should only exist at compile time to reduce runtime overhead (e.g. `type` or `newtype`) that does not need to implement type classes (i.e. only `type`). Let's remove the `T` part (indicating that it is not transforming a monad into `StateLike`) via type alias:
```purescript
type StateFunction state output = StateFunctionT state Identity output
```
