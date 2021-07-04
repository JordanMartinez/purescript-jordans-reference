# Partial Functions

Partial functions are functions that will not always return an output for every input. An example is integer division:
- `x / 1` produces an output: `x`
- `x / 0` cannot produce an output but will throw an error.

This folder is a summary of the article: [Keep your Types Small and Your Bugs Smaller](http://www.parsonsmatt.org/2018/10/02/small_types.html)

There are three different ways one can handle partial functions in Purescript:
1. Crash on invalid inputs
    - via `Partial`
2. Return an error-container type:
    - via `Maybe a`
    - via `Either String a`
    - via `Either CustomErrorType a`
    - via `Veither errorRows a`
3. Use refined types
    - via `NonZeroInt` (or some other refined type)
4. Return the output on valid inputs and a default value on invalid inputs

## Compilation Instruction

Start the REPL, import the file's module, and pass in different arguments to the function to see what happens

## Other Useful Links

- [Lamda The Ultimate - Pattern Factory](https://github.com/thma/LtuPatternFactory/tree/master) - Explains FP design patterns using OO terms.
