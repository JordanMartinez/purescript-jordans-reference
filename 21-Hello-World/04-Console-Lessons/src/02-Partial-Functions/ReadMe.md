# Partial Functions

This folder will use the problem of dividing two integers to demonstrate the four different ways one can handle partial functions in Purescript:
- via `Partial`
- via `Maybe a`
- via `Either String a`
- via `Either CustomErrorType a`

It tries to not use any other libraries beyond that to which the user has already been exposed, unless it is the topic being explained. The code demonstrated here is likely not the best way to code a program that seeks to solve the given problem. Rather, it uses the simplest possible problem (divison) to demonstrate how to handle errors.

## Total vs Partial Functions

A total function is a function that ALWAYS outputs a value
for every input it can receive

A partial function is a function that SOMETIMES outputs a value
for every input it can receive. In other words, sometimes
it cannot return a value when given specific arguments.
In such situations, it usually returns `null` or throws an Error/Exception.

A good example is division:

| Expression | Outputs
| - | - |
| 5 / 1      | Valid value
| x / 0      | ???
