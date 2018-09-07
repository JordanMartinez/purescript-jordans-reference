# A Magical Monad

At this point, we could stop and be satisfied. However, our above definition does not align with Purescript's definition. Why? Because this approach requires every `Monad` to implement `StateLike`. At this point, we only need `Identity` to implement this type class. However, later, we will want others to implement it, too.

## Implementing StateLike for Every Monad

So, what if we could define `StateLike` in such a way that, by defining only one instance for a magical type, we've also implemented it for all other `Monad` types? Crazy, I know! But it's possible! Let's take another look at `stateLike`'s type signature as it reveals an important clue:
```purescript
stateLike :: forall a. (s -> Tuple a s) ->         (s -> m (Tuple a s))

-- Desguar the "->" to see its type
stateLike :: forall a. (s -> Tuple a s) -> Function s   (m (Tuple a s))
```
What if `Function` was a `Monad`? Assuming it was, we would not need to define an instance of `StateLike` for `Identity`, `Box`, or any other Monad type because they would already have it via `Function`. We'll assume that Function is a Monad, try to implement Function's instance for `StateLike`, and see what problems arise:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->   Tuple a s )
             -> (s -> m (Tuple a s))

-- Read: I can implement `stateLike` for every monad, `m`
-- The `?` acts as a place holder for our theory
instance name :: (Monad m) => StateLike s (Function s (m (Tuple ? s))) where
  stateLike :: forall a. (s -> Tuple a s) -> (s -> m (Tuple a s))
  stateLike f = (\s -> pure $ f s)
```
The above instance has a two problems:
1. It won't compile because of that `?` placeholder.
2. A `Monad` has kind `Type -> Type` whereas a `Function` has kind `Type -> Type -> Type`.

How do we resolve both? For the second problem, we can make `Function`'s kind one less by specifying either the input type or the output type:
- `Function Int a`/`(Int -> a)` has kind `Type -> Type` (Haskell's approach)
- `Function a Int`/`(a -> Int)` has kind `Type -> Type`

In other words, we need to turn `Function` into a completely new type (limiting our options to either `data` or `newtype`) and it should only exist at compile time to reduce runtime overhead (i.e. `newtype`). Using a newtyped version of `Function`, we can specify either types:
```purescript
newtype SpecifiedInputFunc  input  =
  SpecifiedInputFunc  (input -> a)  -- Kind: Type -> Type
newtype SpecifiedOutputFunc output =
  SpecifiedOutputFunc (a -> output) -- Kind: Type -> Type

-- Or just combine the idea into one newtype
newtype TypedFunction a b = TypedFunction (a -> b)

specifiesInput :: forall a. TypedFunction Int b -- Kind: Type -> Type

specifiesOutput :: forall a. TypedFunction a Int  -- Kind: Type -> Type
```
Specializing this idea to our case, we need our function, called `StateFunction`, to newtype the function: `(state -> monad (Tuple value state))`:
```purescript
newtype StateFunction stateType monadType valueType =
  StateFunction (stateType -> monadType (Tuple valueType stateType))

class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->   Tuple a s )
             -> (s -> m (Tuple a s))

-- and now we can remove the `?` in the instance head
--    (the "StateLike s (StateFunction s m)" part of the instance)
-- and let it be defined by `stateLike` via "forall"
instance name :: (Monad m) => StateLike s (StateFunction s m) where
  stateLike :: forall a. (s -> Tuple a s) -> StateFunction s m a
  stateLike f = StateFunction (\s -> pure $ f s)
```
However, the above code will not compile. Instead of returning a function, `(s -> m (Tuple a s))`, we are now returning a `StateFunction knownStateType knownMonadType arbitraryType`, which is a Monad. In other words, the return type has the type `forall a. Monad m => m a`. If we update our `StateLike` type class to return `m a`, we get what's actually written in Purescript, just using different names:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a. (s -> Tuple a s) -> m a

newtype StateFunction stateType monadType valueType =
  StateFunction (stateType -> monadType (Tuple valueType stateType))

instance onlyInstance :: (Monad m) => StateLike s (StateFunction s m) where
  stateLike :: forall a. (s -> Tuple a s) -> StateFunction s m a
  stateLike f = StateFunction (\s -> pure $ f s)
```

## Proving that StateFunction is a Monad

Great! Now comes the next part: how can a `StateFunction` be a Monad? A Monad is a type that has instances for the Functor, Apply, Applicative, and Bind type classes. These type classes, as we saw earlier, only specify the type signatures of their functions and the laws any implementations must satisfy. As long as our implementations for `StateFunction` satisfy those laws, we can call `StateFunction` a monad.

Is it possible? Suprisingly, yes, but only if we use pattern matching to expose nested types!
```purescript
newtype StateFunction state monad value =
  StateFunction (state -> monad (Tuple value state))

instance functor :: (Monad monad) => Functor (StateFunction state monad) where
  map :: forall a b
       . (a -> b)
      -> StateFunction state monad a
      -> StateFunction state monad b
  map f (StateFunction g) =
    -- To get the "state" value, we'll need to run all of our code within
    -- the StateFunction context
    StateFunction (\s1 ->

      -- since "g s1" produces a Monad, we can call `bind`/`>>=` on it
      -- to get the Tuple
      (g s1) >>= (\(Tuple value1 state2) ->

        let mappedValue = f value1

        -- this is the `m` type's pure, not StateFunction's pure because
        -- `StateFunction` must return a monad type other than itself
        in pure $ Tuple mappedValue state2
      )
    )

instance apply :: (Monad monad) => Apply (StateFunction state monad) where
  apply :: forall a b
        -- (state -> Tuple (a -> b) state)
         . StateFunction state monad (a -> b)
        -> StateFunction state monad a
        -> StateFunction state monad b
  apply (StateFunction f) (StateFunction g) = StateFunction (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->

        (f s2) >>= (\(Tuple function s3) ->

          let mappedValue = function value1

          in pure $ Tuple mappedValue s3
        )
      )
    )

instance apctv :: (Monad monad) => Applicative (StateFunction state monad) where
  pure :: forall a. a -> StateFunction state monad a
  pure a = StateFunction (\s -> pure $ Tuple a s)

instance bind :: (Monad monad) => Bind (StateFunction state monad) where
  bind :: forall a b
        . StateFunction state monad a
       -> (a -> StateFunction state monad b)
       -> StateFunction state monad b
  bind (StateFunction g) f = StateFunction (\s1 ->
      (g s1) >>= (\(Tuple value1 s2) ->
        let (StateFunction h) = f value1
        -- h :: (state -> monad (Tuple value state))
        in h s2
      )
    )

instance monad :: (Monad m) => Monad (StateFunction state monad)
```

Just to make it very clear, since `StateFunction` provides an instance for `StateLike` that satisfies its type requirements, every other Monad type also satisfies its requirements.
