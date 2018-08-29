# Control Flow

There are type classes that control the flow of the program (e.g. whether the program should do X and then Y or should do X and Y at the same time).

## Functor, Apply, and Bind Type Classes Explained in Pictures

We've linked to an article below that explains these abstract notions in a clear manner using pictures and the `Maybe a` data structure. However, since these concepts are explained in Haskell, which uses different terminology than Purescript, use the following table to `map` Haskell terminology to Purescript terminology:

| Haskell Terminology | Purescript Terminology |
| --- | --- |
| `fmap` (function) | `map` (function) |
| `Applicative` (type class) | `Apply` (type class) |
| `Array`/`[]` (syntax sugar for `List a`) | `List a` |
| `map` (Array function) | see [the implementation in Purescript](#lists-map-function-in-purescript) |
| `IO ()` | `Effect Unit`, which will be explained/used in a later part of this folder |

Here's the link to the article:
http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html

### Lists' Map Function in Purescript

Here's the `map` List function implemented in Purescript:
```purescript
data List a = Nil | Cons a (List a)

instance Functor List where
  map :: forall a b. (a -> b) -> List a -> List b
  map f Nil = Nil
  map f (Cons head tail) = Cons (f head) (map f tail)
```

## Functor, Apply, Applicative, Bind, Monad

| Typeclass | "Plain English" | Function | Infix | Laws | Usage
| -- | -- | -- | -- | -- | -- |
| [Functor](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Functor) | Mappable | `map :: forall a b. (a -> b) -> f a -> f b` | `<$>` <br> (Left 4) | <ul><li>identity: `map (\x -> x) fa == fa`</li><li>composition: `map (f <<< g) = map f <<< map g`</li></ul> | Given a box-like type, `f`, with a value(s) of some type, `a`, use the provided function to change the `a` to `b` without changing the box-like type itself. |
| [Apply](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Apply) | Boxed Mappable | `apply :: forall a b. f (a -> b) -> f a -> f b` | `<*>` <br> (Left 4) | <ul><li>Associative composition: `(<<<) <$> f <*> g <*> h == f <*> (g <*> h)`</li></ul> | Same as `Functor` except the function is now inside of the same box-like type. |
| [Applicative](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Applicative) | Liftable <hr> Parallel Computation | `pure :: forall a. a -> f a` |  | <ul><li>identity: `(pure (\x -> x) <*> v == v)`</li><li>composition: `pure (<<<) <*> f <*> g <*> h == f <*> (g <*> h)`</li><li>Homomorphism: `(pure f) <*> (pure x) == pure (f x)`</li><li>interchange: `u <*> (pure y) == (pure (_ $ y)) <*> u`</li></ul> | Put a value into a box <hr> Run code in parallel |
| [Bind](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Bind) | Chainable | `bind :: forall m a b. m a -> (a -> m b) -> m b` | `>>=` <br> (Left 1)| Associativity: `(x >>= f) >>= g == x >>= (\x' -> f x' >>= g)` | Given an instance of a box-like type, `m`, that contains a value, `a`, extract the `a` from `m`, and create a new `m` instance that stores a new value, `b`. <br> Take `f a` and compute it via `bind`/`>>=` to produce a value, `a`. Then, use `a` to describe (but not run) a new computation, `m b`. When `m b` is computed (via a later `bind`/`>>=`), it will return `b`. |
| [Monad](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Monad) | Sequential Computation | | | | The data structure used to run FP programs by executing code line-by-line, function-by-function, etc. |

## Simplest Useless Monad Implementation

```purescript
data Box a = Box a

instance f :: Functor Box where
  map f (Box a) = Box (f a)

instance a1 :: Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance a2 :: Applicative Box where
  pure a = Box a

instance b :: Bind Box where
  bind (Box a) f = f a

instance m :: Monad Box
```

## Monad laws re-examined

Another way to think about the laws for Monad are:
```purescript
-- given a function whose type signature is...
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c
(aToMB >=> bToMC) a = aToMB a >>= (\b -> bToMC b)

-- and Monad could be defined by these laws:
(function >>> id) a == function a -- Function's identity law
 aToMB    >=> pure  == aToMB

-- and its inverse
(id   >>> f) a == f a
 pure >=> f    == f

-- and function composition
f >>> (g >>> h) == (f >>> g) >>> h -}
f >=> (g >=> h) == (f >=> g) >=> h
```
This was taken from [this slide in this YouTube video](https://youtu.be/EoJ9xnzG76M?t=7m9s)

## How does the Computer Execute FP Programs?

Or "What does sequential computation look like using Monads"

Using this type and Bind instance...
```purescript
data Box a = Box a

-- Remember:
--
--    function arg == arg # function
--
-- We're using this notation to keep the argument on the left side
-- rather than on the right side where it normally goes because
-- the function will have a long body that makes it harder to understand.

instance b :: Bind Box where
  bind :: forall a b. Box a -> (a -> Box b) -> Box b
  bind (Box a) f = a # f
```
... we will translate this Javascript file...
```javascript
const four = 4
const five = 1 + four
const five_string = toString(five); // or whatever the function called
print(five_string); // print the String to the console, which returns nothing
```
... into PureScript. To evaluate this, we will reduce the functions by replacing the left-hand side of the `=` sign (the function's call signature) with the right-hand side of the `=` sign (the function's implementation / body). In the following snippet of code, you will need to scroll to the right, so that the a previous reduction aligns with the next reduction:
```purescript
unsafePerform :: forall a. Box a
unsafePerform (Box a) = a

-- Compute what the final Box value is
-- and then call `unsafePerform` on the final Box
main :: Unit
main = unsafePerform $
  (Box 4) >>= (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

-- Step 1: De-infix the first '>>=' alias back to bind
  bind (Box 4)  (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

-- Step 2: Look up Box's bind implementation...
--   ...and replace the left-hand side with the right-hand side
            4 # (\four -> Box (1 + four) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

            -- Step 3: Apply the arg to the function (i.e. replace "four" with 4)
                (\4    -> Box (1 + 4   ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string)))

                -- Step 4: Reduce the function to its body
                          Box (1 + 4   ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 5: Reduce the argument in "Box (1 + 4)" to "Box 5"
                          Box (5       ) >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 6: Remove the parenthesis
                          Box  5         >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                          -- Step 7: Remove the extra whitespace and push right
                                   Box 5 >>= (\five -> Box (show five) >>= (\five_string -> print five_string))

                                   -- Step 8: Repeat Steps 1-7 for the next ">>="
                                   bind (Box 5)  (\five -> Box (show five) >>= (\five_string -> print five_string))

                                             5 # (\five -> Box (show five) >>= (\five_string -> print five_string))

                                                 (\5    -> Box (show 5   ) >>= (\five_string -> print five_string))

                                                           Box (show 5   ) >>= (\five_string -> print five_string)

                                                           Box ("5"      ) >>= (\five_string -> print five_string)

                                                           Box  "5"        >>= (\five_string -> print five_string)

                                                                   Box "5" >>= (\five_string -> print five_string)

                                                                   -- Step 8: Repeat Steps 1-6 for the next ">>="
                                                                   bind (Box "5")  (\five_string -> print five_string)

                                                                             "5" # (\five_string -> print five_string)

                                                                                   (\"5"         -> print "5")

                                                                                                    print "5"

                                                                  -- Step 9: Look up `print`'s definition
                                                                  --
                                                                  --   print :: forall a. a -> Box Unit
                                                                  --   print a =
                                                                  --      -- Assume that 'a' is printed to the console
                                                                  --      Box unit
                                                                  --
                                                                  -- ... and replace the LHS with RHS

                                                                                                     Box unit

                                                                  -- Step 10a: Shift everything to the left again
-- 10b) ... and re-expose the 'main' function:
main :: Unit
main = unsafePerform (Box unit)

-- Step 11: call `unsafePerform`
main :: Unit
main = unit
```

## Do notation

At this point, you should look back at the Syntax folder to read through the file on `do notation`. You should also become familiar with the `ado notation` (Applicative Do).

Be aware of where the parenthesis appear when using `m a >>= aToMB >>= bToMC` by reading the section called "Do notation" in [this article](https://sras.me/haskell/miscellaneous-enlightenments.html). Below provides a summary of what it says:
```purescript
data Maybe a = Nothing | Just a

instance b :: Bind Maybe where
  bind (Just a) f = f a
  bind Nothing f = Nothing

half :: Int -> Maybe Int
half x | x % 2 == 0 = x / 2
       | otherwise = Nothing

-- This statement
(Just 128) >>= half >>= half >>= half == Just 16
-- desugars first to
(Just 128) >>= (\original -> half original >>= half >>= half ) == Just 16
-- which can be better understood as
(Just 128) >>= aToMB == Just 16
-- since the latter ">>=" calls are nested inside of the first one, as in
-- "Only continue if the previous `bind`/`>>=` call was successful."

-- Similarly
Nothing    >>= half >>= half >>= half == Nothing
-- desguars first to
Nothing    >>= (\value -> half value >>= half >>= half) == Nothing
-- which can be better understood as
Nothing    >>= aToMB == Nothing
-- and, looking at the instance of Bind above, reduces to Nothing
--
-- bind instance has this definition:
-- bind Nothing aToMB = Nothing

-- Thus, given this function...
half3Times :: Maybe Int -> Maybe Int
half3Times maybeI = do
  original <- maybeI
  first <- half original    -- ===
  second <- half first      --  | a -> m b
  third <- half second      --  |
  pure third                -- ===
-- ... passing in `Nothing` doesn't compute anything
half3Times Nothing == Nothing
```
