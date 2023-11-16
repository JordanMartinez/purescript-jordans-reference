# The Function Monad

## A Refresher on Monads

Via the `Box` type, we originally learned what a `Monad` even is. To refresh our memory, a data type can be called a `Monad` if it can implement a law-abiding instance for the `Monad` type class. We then used the `Box` type to introduce "do notation," which desugars into nested `bind`/`>>=` calls.

We later showed that using other monadic types like `Maybe`, `Either`, and `List` led to different control flows. `Maybe` led to a nested if-then-else statement. `Either` was similar but returned something when an error occurred. `List` produced a nested `for` loop.

However, we never stopped to consider the data type, `Function`. When we re-examine the `Function` data type, we'll see that it's naturally a `Monad`.

## Reviewing `Function` as a Data Type

Putting it into syntax, `Function` is defined like this:
```haskell
data Function a b = -- implementation

infix ? Function as ->

-- Thus, when we write this:
intToString :: Int -> String
intToString _ = "a string"

-- It desguars to this:
intToString :: Function Int String
intToString _ = "a string"
```

## Implementing the `Monad` Type Class Hierarchy's Functions

Let's start implement instances for these type classes. For now, take my word for it that these implementations satisfy the laws of their respective type classes.

### Functor

#### Initial Problems

Let's look at `Functor`. It's type signature looks like this.
```haskell
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b
```

This creates the first problem: `Functor` expects a higher-kinded type, `f`, that only takes one type. For example, `Box a` only takes one type. However, `Function a b` takes two types. So, how can this be resolved? We must assume that `Function a b` already has its first type. For example...
```haskell
data Function a b = -- implementation

noTypesDefined :: forall a b. Function a   b
noTypesDefined = -- implementation

oneTypeDefined :: forall   b. Function Int b
oneTypeDefined = -- implementation

allTypesDefined ::            Function Int Int
allTypesDefined = -- implementation
```
To make `Function` higher-kinded by only one type, and not two, we should use something like `oneTypeDefined` above:
```haskell
class Functor (Function inputType) where
```

#### Implementing `map`

Getting back to the problem at hand, here's the type signature for Function's `map` implementation with very helpful names:
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType -> Function inputType newOutputType
```
It should seem pretty obvious how this gets implemented. Let's walk through this slowly.

1. `map` returns a new function whose input is `input`. So, let's use an inline function to do that:
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType -> Function inputType newOutputType
  map originalToNew f = (\input -> {- remaining body of function -} )
```

2. Since `f` is the only function that can "receive" a value of type, `input`, we have to pass that value into `f`. `f` will produce `originalOutput`, so let's store that in a let binding:
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType -> Function inputType newOutputType
  map originalToNew f = (\input ->
    let originalOutput = f input
    in {- remaining body of function -} )
```

3. Since `originalToNew` is the only function that can "receive" a value of type, `originalOutput`, we have to pass the value outputted by `f` into that function. `originalToNew` produces a value of the type, `newOutput`, which gives us the return value of our created function:
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType -> Function inputType newOutputType
  map originalToNew f = (\input ->
    let originalOutput = f input
    in originalToNew originalOutput)
```

As we can see, the types guided us on how to implement this function. If we look at this closer, we can see that it's just function composition.
```haskell
class Functor (Function inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         Function inputType originalOutputType -> Function inputType newOutput
  map originalToNew f = (\input -> originalToNew $ f input)
  -- or
  map originalToNew f = (originalToNew <<< f)
  -- or even
  map = (<<<)
```

In real code, normally we use `a`, `b` as type variable. Therefore, the above snippet will be simplfied to
```haskell
class Functor (Function i) where
  map :: forall a b. (a -> b) -> Function i a -> Function i b
  map = (<<<)
```

#### Takeaways

Our first example taught us two things:
- we have to make `Function` higher-kinded by one less type by specifying its first type (the input) and let the `a` and `b` arguments refer to its second type (the output).
- to implmement the instance, we have to create a new function by using lambda syntax: `\argument -> body`

### Apply

#### Initial Problems

Let's now look at `Apply`'s `apply` function. It's type signature looks like this.
```haskell
class (Functor f) <= Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b
```

Again, let's take this slowly. Notice first the first argument, what should the full type signature of `f (a -> b)` be if `f` is `Function`? Since the `f` has to be the same for both situations, then `f` has to be `Function input`. In other words, the first argument is a function that returns another function:
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
```

#### Implementing `apply`

Let's see how to implement this function.

1. Since `apply` returns a new function, let's start creating one using lambda syntax:
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input -> {- body of function -})
```

2. At this point, both `f` and `functionInFunction` can receive an value of type, `input`. For right now, let's do what we did last time and only pass it into `f`. We'll store the output in a let binding:
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input ->
    let originalOutput = f input
    in {- body of function -})
```

3. At this point, the only way to get map `originalOutput` into `newOutput` is to pass it into the function that's hidden in `functionInFunction`. How do we get that out? We can pass `input` into that function. Again, we'll store that output in a let binding:
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input ->
    let
      originalOutput = f input
      originalToNew = functionInFunction input
    in {- body of function -})
```

4. We now have all the pieces we need to return `newOutput`. Let's pass `originalOutput` into `originalTonew`:
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input ->
    let
      originalOutput = f input
      originalToNew = functionInFunction input
    in originalToNew originalOutput)
```

Great! Can we clean it up now?
```haskell
class (Functor (Function inputType)) <= Apply (Function inputType) where
  apply :: forall originalOutputType newOutputType.
           Function inputType (originalOutputType -> newOutputType) ->
           Function inputType  originalOutputType ->
           Function inputType  newOutputType
  apply functionInFunction f = (\input -> (functionInFunction input) (f input))
```

#### Takeaways

Our second example taught us the following:
- to get all the pieces necessary to implement a type class' function, we sometimes need to pass the input value into multiple functions.

### Applicative

Let's now look at `Applicative`'s `pure` function. It's type signature looks like this.
```haskell
class (Apply f) <= Applicative f where
  pure :: forall a. a -> f a
```

Converting `f` into `Function input`, we get this type signature:
```haskell
class (Apply (Function inputType)) <= Applicative (Function inputType) where
  pure :: forall outputType. outputType -> Function inputType outputType
```

Let's see how to implement it.

1. Since `pure` returns a new function, let's start creating one using lambda syntax:
```haskell
class (Apply (Function inputType)) <= Applicative (Function inputType) where
  pure :: forall outputType. outputType -> Function inputType outputType
  pure value = (\input -> {- body of function -})
```

2. Since the function must return `value` as its output, let's ignore the argument and just return that value.
```haskell
class (Apply (Function inputType)) <= Applicative (Function inputType) where
  pure :: forall outputType. outputType -> outputType
  pure value = (\input -> value)
```

Let's clean this one up:
```haskell
class (Apply (Function inputType)) <= Applicative (Function inputType) where
  pure :: forall outputType. outputType -> Function inputType outputType
  pure value = (\_ -> value)
```

### Bind

#### Implementing `bind`

Let's now look at `Bind`'s `bind` function. It's type signature looks like this.
```haskell
class (Functor m) <= Bind m where
  bind :: forall a b. (a -> m b) -> m a -> m b
```

Converting `m` into `Function input`, we get this type signature:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
```

Let's see how to implement it.

1. Since `bind` returns a new function, let's start creating one using lambda syntax:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutput -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input -> {- body of function -})
```

2. Since `f` is the only function that can "receive" the `input` value, let's pass it into `f` and store the output:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input ->
    let originalOutput = f input
    in {- body of function -})
```

3. Since `originalToFunction` can "receive" the `originalOutput` value, let's pass that into `originalToFunction` and store its result in a let binding:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input ->
    let
      originalOutput = f input
      inputToNewOutput = originalToFunction originalOutput
    in {- body of function -})
```

4. Since `inputToNewOutput` is the only function that can produce the `newOutput` value, let's pass `input` into it to get that value:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input ->
    let
      originalOutput = f input
      inputToNewOutput = originalToFunction originalOutput
    in inputToNewOutput input)
```

Let's now clean it up. First we'll get rid of that `inputToNewOutput` binding:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input ->
    let
      originalOutput = f input
    in (originalToFunction originalOutput) input)
```

Second, we'll get rid of that `originalOutput` binding:
```haskell
class (Apply (Function inputType)) <= Bind (Function inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> Function inputType newOutputType) ->
          Function inputType originalOutputType ->
          Function inputType newOutputType
  bind originalToFunction f = (\input -> (originalToFunction (f input)) input)
```

As can be seen, this example was a slightly more complicated version of `apply` in that we needed to pass `input` to multiple functions.

## Summary of Our Takeaways

- `map` example:
    - we have to make `Function` higher-kinded by one less type by specifying its first type (the input) and let the `a` and `b` arguments refer to its second type (the output).
    - to implmement the instance, we have to create a new function by using lambda syntax: `\argument -> body`
- `apply`/`bind` example:
    - to get all the pieces necessary to return the `b`/`newOutput` value, we sometimes need to pass the `input` value into multiple functions.

## Resugaring `Function`

In our code above, we desugared `(a -> b)` into `Function a b`. What would happen if we resugared our type class instances above back into `->`? How would we write it then?
```haskell
class Functor ((->) inputType) where
  map :: forall originalOutputType newOutputType.
         (originalOutputType -> newOutputType) ->
         (inputType -> originalOutputType) -> (inputType -> newOutputType)
  map originalToNew f = (\input ->
    let originalOutput = f input
    in originalToNew originalOutput)

class (Functor ((->) inputType)) <= Apply ((->) inputType) where
  apply :: forall originalOutputType newOutputType.
           (inputType -> (originalOutputType -> newOutputType)) ->
           (inputType -> originalOutputType) ->
           (inputType -> newOutputType)
  apply functionInFunction f = (\input ->
    let
      originalOutput = f input
      originalToNew = functionInFunction input
    in originalToNew originalOutput)

class (Apply ((->) inputType)) <= Applicative ((->) inputType) where
  pure :: forall outputType. outputType -> (inputType -> outputType)
  pure value = (\_ -> value)

class (Apply ((->) inputType)) <= Bind ((->) inputType) where
  bind :: forall originalOutputType newOutputType.
          (originalOutputType -> (inputType -> newOutputType)) ->
          (inputType -> originalOutputType) ->
          (inputType -> newOutputType)
  bind originalToFunction f = (\input ->
    let
      originalOutput = f input
      inputToNewOutput = originalToFunction originalOutput
    in inputToNewOutput input)
```
