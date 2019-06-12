# Analysis

This file will analyze our 'layered' Run-based implementation of the random number guessing game.

By using a `Run-based` implementation, we were able to solve the following 'layered' Free-based issues:
1. Inability to add another member/term to one of our "languages".
2. Inability to rewrite an interpreter due to tightly-coupled code

We also defined our languages in a more modular format that we composed via `VariantF`. This allowed us to easily bypass the intermediate language `Log` (Low-Level Domain) when interpreting `NotifyUser` (High-Level Domain) to `Aff` (Main).

The solution lies in two parts:
1. using modular langauges that compose into a final language for a given level
2. using `VariantF`, which `Run` wraps in a nice way.
