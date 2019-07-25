# Foundations

Many people find it very difficult to understand how Monad Transformers actually work. I believe it's because new learners are exposed to too many new things at once, so that they get overwhelemed and likely don't understand why they don't understand.

Rather than jumping into an explanation of what monad transformers are, I'm going to build the necessary scaffolding to make understanding them easier. At the very end, I'll begin to show what problem they solve.

In short, monad transformers make it easier to adhere to the Onion Architecture, so that one can easily test and run their business logic by swapping out the "infrastructure" used. For example, my random number game can use the Terminal environment to allow the player to input their guesses when I am actually running the program. If I want to test my program's business logic, I can "simulate" the user's guesses in a test environment.

In both cases, the same business logic is used, and adjusting it will affect both the real-world use of it and the tests. In other words, there is no 'syncing' problem here between the real business logic that runs my code and the business logic I test.

## Folder's Contents

In this folder, we'll show that a `Function` can be a Monad and then show how to convert it into a Monad Transformer.

At the very end, we'll summarize why monad transformers are useful and give an overview of how they work.
