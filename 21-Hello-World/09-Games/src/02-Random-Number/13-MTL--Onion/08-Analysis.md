# Analysis

This file will analyze our MTL-based implementation of the random number guessing game.

The MTL code was somewhat easier to write initially. We did not need to implement a number of boilerplate smart constructors before we could write our default functions for each level of code.

However, our examples of changing the implementation and adding a domain term showed some a potential problem when implementing code in this style. In the original `Infrastructure.purs` file, what if `AppM`'s instances were the only places where our `coreToDomain`, or `domainToAPI`, etc. functions were written? For example, if we had written our code like this...

```purescript
instance defineBoundsToAPI :: DefineBounds AppM where
  defineBounds = do
    notifyUser "<truncated for readability>"

    bounds <- recursivelyRunUntilPure
      (mkBounds
        <$> getIntFromUser "Please enter either the lower or upper bound: "
        <*> getIntFromUser "Please enter the other bound: ")

    notifyUser $ "The random number will be between " <> show bounds <> "."
    pure bounds
```

... then, if we wanted to write `Change-Implementation.purs` or `Add-Domain-Term.purs` later, we would have had to re-implement those functions for each version of our `AppM`:
```purescript
instance defineBoundsToAPI :: DefineBounds AppWithChange where
  defineBounds = do
    notifyUser "<truncated for readability>"

    bounds <- recursivelyRunUntilPure
      (mkBounds
        <$> getIntFromUser "Please enter either the lower or upper bound: "
        <*> getIntFromUser "Please enter the other bound: ")

    notifyUser $ "The random number will be between " <> show bounds <> "."
    pure bounds

instance defineBoundsToAPI :: DefineBounds AppWithJoke where
  defineBounds = do
    notifyUser "<truncated for readability>"

    bounds <- recursivelyRunUntilPure
      (mkBounds
        <$> getIntFromUser "Please enter either the lower or upper bound: "
        <*> getIntFromUser "Please enter the other bound: ")

    notifyUser $ "The random number will be between " <> show bounds <> "."
    pure bounds
```

Fortunately, I foresaw this potential problem and decided to write the "default" functions for each level translation/interpretation in their respective files. Thus, by writing things this way...
```purescript
-- in `MTL/API.purs`
defineBoundsToAPI :: forall m.
                NotifyUser m =>
                GetUserInput m =>
                m Bounds
defineBoundsToAPI = do
  notifyUser "Please, define the range from which to choose a \
             \random integer. This could be something easy like '1 to 5' \
             \or something hard like `1 to 100`. The range can also include \
             \negative numbers (e.g. '-10 to -1' or '-100 to 100')"

  bounds <- recursivelyRunUntilPure
    (mkBounds
      <$> getIntFromUser "Please enter either the lower or upper bound: "
      <*> getIntFromUser "Please enter the other bound: ")

  notifyUser $ "The random number will be between " <> show bounds <> "."
  pure bounds
```
... we avoided that problem by reusing our default implementation in each instance
```purescript
-- In Infrastructure.purs
instance defineBounds1 :: DefineBounds AppM where
  defineBounds = defineBoundsToAPI

-- In Change-Implementation.purs
instance defineBounds2 :: DefineBounds AppWithChange where
  defineBounds = defineBoundsToAPI

-- In Add-Domain-Term.purs
instance defineBounds3 :: DefineBounds AppWithJoke where
  defineBounds = defineBoundsToAPI
```
