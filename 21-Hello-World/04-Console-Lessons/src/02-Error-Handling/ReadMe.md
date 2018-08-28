# Error Handling

This folder will demonstrate the four different ways one can handle errors in Purescript, from least type-safe to most type-safe:
- via `Partial`
- via `Maybe a`
- via `Either String a`
- via `Either CustomErrorType a`

It tries to not use any other libraries beyond that to which the user has already been exposed, unless it is the topic being explained. The code demonstrated here is likely not the best way to code a program that seeks to solve the given problem. Rather, it uses the simplest possible problem to demonstrate how to handle errors.
