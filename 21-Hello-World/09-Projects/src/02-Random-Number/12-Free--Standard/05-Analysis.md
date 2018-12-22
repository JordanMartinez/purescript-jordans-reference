# Analysis

This file will analyze our Free-based implementation of the random number guessing game. It will highlight the problems that a `Run`-based implementation would avoid.

## Hard-Coded Language

The first problem is that our language is hard-coded. If we ever wanted to add another member to our Domain or API language, we would effectively need to rewrite the entire file, leading to wasted developer time. Had we written our code using `VariantF` and `Run`, we could compose individual data structures to form the language we want to use.
