# The Original Free Monad

Rather than explaining how one can eventually reason their way through defining what the type is for the original `Free` monad (a bottom-up approach), we'll simply show its definition, its instances, and demonstrate why it has to work that way (a top-down approach).

```haskell
data Free f a
  = Pure a
  | Impure (f (Free f a))
```
Let's say that `Identity` is our `f`/`Functor` type. What does a concrete value of the `Free` data type look like?
```haskell
Impure ( Identity (
  Impure ( Identity (
    Impure ( Identity (
      Pure a
    ))
  ))
))
```
In other words, `Free` is just a tree-like data structure of nested `Identity` values (the branches in our tree) that eventually wrap a final value (the leaf in our tree). In our current example, the tree is unbalanced, so that it appears more like a linked-list than a tree:
```haskell
{- Impure ( -} Identity (
  {- Impure ( -} Identity (
    {- Impure ( -} Identity (
      {- Pure -}     a
    {- ) -}        )
  {- ) -}        )
{- ) -}        )
```
The only difference is that `Identity` itself is wrapped in another type. So how do we change a value that is wrapped in a box-like type? We use `Functor`'s `map`, of course! We'll use `map` in most of `Free`'s instances for the needed type classes:
```haskell
-- easiest one!
instance Applicative (Free f) where
  pure a = Pure a

-- a <#> f == mapFlipped a f == map f a
instance (Functor f) => Functor (Free f) where
  map f (Pure a) = Pure (f a)
  map f (Impure f_of_Free) =
    Impure (f_of_Free <#> (
      -- recursively call `map` on nested `Impure` values
      -- until we get a `Pure` value of Free
      \pure_A -> map f pure_A
      -- which applies the function to the `a`
      -- and then rewraps the `Impure` values
    ))
```
Let's see `map` in action via a graph reduction:
```haskell
-- Start!
map f (
  Impure ( Identity (
    Impure ( Identity (
      Pure 5
    ))
  ))
)
-- Recursively apply `map` until we get a `Pure` value
-- 1.
      (
  Impure ( map f Identity (
    Impure ( Identity (
      Pure 5
    ))
  ))
)
-- 2.
       (
   Impure ( Identity (
     map f Impure ( Identity (
       Pure 5
     ))
   ))
 )
-- 3.
      (
   Impure ( Identity (
     Impure ( map f Identity (
       Pure 5
     ))
   ))
 )
-- 4.
       (
   Impure ( Identity (
     Impure ( Identity (
       map f (Pure 5)
     ))
   ))
 )
-- Now apply the function to pure's value
        (
   Impure ( Identity (
     Impure ( Identity (
       Pure (f 5)
     ))
   ))
 )
-- End definition
map f (
  Impure ( Identity (
    Impure ( Identity (
      Pure a
    ))
  ))
)
==
  Impure ( Identity (
    Impure ( Identity (
      Pure (f a)
    ))
  ))
```
Let's look at the `Apply` instance now:
```haskell
instance (Functor f) => Apply (Free f) where
  apply (Pure f) (Pure a) = Pure (f a)
  apply (Impure f_of_Free_F) pure_A =
    Impure (f_of_Free_F <#> (
      -- recursively call `apply` on nested `Impure` values
      -- until we get a `Pure` value of Free
        \pure_F -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` values
    ))
  apply pure_F (Impure f_of_Free)  =
    Impure (f_of_Free <#> (
      -- recursively call `apply` on nested `Impure` values
      -- until we get a `Pure` value of Free
        \pure_A -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` values
    ))
```
Let's see `apply` in action via a graph reduction:
```haskell
-- Reminder: function arg == arg # function

-- Start
--    "Left" Impure            "Right" Impure
apply (Impure (Identity (Pure f))) (Impure (Identity (Pure a)))
-- Use `map` to recursively call `apply` on the left Impure until we get the
-- Pure value
Impure ((Identity (Pure f)) <#> (\pure_F  -> apply pure_F (Impure (Identity (Pure a)))))
Impure (Identity ((Pure f)   #  (\pure_F  -> apply pure_F (Impure (Identity (Pure a)))))
-- apply `Pure f` to the function
Impure (Identity (             (\(Pure f) -> apply (Pure f) (Impure (Identity (Pure a)))))
Impure (Identity (                           apply (Pure f) (Impure (Identity (Pure a)))))
-- Remove the extra whitespace
Impure (Identity (apply (Pure f) (Impure (Identity (Pure a)))))

-- Now use `map` to recursiveely call `apply` on the right Impure until we get
-- Pure value
Impure (Identity (Impure ((Identity (Pure a) <#> (\pure_A  -> apply (Pure f) pure_A))))
Impure (Identity (Impure (Identity ((Pure a)  #  (\pure_A  -> apply (Pure f) pure_A))))
-- apply `Pure a` to the function
Impure (Identity (Impure (Identity (            (\(Pure a) -> apply (Pure f) (Pure a))))))
Impure (Identity (Impure (Identity (                          apply (Pure f) (Pure a) ))))
-- Remove thee extra whitespace
Impure (Identity (Impure (Identity (apply (Pure f) (Pure a)))))
-- Look up the instance
--    apply (Pure f) (Pure a) = Pure (f a)
-- and replace the LHS with the RHS
Impure (Identity (Impure (Identity (Pure (f a)))))
```
Now let's define `Bind`, again using the `map` recursively:
```haskell
instance (Functor f) => Bind (Free f) where
  bind (Pure a) f = f a
  bind (Impure f_of_Free) f =
    Impure (f_of_Free <#> (
      -- recursively call `bind` on nested `Impure` values
      -- until we get a `Pure` value of Free
      \pure_A -> bind pure_A f
      -- apply the function and then rewrap `Impure` values
    ))
```
Let's see `bind` in action via a graph reduction:
```haskell
-- Start!
bind (Impure ( Identity (Pure a))) f

-- Recursively call `bind` via `map` until reach a `Pure` value:
bind (Impure ( Identity  (Pure a))) f
      Impure ((Identity  (Pure a)) <#> (\pure_a -> bind pure_a f) )
      Impure ( Identity ((Pure a)   #  (\pure_a -> bind pure_a f)))
-- Apply `Pure a` to the function
      Impure ( Identity (              (           bind (Pure a) f)))
      Impure ( Identity (                          bind (Pure a) f))
-- remove extra white space
Impure ( Identity (bind (Pure a) f))
-- Look up the instance
--    bind (Pure a) f = f a
-- and replace the LHS with the RHS
Impure ( Identity (Pure (f a)))
```

## Definition of Free Monad

Putting it all together, we get this:
```haskell
data Free f a
  = Pure a
  | Impure (f (Free f a))

instance Applicative (Free f) where
  pure a = Pure a

instance (Functor f) => Functor (Free f) where
  map f (Pure a) = Pure (f a)
  map f (Impure f_of_Free) =
    Impure (f_of_Free <#> (
      -- recursively call `map` on nested `Impure` values
      -- until we get a `Pure` value of Free
      \pure_A -> map f pure_A
      -- which applies the function to the a
      -- and then rewraps the `Impure` values
    ))

instance (Functor f) => Apply (Free f) where
  apply (Pure f) (Pure a) = Pure (f a)
  apply (Impure f_of_Free_F) pure_A =
    Impure (f_of_Free_F <#> (
      -- recursively call `apply` on nested `Impure` values
      -- until we get a `Pure` value of Free
        \pure_F -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` values
    ))
  apply pure_F (Impure f_of_Free)  =
    Impure (f_of_Free <#> (
      -- recursively call `apply` on nested `Impure` values
      -- until we get a `Pure` value of Free
        \pure_A -> apply pure_F pure_A
      -- apply the function and then rewrap `Impure` values
    ))

instance (Functor f) => Bind (Free f) where
  bind (Pure a) f = f a
  bind (Impure f_of_Free) f =
    Impure (f_of_Free <#> (
      -- recursively call `bind` on nested `Impure` values
      -- until we get a `Pure` value of Free
      \pure_A -> bind pure_A f
      -- apply the function and then rewrap `Impure` values
    ))
```

The next file will explain why this implementation has performance problems.
