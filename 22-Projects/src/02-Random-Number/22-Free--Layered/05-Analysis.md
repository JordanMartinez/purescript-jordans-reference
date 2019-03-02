# Analysis

This file will analyze our Free-based implementation of the random number guessing game. It will highlight the problems that a `Run`-based implementation would avoid.

## Hard-Coded Language

The first problem is that our language is hard-coded. If we ever wanted to add another member to our Domain or API language, we would effectively need to rewrite the entire file, leading to wasted developer time. Had we written our code using `VariantF` and `Run`, we could compose individual data structures to form the language we want to use.

## Unnecessary Translations

In the Node infrastructure, there's one translation in our code that's actually unnecessary, the API's `Log` translation: `NotifyUser (Domain) ~> Log (API) ~> Effect.Console.log (Infrastructure)`. If we look at the Domain to API translation, we can see that it does nothing more than forward the Domain data to the Infrastructure level:
```purescript
-- Domain -> API
go :: RandomNumberOperationF ~> API
go = case _ of
  NotifyUser msg next -> do
    log msg
    pure next

  -- the others

-- API -> Infrastructure
go :: Interface -> API_F ~> Aff
go iface = case _ of
  Log msg next -> do
    liftEffect $ log msg
    pure next

    -- the others
```

Unfortunately, we cannot translate the `NotifyUser` value to the `Infrastructure`-level. It needs to be translated through an unnecessary API-language data structure.

## Tightly-Coupled Code

Our code is not modular in that one could easily swap out the current "interpreter" of one language term with another (e.g. Domain's `DefineBounds` gets interpreted into API's language terms). In other words, what if we wanted the interpreter to ignore the user's input and just look up the values from a configuration file? Or, what if we wanted the user to have a choice: define it themselves or use the config file?

Both ideas would require us to rewrite the entire API interpreter. Had we written it in `Variant`/`Run`, we could literally swap out one `Domain_Language_Term ~> API_1_Term` translation with another `Domain_Language_Term ~> API_2_Term`

## Unnecessary Usage of UI

In the Halogen infrastructure, we had to generate the random int inside of the component's `eval` function despite never needing the UI to do that. I believe it would be more performant if that value was generated outside of the component since it will run through less 'layers' of Free.
