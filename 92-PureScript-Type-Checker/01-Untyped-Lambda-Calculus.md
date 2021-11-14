## The Basics of an Untyped Lambda Calculus

Lambda calculus is a language with three terms to it:
- a variable (e.g. `x`)
- a function definition (e.g. `\arg -> body`)
- function application (e.g. `(\arg -> body) actualArg`)

Functions taking more than one arguments are curried. In other words, the first line below (what one normally sees in JavaScript) is expressed in lambda calculus as a function that returns a function:
```
functionName(arg1, arg2, arg3) { body }
\arg1 -> (\arg2 -> (\arg3 -> body))`
```

This simple language can be used to express all computations possible (but such computations are not always the fastest or most efficient in terms of space/time usage). "Computing" using such a language means taking an expression written in lambda calculus and "reducing" it (i.e. if there are functions with unapplied arguments, apply those arguments to their functions) to its "normal form", wherein the resulting expression can no longer be reduced. For example:
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

While the untyped lambda calculus above can express many things, it also enables one to "compute" an expression is nonsensical. For example, let's say that `1` is an expression that computes the value `1` using lambda calculus (i.e. Church numeral). The expression, "$(\lambda f. f x) \ 1$", assumes `1` is a function, not a value, passes `x` as an argument to the supposed function, and then produces an undefined result as `1` is not a function.

The above example highlights the first problem with this language: it can express "bad" programs. One way to make this error more apparent is by adding a type system to the language. A dynamic type system checks the expressions' types when the program is running. If used on the above example, the program would crash when it discovers that `1` is not a function. Ideally, the programmer would not need to run the program to discover this fact. In simple cases like the one above, the issue may be easily found by the programmer. In more complex cases (e.g. multiple nested if-then-else statements with multiple boolean conditions that are strung together via `&&` and `||`), the programmer may not find the problem and it may take multiple runs before it is discovered. For some programs, such a bug can result in an expensive lawsuit.

On the other hand, a static type system checks an expression's type before it is run. Since it can only analyze the expression rather than run it, static type systems have access to less information than a dynamic type system. Thus, a static type system may reject "good" programs that a dynamic type system would accept.

Ideally, the "perfect" lambda calculus is one that
- has all the computational power of untyped lamda calculus
- rejects all "bad" programs without rejecting any "good" program.
