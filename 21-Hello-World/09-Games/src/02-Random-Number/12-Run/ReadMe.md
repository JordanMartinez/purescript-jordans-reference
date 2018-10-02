# Run

`Core.purs` to `Infrastructure.purs` is a almost an exact copy of the `Free`-based example from before, just written in the `VariantF`/`Run` style. The only change (see `API.purs` and `Infrastructure.purs`) is that the `API` level language does not include a `Log` term. Instead, the Domain `NotifyUser` term is directly "interpreted" into the Infrastructure-level effect that logs the message to the console.

The remaining two files solve the issues we raised earlier in the Free-based folder:
- `Change-Implementation.purs` uses the first version and changes the normal `MakeGuessF ~> API` "interpretation" to ask the user to confirm their guess before passing the `Guess` value to the Domain level
- `Add-Domain-Term.purs` uses the first version and adds another term, `TellJoke`, to the Domain level. When the user has only one guess left, the computer will tell a terrible joke to ease the player's stress levels.
