# Untyped Lambda Calculus

## Overview of Lambda Calculus

Lambda calculus is a language with three terms to it:
- a variable (e.g. `x`)
- a function definition (e.g. `\arg -> body`)
- function application (e.g. `(\arg -> body) actualArg`)

Functions taking more than one arguments are curried. In other words, the first line below (what one normally sees in JavaScript) is expressed in lambda calculus (the second line below) as a function that returns a function:
```
functionName(arg1, arg2, arg3) { body }
\arg1 -> (\arg2 -> (\arg3 -> body))`
```

This simple language can be used to express all computations possible (but such computations are not always the fastest or most efficient in terms of space/time usage). "Computing" using such a language means taking an expression written in lambda calculus and "reducing" it (i.e. if there are functions with unapplied arguments, apply those arguments to their functions) to its "normal form", wherein the resulting expression can no longer be reduced.

For example:
- a variable cannot be reduced any further: `x`
- a function definition cannot be reduced any further: `\arg -> arg`
- a function whose argument has not yet been applied can be reduced:
    - Given: `(\arg -> arg) x`
    - Since `arg` is bound to `x`, replace all appearances of `arg` in the function body with `x`: `x`
    - Expression is fully reduced.

The above three terms are usually represented via:
$$
e = x | \lambda x. e | e_{1} \ e_{2}
$$

The reduction steps taken above were "normal order reduction," whereby one reduces the left-most outer-most function application by applying its argument to the function.

## Nonsensical Programs and Type Systems

While the untyped lambda calculus above can express many things, it also enables one to "compute" an expression that is nonsensical. For example, let's say that `1` is an expression that computes the value `1` using lambda calculus (i.e. Church numeral). The expression, "$(\lambda f. f x) \ 1$", assumes `1` is a function, not a value, passes `x` as an argument to the supposed function, and then produces an undefined result as `1` is not a function.

The above example highlights the first problem with this language: it can express "bad" programs. Ideally, the "perfect" lambda calculus is one that
- has all the computational power of untyped lamda calculus
- rejects all "bad" programs without rejecting any "good" program.

One way to make this error more apparent is by adding a type system to the language. A dynamic type system checks the expressions' types when the program is running. If used on the above example, the program would crash when it discovers that `1` is not a function. While this might be better than getting an undefined result where the program may continue running thereafter, it's still not ideal.

Moreover, the programmer needs to run the program to discover the bug. In simple cases like the one above, the issue may be easily found by the programmer. In more complex cases (e.g. multiple nested if-then-else statements with multiple boolean conditions that are strung together via `&&` and `||`), the programmer may not find the problem initially, and it may take multiple runs before the bug is discovered.

Ideally, an expression's type would be checked before the program runs via a static type system. However, static type systems have access to less information than a dynamic type system because it can only guess, not inspect. Thus, a static type system may reject "good" programs that a dynamic type system would accept.

Here's the tradeoff. As more and more features are added to a static type system that enables it to typecheck more expressive languages, it incurs more and more constraints. A language construct `A`, `B`, and `C` may be easy to add to untyped lambda calculus in isolation. However, adding all three within the same language can significantly complicate the type system. In other situations, it will either not be possible to enable all three or no one has discovered a way to do it yet.

As features are added to a language, one must ask, "But at what cost?" Choosing to support Feature A in Language X may also mean choosing NOT to support Feature B.
