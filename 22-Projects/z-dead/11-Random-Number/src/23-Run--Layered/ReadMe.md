# Run

`Core.purs` to `Infrastructure.purs` is a almost an exact copy of the `Free`-based example from before, just written in the `VariantF`/`Run` style. The only change (see `API.purs` and `Infrastructure.purs`) is that the `API` level language does not include a `Log` term. Instead, the Domain `NotifyUser` term is directly "interpreted" into the Infrastructure-level effect that logs the message to the console.

The remaining two files solve the issues we raised earlier in the Free-based folder:
- `Change-Implementation.purs` uses the first version and changes the normal `MakeGuessF ~> API` "interpretation" to ask the user to confirm their guess before passing the `Guess` value to the Domain level
- `Add-Domain-Term.purs` uses the first version and adds another term, `TellJoke`, to the Domain level. When the user has only one guess left, the computer will tell a terrible joke to ease the player's stress levels.

## Translating Between Languages

To "translate" or "interpret" one language to the next, we follow this pattern:
```purescript
{-
data SourceLanguage
  = Term1
  | Term2                                                             -}

data Term1F a = Term1F a
type TERM_1 r = (term1 :: FProxy Term1F)
-- smart constructor for `term1F`

data Term2F a = Term2F a
type TERM_2 r = (term2 :: FProxy Term2F)                              {-
-- smart constructor for `term2F`

data TargetLanguage
  = TermA
  | TermB                                                             -}

data TermAF a = TermAF a
type TERM_A r = (termA :: FProxy TermAF)
-- smart constructor for `termAF`

data TermBF a = TermBF a
type TERM_B r = (termB :: FProxy TermBF)
-- smart constructor for `termBF`

-- Define an algebra that maps one of the source language's terms
-- to one or more of the target language's terms:
term1_to_TargetLanguage :: forall r
                         . Term1F
                           -- Note: we can exclude TERM_B
                           -- if we don't need it.
                        ~> Run (TERM_A + TERM_B + r)
term1_to_TargetLanguage (Term1F next) = do
  -- translation goes here...
  pure next

-- Define the translation from one language's terms
-- to the next language's terms.
translate :: forall r
             -- Define the first run, so that it includes
             -- both languages' terms and `r`
           . Run (TERM_1 + TERM_2

                  TERM_A + TERM_B + r)

             -- Define the second run, so that it
             -- only includes the target language's terms
          ~> Run (TERM_A + TERM_B + r)
translate = interpret (
  send
    -- translate each term to the target language's terms
    # on _term1 term1_to_TargetLanguage
    # on _term2 term2_to_TargetLanguage                            {-
    ...
    # on _termX termX_to_TargetLanguage                            -}
  )
```
Following this pattern above, we can eventually translate/interpret a `Run` monad into one of two things:
- an effect monad via `Effect` or `Aff`
- a purely computed value via `extract`
