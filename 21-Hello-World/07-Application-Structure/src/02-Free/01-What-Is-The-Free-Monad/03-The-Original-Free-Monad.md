# The Original Free Monad

Rather than explaining how one can eventually reason their way through defining what the type is for the original `Free` monad (a bottom-up approach), we'll simply show its definition, its instances, and demonstrate why it has to work that way (a top-down approach).

```purescript
data Free f a
  = Pure a
  | Impure (f (Free f a))
```
Let's say that `Box` is our `f`/`Functor` type. What does a concrete instance of the `Free` data type look like?
```purescript
Impure ( Box (
  Impure ( Box (
    Impure ( Box (
      Pure a
    ))
  ))
))
```
In other words, `Free` is just a data structure of nested `Box` types where the final `Box` one wraps a value:
```purescript
{- Impure ( -} Box (
  {- Impure ( -} Box (
    {- Impure ( -} Box (
      {- Pure -}     a
    {- ) -}        )
  {- ) -}        )
{- ) -}        )
```
The only difference is that `Box` itself is wrapped in another type. So how do we change a value that is wrappd in a box-like type? We use `Functor`'s `map`, of course! We'll use `map` in most of `Free`'s instances for the needed type classes:
```purescript
-- easiest one!
instance Applicative :: Applicative (Free f) where
  pure a = Pure a

-- a <#> f == mapFlipped a f == map f a
instance functor :: (Functor f) => Functor (Free f) where
  map f (Pure a) = Pure (f a)
  map f (Impure f_of_Free) =
    Impure (f_of_Free <#> (
      -- recursively call `map` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
      \pure_A -> map f pure_A
      -- which applies the function to the a
      -- and then rewraps the `Impure` instances
    ))
```
Let's see `map` in action via a graph reduction:
```purescript
-- Start!
map f (
  Impure ( Box (
    Impure ( Box (
      Pure 5
    ))
  ))
)
-- Recursively apply `map` until we get a `Pure` instance
-- 1.
      (
  Impure ( map f Box (
    Impure ( Box (
      Pure 5
    ))
  ))
)
-- 2.
       (
   Impure ( Box (
     map f Impure ( Box (
       Pure 5
     ))
   ))
 )
-- 3.
      (
   Impure ( Box (
     Impure ( map f Box (
       Pure 5
     ))
   ))
 )
-- 4.
       (
   Impure ( Box (
     Impure ( Box (
       map f (Pure 5)
     ))
   ))
 )
-- Now apply the function to pure's value
        (
   Impure ( Box (
     Impure ( Box (
       Pure (f 5)
     ))
   ))
 )
-- End definition
map f (
  Impure ( Box (
    Impure ( Box (
      Pure a
    ))
  ))
)
==
  Impure ( Box (
    Impure ( Box (
      Pure (f a)
    ))
  ))
```
Let's look at the `Apply` instance now:
```purescript
instance apply :: (Functor f) => Apply (Free f) where
  apply (Pure f) (Pure a) = Pure (f a)
  apply (Impure f_of_Free_F) pure_A =
    Impure (f_of_Free_F <#> (
      -- recursively call `apply` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
        \pure_F -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` instances
    ))
  apply pure_F (Impure f_of_Free)  =
    Impure (f_of_Free <#> (
      -- recursively call `apply` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
        \pure_A -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` instances
    ))
```
Let's see `apply` in action via a graph reduction:
```purescript
-- Reminder: function arg == arg # function

-- Start
--    "Left" Impure            "Right" Impure
apply (Impure (Box (Pure f))) (Impure (Box (Pure a)))
-- Use `map` to recursively call `apply` on the left Impure until we get the
-- Pure instance
Impure ((Box (Pure f)) <#> (\pure_F  -> apply pure_F (Impure (Box (Pure a)))))
Impure (Box ((Pure f)   #  (\pure_F  -> apply pure_F (Impure (Box (Pure a)))))
-- apply `Pure f` to the function
Impure (Box (             (\(Pure f) -> apply (Pure f) (Impure (Box (Pure a)))))
Impure (Box (                          apply (Pure f) (Impure (Box (Pure a)))))
-- Remove the extra whitespace
Impure (Box (apply (Pure f) (Impure (Box (Pure a)))))

-- Now use `map` to recursiveely call `apply` on the right Impure until we get
-- Pure instance
Impure (Box (Impure ((Box (Pure a) <#> (\pure_A  -> apply (Pure f) pure_A))))
Impure (Box (Impure (Box ((Pure a)  #  (\pure_A  -> apply (Pure f) pure_A))))
-- apply `Pure a` to the function
Impure (Box (Impure (Box (            (\(Pure a) -> apply (Pure f) (Pure a))))))
Impure (Box (Impure (Box (                          apply (Pure f) (Pure a) ))))
-- Remove thee extra whitespace
Impure (Box (Impure (Box (apply (Pure f) (Pure a)))))
-- Look up the instance
--    apply (Pure f) (Pure a) = Pure (f a)
-- and replace the LHS with the RHS
Impure (Box (Impure (Box (Pure (f a)))))
```
Now let's define `Bind`, again using the `map` recursively:
```purescript
instance bind :: (Functor f) => Bind (Free f) where
  bind (Pure a) f = f a
  bind (Impure f_of_Free) f =
    Impure (f_of_Free <#> (
      -- recursively call `bind` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
      \pure_A -> bind pure_A f
      -- apply the function and then rewrap `Impure` instances
    ))
```
Let's see `bind` in action via a graph reduction:
```purescript
-- Start!
bind (Impure ( Box (Pure a))) f

-- Recursively call `bind` via `map` until reach a `Pure` instance:
bind (Impure ( Box  (Pure a))) f
      Impure ((Box  (Pure a)) <#> (\pure_a -> bind pure_a f) )
      Impure ( Box ((Pure a)   #  (\pure_a -> bind pure_a f)))
-- Apply `Pure a` to the function
      Impure ( Box (              (        -> bind (Pure a) f)))
      Impure ( Box (                          bind (Pure a) f))
-- remove extra white space
Impure ( Box (bind (Pure a) f))
-- Look up the instance
--    bind (Pure a) f = f a
-- and replace the LHS with the RHS
Impure ( Box (Pure (f a)))
```

### Definition of Free Monad

Putting it all together, we get this:
```purescript
data Free f a
  = Pure a
  | Impure (f (Free f a))

instance applicative :: Applicative (Free f) where
  pure a = Pure a

instance functor :: (Functor f) => Functor (Free f) where
  map f (Pure a) = Pure (f a)
  map f (Impure f_of_Free) =
    Impure (f_of_Free <#> (
      -- recursively call `map` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
      \pure_A -> map f pure_A
      -- which applies the function to the a
      -- and then rewraps the `Impure` instances
    ))

instance apply :: (Functor f) => Apply (Free f) where
  apply (Pure f) (Pure a) = Pure (f a)
  apply (Impure f_of_Free_F) pure_A =
    Impure (f_of_Free_F <#> (
      -- recursively call `apply` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
        \pure_F -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` instances
    ))
  apply pure_F (Impure f_of_Free)  =
    Impure (f_of_Free <#> (
      -- recursively call `apply` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
        \pure_A -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` instances
    ))

instance bind :: (Functor f) => Bind (Free f) where
  bind (Pure a) f = f a
  bind (Impure f_of_Free) f =
    Impure (f_of_Free <#> (
      -- recursively call `bind` on nested `Impure` instances
      -- until we get a `Pure` instance of Free
      \pure_A -> bind pure_A f
      -- apply the function and then rewrap `Impure` instances
    ))
```

The next file will explain why this implementation has performance problems.
