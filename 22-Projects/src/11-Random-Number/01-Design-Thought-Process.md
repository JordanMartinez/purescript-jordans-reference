# Design Thought-Process

**Note:** one should read through this project's corresponding test folder's `Test Thought-Process.md` file as it further clarifies a few things said below.

## Level 4 / Core

We'll first define the types we'll be using throughout our program. When I thought about this particular 'domain', I came up with these concepts:

| Type Name | What it is | Properties/Purpose | Implementation
| - | - | - | - |
| Bounds | The lower and upper int boundaries | <ul><li>Property: `lower <= upper`</li><li>Purpose: insures the `RandomInt` and a player's `Guess` are within its bounds</li></ul> | A newtyped `Record` that exports only its smart constructor to insure correct instantiation. Helper functions also exist in the module, some of which are exported.
| RandomInt | The random int the player is trying to guess | <ul><li>Property: `x == lower` or `x == upper` or `lower < x < upper`</li><li>Once created, the value is read-only</li></ul> | A newtyped `Int` that exports only its smart constructor to insure correct instantiation and usage.
| Guess | The guess the player makes | <ul><li>Property: same property as `RandomInt` in relation to `Bounds`</li><li>Purpose: see whether it is equal to the game's `RandomInt`</li></ul> | A newtyped `Int` that exports only its smart constructor to insure correct instantiation. `guessEqualsRandomInt` function is also exported and usable via `==#` infix notation.
| RemainingGuesses | The remaining guesses the player has | <ul><li>The initial value should be positive</li><li>The value can only decrease by one after an incorrect guess</li></ul> | A newtyped `Int` that exports only its smart constructor to insure correct instantiation. `decrement` function correctly reduces the wrapped `Int` by one and `outOfGuesses` checks whether the player can keep playing

## Level 3 / Domain

A game consists of four stages:
1. explaining the rules
2. setting up the game
3. playing it (run the game loop until player wins/loses)
4. output whether the player won/lost

The following image is the general flow of the program:
![Control-Flow](./assets/Control-Flow.svg)

## Level 2 / API

The "effects" or "capabilities" we need to run this program are relatively simple:
- The capability to generate a random `Int` value (Note: this random number generator does not need cryptography-level security)
- The capability to send a message to the user
- The capability to get the user's input:
    - two `Int` values for the `Bounds`
    - one `Int` value for the `RemainingGuesses`
    - an `n` number of guesses

## Level 1 / Infrastructure

Each of the above capabilities can be obtained by a few different things:
- The random number generation can be done via the `Effect.Random (randomInt)` function
- We can "send a message to the user" in one of three ways
    - (Production) Console-based approach: use `Node.ReadLine`
    - (Production) Web-based approach: use `Halogen`
    - (Test) this can be flat out ignored as its purely informative
- We can "get the user's input" in one of three ways:
    - (Production) Console-based approach: use `Node.ReadLine`
    - (Production) Web-based approach: use `Halogen`
    - (Test) provide the next input in a randomly-generated sequence of player guesses

## Level 0 / Machine Code

Production: we'll use `Aff` to run the `Node.ReadLine` and `Halogen` code
Test: we'll use `Effect` and QuickCheck to test our domain logic.

## Code Warning

The browser-based UI you will see for this project will look utterly horrible! This is intentional because it makes the pattern to follow easier to see without CSS and additional events cluttering up the code base
