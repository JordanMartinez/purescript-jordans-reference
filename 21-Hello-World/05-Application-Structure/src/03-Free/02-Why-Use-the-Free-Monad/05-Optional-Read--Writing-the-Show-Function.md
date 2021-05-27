# Writing the Show Function

<hr>
**Thils file is optional reading!**

There are two reasons why:
- I was not able (i.e. smart enough to initially figure this out on my own) to convert this code into a compilable example
- I found that I was able to understand the concept that this folder teaches without ultimately figuring out the below code. For example, the paper only lists the `show` function as another example about how it is easy to add more functions.
- The cost-beneifits weren't worth it. Why spend time on trying to figure out this problem when I could spend time improving some other part of this repo, especially since this detail does not contribute greatly to one's understanding of this concept.
<hr>

We still have one more function to define: `show2` (which is just `show` but which prevents the name conflict from `Prelude`). In our original file, `show2` was defined like this:
```haskell
show2 :: Expression -> String
show2 (Value i) = show i
show2 (Add x y) = "(" <> show2 x <> " + " <> show2 y <> ")"
```

Since we changed the function, `evaluate`, into a type class, we should follow suit here. Still, we should diverge from `Evaluate` in a one way:
- The types for `x` and `y` in `Add x y` should not be an `Int`. Rather, it should keep the spirit of the original `show2` function and be other expression types on which we can recursively call `show2` to get a full expression.

`Expression` in our original `show2` function meant both `Value` and `Add`. To do the same thing in our new code, where these types are composed via `Either`, we would need to change the signature to `f (Expression f)`:

```haskell
class (Functor f) <= Show2 f where                                {-
  show2 :: AllExpressionTypes -> String                                   -}
  show2 :: f (Expression f)   -> String
```
With that being our expression type, what would values for `Value`, `Add`, and `Multiply` look like that fit that signature?
```haskell
-- Value
(Value 5)

-- Value does not use the `In` value here
-- so its implementation is trivial
instance Show2 Value where
  show2 (Value x) = show x

-- Add
Add
  (In (Left (Value 5)))
  (In (Right (Right (Multiply
    (In (Left (Value 9)))
    (In (Left (Value 9)))
  ))))

-- Multiply
Multiply
  (In (Left (Value 5)))
  (In (Right (Left (Add
    (In (Left (Value 4)))
    (In (Left (Value 2)))
  ))))
```
`Add` and `Multiply` both have an `In` value and an `Either` value separating the next expression. We can remove the `In` value using a function. However, removing the `Either` value would be best left to an instance of our own type class that just delegates it to the underlying expression.
```haskell
removeInAndShow :: Show2 f => Expression f -> String
removeInAndShow (In t) = show2 t

instance (Show2 f, Show2 g) => Show2 (Either f g) where
  show2 (Left f)  = show2 f
  show2 (Right g) = show2 g

-- Now we can define the values for Add and Multiply
instance Show2 Add where
  show2 (Add x y) =
    "(" <> removeInAndShow x <> " + " <> removeInAndShow y <> ")"

instance Show2 Multiply where
  show2 (Multiply x y) =
    "(" <> removeInAndShow x <> " * " <> removeInAndShow y <> ")"
```

## All Code So Far and Show2

Again, **I have not checked whether this code works, but it will serve to give you an idea for how it works.**
```haskell
-- File 1
data Value e = Value Int
data Add e = Add e e

derive instance Functor Value
derive instance Functor Add

data Expression f = In (f (Expression f))

-- where `f` is a composed data type via Coproduct
value :: forall f. Int -> Expression f
value i = inj (Value i)

add :: forall f. Expression f -> Expression f -> Expression f
add x y = inj (Add x y)

class (Functor f) <= Evaluate f where
  evaluate :: f Int -> Int

instance Evaluate Value where
  evaluate (Value x) = x

instance Evaluate Add where
  evaluate (Add x y) = x + y

fold :: Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)

type VA e = Coproduct Value Add e
newtype VA_Expression = VA_Expression (Expression VA)

eval :: forall f. Expression f -> Int
eval expression = fold evaluate expression

class (Functor f) <= Show2 f where
  show2 :: forall a. f a -> String

instance Show2 Value where
  show2 (Value x) = show x

removeInAndShow :: Show2 f => Expression f -> String
removeInAndShow (In t) = show2 t

instance (Show2 f, Show2 g) => Show2 (Either f g) where
  show2 (Left f)  = show2 f
  show2 (Right g) = show2 g

instance Show2 Add where
  show2 (Add x y) =
    "(" <> removeInAndShow x <> " + " <> removeInAndShow y <> ")"

-- call `eval` and `show2` on this
file1Example :: VA_Expression
file1Example = add (value 5) (value 6)

-- File 2
data Multiply e = Multiply e e
derive instance Functor Multiply

multiply :: forall f. Expression f -> Expression f -> Expression f
multiply x y = inj $ Multiply x y

instance Evaluate Multiply where
  evaluate (Multiply x y) = x * y

instance Show2 Multiply where
  show2 (Multiply x y) =
    "(" <> removeInAndShow x <> " * " <> removeInAndShow y <> ")"

type VAM e = Coproduct3 Value Add Multiply e
newtype VAM_Expression = VAM_Expression (Expression VAM)

-- call `eval` and `show2` on this
file2Example :: VAM_Expression
file2Example = add (value 5) (multiply (add (value 2) (value 8)) (value 4))
```
