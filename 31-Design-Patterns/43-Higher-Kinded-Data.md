# Higher-Kinded Data

## Reviewing Higher-Kinded Types

We have higher-kinded types in PureScript (e.g. anything that requires another type to be specified before it becomes a concrete type):
```haskell
-- higher-kinded by 1
data List :: Type -> Type
data List a
  = Nil
  | Cons a (List a)

-- higher-kinded by 2
data Either :: Type -> Type -> Type
data Either e a
  = Left e
  | Right a
```

In other words, we never have just `List`s. Rather, we always have a `List` of `String`s or a `List` of `Int`s. The `a` type needs to be specified before we can use this value in most contexts.

We can apply this idea in a different manner called "higher-kinded data". I first saw this in a blog post called [Higher-Kinded Data](https://reasonablypolymorphic.com/blog/higher-kinded-data/), saw its usage in Thomas Honeyman's `halogen-formless`, and then saw `@kritzcreek`'s comment on the various types one could define with them (shown later in this file). We'll document the pattern below and why you might want to use it.

```haskell
-- Given this type...
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)
```

We can specify `f` to a number of different types, thereby defining multiple types in-line with little effort.

## Basic Types

### Using `Unlift a` to Ignore the `f` Type Parameter

```haskell
-- Given a type that satisfies the (Type -> Type) kind signature
-- but is the same type as the `a` type parameter...
type Unlift a = a

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is an `Int`.
type HKD_Unlift = HKD Unlift
```

### Using `Const a b` to Ignore/Override the `Int` Type Parameter

```haskell
-- Given a type that ignores its second type parameter
type Const a b = a

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is a `Boolean`
type HKD_ConstBoolean = HKD (Const Boolean)
```

## Common Types

### Using `Maybe a` to Make the `Int` Type Parameter Optional

```haskell
-- Given a type that may contain a value
data Maybe a
  = Nothing
  | Just a

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value might be an `a` or not.
type HKD_Maybe = HKD Maybe
```

### Using `Either e` to Provide an Alternative to the `Int` Type Parameter

```haskell
-- Given a type that may contain a value
data Either e a
  = Left e
  | Right a

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value might be an `String` or an `Int`.
type HKD_Either = HKD (Either String)
```

### Using `List a` to Provide 0 or more `Int` values

```haskell
-- Given a type that may contain a value
data List a
  = Nil
  | Cons a (List a)

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is 0 or more `Int`s.
type HKD_List = HKD List
```

### Using `NonEmpty f a` to Provide 1 or more `Int` values

```haskell
-- Given a type that may contain a value
newtype NonEmpty f a = NonEmpty a (f a)

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is 1 or more `Int`s.
type HKD_List = HKD (NonEmpty List)
```

## More Complex Types

### Using `Function a b` to Produce `Int` Values Given Some Argument

```haskell
-- Given a type that produces a value when given an argument
data Function a b

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is a function that takes a `String` to produce an `Int`.
type HKD_List = HKD (Function String)

-- or using short-hand syntax
type HKD_List = HKD ((->) String)
```

### Using `Op a b` to Produce Some Value Given an `Int` Argument

```haskell
-- Given a type that produces a value when given an argument
newtype Op a b = Op (b -> a)

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is a function that takes an `Int` to produce a `String`
type HKD_List = HKD (Op String)
```

### Using `Compose f g a` to Model Miscellaenous Types Using `Int`

```haskell
-- Given a type that may contain a value
newtype Compose f g a = Compose (f (g a))

-- and our Higher-Kinded Data type
newtype HKD :: (Type -> Type) -> Type
newtype HKD f = HKD (f Int)

-- the runtime value is `Nothing`, or `Just int`.
type HKD_ComposeMaybeMaybe = HKD (Compose Maybe Unlift)

-- the runtime value is `Nothing`, or `Just boolean`.
type HKD_ComposeMaybeMaybe = HKD (Compose Maybe (Const Boolean))

-- the runtime value is `Nothing`, `Just Nothing`, or `Just int`.
type HKD_ComposeMaybeMaybe = HKD (Compose Maybe Maybe)

-- the runtime value is `Nothing`, `Just (Left string)`, or `Just (Right int)`.
type HKD_ComposeMaybeMaybe = HKD (Compose Maybe (Either String))

-- the runtime value is `Nothing`, `Just Nil`, or `Just intList`.
type HKD_ComposeMaybeMaybe = HKD (Compose Maybe List)

-- the runtime value is `Nil`, `Cons Nothing Nil`, `Cons (Just i) Nil`, or `...`
type HKD_ComposeMaybeMaybe = HKD (Compose List Maybe)
```

You can see how `Compose` makes it possible to do some interesting things.

### Using `Row` kinds, `Record`, and `Variant` to Model Product and Sum Types

Recall that product types (e.g. a AND b) and sum types (e.g. a OR b) are modeled by `Record` and `Variant`. So, what happens when we define a higher-kinded-data type that takes `rows` as the argument that it passes into `f`? It looks like this:

```haskell
data Record :: Row Type -> Type

data Variant :: Row Type -> Type

newtype HKD_Row f = HKD_Row (f (name :: String, age :: Int))

-- the runtime value is a `String` value and an `Int` value
--   { name :: String, age :: Int}`
type HKD_Row_Record = HKD_Row Record

-- the runtime value is either a `String` value or an `Int` value
type HKD_Row_Variant = HKD_Row Variant
```

## Examples Demonstrating Why One Would Use Higher-Kinded data?

### Reducing Boilerplate

Now that we have an understanding for how these work, what happens if we interleave two higher-kinded data types together? We find that we get a number of types for free.
```haskell
type AllTypes recordOrVariant f =
  recordOrVariant ( name :: f String, age :: f Int )

-- { name :: String, age :: Age }
type PersonRecord = AllTypes Record Unlift

-- { name :: Boolean, age :: Boolean }
type PersonDisplayLabels = AllTypes Record (Const Boolean)

-- { name :: Maybe String, age :: Maybe Age }
type PersonSearchLabels = AllTypes Record Maybe

-- Variant (name :: String, age :: Age)
type PersonSingleLabel = AllTypes Variant Unlift

-- Variant (name :: Boolean, age :: Boolean)
type PersonToggleLabel = AllTypes Variant (Const Boolean)
```

### Reusing Labels in Rows for Multiple Things

What if we used a version of `Unlift` that "selects" which type to use among multiple types? `Halogen Formless` uses this trick to use the same labels to refer to different things depending on the context (e.g. the input value, the output value, the error, etc.):
```haskell
data InvalidName = InvalidName
data NotPositiveAge = NotPositiveAge
newtype Name = Name String
newtype Age = Age Int

-- Same as `Unlift` but it only "selects" the correct type
type ErrorType  e i o = e
type InputType  e i o = i
type OutputType e i o = o

type AllTypes :: (Row Type -> Type) -> (Type -> Type) -> Type
type AllTypes recordOrVariant f =
  recordOrVariant
    ( name :: f InvalidName String Name
    , age :: f NotPositiveAge Int Age
  --  label :: f errorType inputType outputType
    )

type FormOutputvalues = AllTypes Record OutputType
type FormErrorsIfAny = AllTypes Record (Compose Maybe ErrorType)
type FormInputValues = AllTypes Record InputType

getName :: FormOutputvalues
getName rec = rec.name

getNameInput :: FormInputValues
getNameInput rec = rec.name

onNameError :: forall m. Monad m => FormErrorsIfAny -> m Unit
onNameError rec = case rec.name of
  Nothing -> pure unit -- no error!
  Just error -> throwError error
```
