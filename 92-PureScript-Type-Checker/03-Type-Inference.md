## Type Inference

While the language described so far works, it comes with an annoyance: every single usage of a term must be annotated with a type. In other words, our language is
$$
(terms) \quad e = x {\color{red} : \tau} | \lambda x. e {\color{red}: \tau_{1} \rightarrow \tau_{2}} | e_{1} \ e_{2} {\color{red}: \tau} \\
$$
rather than the below language:
$$
(terms) \quad e = x | \lambda x. e | e_{1} \ e_{2} \\
$$

Or, more concretely..
$$
(\lambda x. (\lambda y. y {\color{red}: \tau \rightarrow \tau}) {\color{red}: \tau \rightarrow (\tau \rightarrow \tau)}) (x_{1} {\color{red}: \tau}) (x_{2} {\color{red}: \tau})
$$
... vs ...
$$
(\lambda x. \lambda y. y) x_{1} x_{2}
$$

Ideally, the type checker should be able to infer what the type for each term is with no guidance from the programmer.

For our current language, this is possible.

### Unification: Type-Checking an Expression

### The Bounds Check

For example, the expression, `(\x. x x) (\x. x x)`, is an infinite loop: applying the function argument to the function produces the same expression.

Returning to the "bad" program we had previously...
$$
(\lambda x. x x) (\lambda x. x x)
$$
...here is its visual:

