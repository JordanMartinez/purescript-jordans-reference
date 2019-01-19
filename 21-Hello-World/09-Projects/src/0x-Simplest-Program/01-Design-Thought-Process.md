# Design Thought-Process

This program will generate a random number, determine whether that random number is greater than or less to a hard-coded value (to simulate a domain idea) and then print its results.

## Level 4 / Core

We'll first define the types we'll be using throughout our program. Since the only domain-specifc idea we want to model is a hard-coded number that has no properties or relationships with other values, this will be simple:

| Type Name | What it is | Properties/Purpose | Implementation
| - | - | - | - |
| HardCodedInt | Something to simulate a domain concept we're trying to model | it can be less than, equal to, or greater than, a randomly-generated number | a newtyped `Int`

## Level 3 / Domain

The program consists of 2 steps:
1. generate a random number
2. log whether this value is less than, equal to, or greater than our hard-coded value

The following image is the general flow of the program:
![Control-Flow](./images/Control-Flow.svg)

## Level 2 / API

The "effects" or "capabilities" we need to run this program are relatively simple:
- The capability to generate a random `Int` value (Note: this random number generator does not need cryptography-level security)
- The capability to send a message to the user

## Level 1 / Infrastructure

Each of the above capabilities can be obtained by a few different things:
- The random number generation can be done via the `Effect.Random (randomInt)` function
- For this program, we will only "send a message to the user" in one way: log it to the console. In future projects, we could also use Halogen (or React) to print a message to our web app.

## Level 0 / Machine Code

Production: we'll use `Effect` as our base monad to run the code
Test: we'll use `Identity` as our base monad and QuickCheck to test our domain logic.
