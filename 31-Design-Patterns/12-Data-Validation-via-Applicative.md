# Applicative Data Validation

Or how to validate data using Applicatives.

The following provides a quicker summary of the [same chapter in Purescript By Example](https://book.purescript.org/chapter7.html). However, one should read the chapter if they are not already familiar with this concept.

## Possible Choices

Data Validation usually "returns" two of four values:
1. the validated data
2. the first error encountered, whether or not the yet-to-be-validated data after it was valid or not, and...
    - a) ... we don't care what the error was
    - b) ... we do care what the error was
3. all the errors encountered after attempting to validate all parts of the data

Which Applicative type we use depends on what which of the two values we want:

| What we want | What we use|
| - | - |
| 1 & 2a | Maybe |
| 1 & 2b | Either |
| 1 & 3 | [`V`](https://pursuit.purescript.org/packages/purescript-validation/4.0.0/docs/Data.Validation.Semigroup#t:V) |

The difference between `Either` and `V` is their implementation of `Apply`. Either's [`apply`](https://github.com/purescript/purescript-either/blob/v4.0.0/src/Data/Either.purs#L44-L78) does not combine two errors together via a `Semigroup` constraint like `V`'s [`apply`](https://github.com/purescript/purescript-either/blob/v4.0.0/src/Data/Either.purs#L44-L78)

## The Pattern

To validate data, it follows this idea:
```haskell
mkData :: forall a b. a -> a -> b
mkData arg1 arg2 = B_Constructor arg1 arg2

isValidM :: Arg -> Maybe Unit
isValidM invalidArg = Nothing
isValidM validArg = pure unit

isValidE :: Arg -> Either Error Unit
isValidE invalidArg = Left Error
isValidE validArg = pure unit

isValidV :: Arg -> V (Array Error) Unit
isValidV invalidArg = V $ Left Error
isValidV validArg = pure unit

validateData :: Args -> Maybe ValidData
validateData :: Args -> Either Error ValidData
validateData :: Args -> V (Array Error) ValidData
validateData a =
  mkData <$> (isValid a.arg1 *> pure a.arg1)
         <*> (isValid a.arg2 *> pure a.arg2)
    --   <*> (isValid a.argN *> pure a.argN)
```

<hr>

I'm not sure how useful this will be, but I thought I'd put it here:
[Lazy Validation](https://ro-che.info/articles/2019-03-02-lazy-validation-applicative)
