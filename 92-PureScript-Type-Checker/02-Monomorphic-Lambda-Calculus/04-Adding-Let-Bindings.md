# Adding Let Bindings

## Why Let Bindings Exist

At first, let bindings (i.e. `let variableName = expression in expressionUsingVariableName`) might seem like syntactic sugar for lambdas. For example, `let x = 5 in x + x` could be written:

$$
(\lambda x. x + x) \ 5
$$

Similarly, an expression like, `let x = 5 in let y = 2 in x + x`, where the `y` variable is unused could be written:

$$
(\lambda x. (\lambda y. x + x) \ 2) \ 5
$$

However, this syntactic sugar idea breaks down when we define a function that is used in two places. For example, `let f = \arg. arg + 1 in (f 2) + (f 3)` could be written using lambdas like so:

$$
((\lambda arg. arg + 1) \ 2) + ((\lambda arg. arg + 1) \ 3)
$$

But what happens if we modify one of the lambdas? It doesn't guarantee that the second lambda is also modified. Rather, we have to remember to do modify both anytime we modify one of them.

Unfortunately, remembering to modify all usages of the original function doesn't scale. Maintaining code for the equivalent lambda-based expression for the following let binding would be complicated and error-prone: `let f = \arg. arg + 1 in (f 1) + (f 2) + (f 3) + ... + (f n)`

## Language Modifications

Recall that our language is still monomorphic. Adding let bindings is quite simple then:

$$
(terms) \quad e = i | b | x | {\color{red} let \ x = e_{1} in \ e_{2}} | \lambda x. e | e_{1} \ e_{2}
$$
$$
(types) \quad \tau = Int | Boolean | \tau \rightarrow \tau
$$
$$
(environment) \quad \Gamma = { \{ \\
  (+) :: Int \rightarrow Int \rightarrow Int, \\
  (intEq) :: Int \rightarrow Int \rightarrow Boolean, \\
  (\&\&) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
  (||) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
  (boolEq) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
\}}
$$

## Type Checker and Type Inference Modification

The diagrams for both type checking an expression and type inferring an expression are the same. Only the type checking rules below are shown. For the type inference rules, read a type checking rule "$a$ must have type $Foo$" as "$a$ is inferred to have type $Foo$" and "if $b$ has type $Bar$" as "after inferring that $b$ has type $Bar$".

We add the following rule.

- A let binding. The below expression reads, "$x$ must have type $e_{1} and $e$ must have type $e_{2}$
    $$LET: {\Gamma \vdash e_{1} :: \tau_{1} \qquad \Gamma_{x} \cup { \{ x :: \tau_{1} \} } \vdash e_{2} :: \tau_{2} \over{\Gamma \vdash let \ x = e_{1} in \ e_{2} :: \tau_{2}}}$$

The rest remain unchanged.

- An integer constant term. The below expression reads, "$i$ must have type `Int`."
    $$CONST\_INTEGER: {\over{\Gamma \vdash i :: Int}}$$
- A boolean constant term. The below expression reads, "$b$ must have type `Boolean`."
    $$CONST\_BOOLEAN: {\over{\Gamma \vdash b :: Boolean}}$$
- A variable term. The below expression reads, "$x$ has type $\tau$ if the assumption exists in $\Gamma$."
    $$TAUT: {{x :: \tau \in \Gamma}\over{\Gamma \vdash x :: \tau}}$$
- Function definition. The below expression reads, "$\lambda x. e$ has type $\tau \rightarrow \tau$ if we assume $x$ has type $\tau$ while verifying that $e$ has type $\tau$."
    $$ABS: {{\Gamma_{x} \cup \{x :: \tau' \} \vdash \epsilon :: \tau}\over{\Gamma \vdash (\lambda x. \epsilon) :: \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has type $\tau$ if $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB: {\Gamma \vdash e :: \tau' \rightarrow \tau \qquad \Gamma \vdash e' :: \tau' \over{\Gamma \vdash \epsilon \ \epsilon' :: \tau}}$$
