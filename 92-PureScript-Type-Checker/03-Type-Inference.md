# Type Inference

## The Problem

While the language described so far works, it comes with an annoyance: every single usage of a term must be annotated with a type. In other words, our language is
$$
(terms) \quad e = x {\color{red} :: \tau} | \lambda x. e {\color{red}:: \tau_{1} \rightarrow \tau_{2}} | e_{1} \ e_{2} {\color{red}:: \tau} \\
$$
rather than the below language:
$$
(terms) \quad e = x | \lambda x. e | e_{1} \ e_{2} \\
$$

Or, more concretely..
$$
(\lambda x. (\lambda y. y {\color{red}:: \tau \rightarrow \tau}) {\color{red}:: \tau \rightarrow (\tau \rightarrow \tau)}) (x_{1} {\color{red}:: \tau}) (x_{2} {\color{red}:: \tau})
$$
... vs ...
$$
(\lambda x. \lambda y. y) x_{1} x_{2}
$$

Ideally, the type checker should be able to infer what the type for each term is with no guidance from the programmer.

For our current language, this is possible.

## The Solution

Given that we have the following language where type annotations are removed:

$$
(terms) \quad e = x | \lambda x. e | e_{1} \ e_{2}
$$
$$
(types) \quad \tau = t | \tau \rightarrow \tau
$$

A type-inference algorithm is one that takes as input an environment, $\Gamma$, and an expression, $e$, and returns a type, $\tau$, for that expression. In other words <code>INFER($\Gamma$, $e$)</code> returns <code>$\tau$</code>. We'll express this function as ${\color{orange} \Gamma} \vdash {\color{orange} e} :: {\color{green} \tau}$. It follows the same rules we've seen previously.

- A variable term. The below expression reads, "$x$ has the inferred type $\tau$ if the assumption exists in $\Gamma$."
    $$VAR: {{x :: \tau \in \Gamma}\over{\Gamma \vdash x :: \tau}}$$
- Function definition. The below expression reads, "$\lambda x. e$ has the inferred type $\tau \rightarrow \tau$ if we can infer that $x$ has type $\tau$ while and that $e$ has type $\tau$."
    $$ABS: {{\Gamma_{x} \cup \{x :: \tau' \} \vdash \epsilon :: \tau}\over{\Gamma \vdash (\lambda x. \epsilon) :: \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has the inferred type $\tau$ if we can infer that $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB: {\Gamma \vdash e :: \tau' \rightarrow \tau \qquad \Gamma \vdash e' :: \tau' \over{\Gamma \vdash \epsilon \ \epsilon' :: \tau}}$$
