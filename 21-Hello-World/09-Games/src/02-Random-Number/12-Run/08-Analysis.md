# Analysis

This file will analyze our Run-based implementation of the random number guessing game.

By using a `Run-based` implementation, we were able to solve the following Free-based issues:
1. Inability to add another member/term to one of our "languages".
2. Inability to rewrite an interpreter due to tightly-coupled code
3. Unnecessary translation from `NotifyUser (Domain)` to `Effect.Console.log (Infrastructure)` through the middle-man language `Log (API)`.
4. Unnecessary usage of UI to generat a random integer.

The solution lies in `VariantF`, which `Run` wraps in a nice way.
