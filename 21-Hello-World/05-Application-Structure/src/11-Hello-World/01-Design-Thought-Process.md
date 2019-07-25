# Design Thought-Process

This program will generate a random number, determine whether that random number is greater than or less to a hard-coded value (to simulate a domain idea) and then print its results.

## Level 4 / Core

For this program now, there are no domain concepts or rules/relationships.

## Level 3 / Domain

The program consists of 1 steps:
1. log "Hello World" to the console

## Level 2 / API

The "effects" or "capabilities" we need to run this program are relatively simple:
- The capability to send a message to the user

## Level 1 / Infrastructure

This capability can be obtained by the runtime system:
- For this program, we will only "send a message to the user" in one way: log it to the console. In future projects, we could also use Halogen (or React) to print a message to our web app.

## Level 0 / Machine Code

Production: we'll use `Effect` as our base monad to run the code
