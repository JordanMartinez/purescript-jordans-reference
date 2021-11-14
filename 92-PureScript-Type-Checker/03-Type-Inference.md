## Type Inference

While the above language works, it comes with an annoyance: every single usage of a term must be annotated with a type. In other words, our language is
$$
(terms) \quad e = x {\color{red} : \tau} | \lambda x. e {\color{red}: \tau_{1} \rightarrow \tau_{2}} | e_{1} \ e_{2} {\color{red}: \tau} \\
$$
rather than the below language:
$$
(terms) \quad e = x | \lambda x. e | e_{1} \ e_{2} \\
$$
Ideally, the type checker would itself be able to infer what the type for each term is with no guidance from the programmer. If this ideal cannot be achieved, then the next ideal is one in which the programmer only needs to provide type annotations to some terms some of the time.

### Unification: Type-Checking an Expression

### The Bounds Check

For example, the expression, `(\x. x x) (\x. x x)`, is an infinite loop: applying the function argument to the function produces the same expression.

Returning to the "bad" program we had previously...
$$
(\lambda x. x x) (\lambda x. x x)
$$
...here is its visual:

