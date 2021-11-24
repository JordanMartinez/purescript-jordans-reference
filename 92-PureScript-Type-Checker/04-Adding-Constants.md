# Adding Constants

## Language Modification

To help explain additional concepts in the future, we'll modify our language to have constants. For example, rather than saying, "Assume `1` represents the value `1` encoded as a Church numeral", we'll just support the concept of `1` explicitly.

A literal integer will be represented at the term level via `i` and at the type level via `Int`. A literal boolean will be represented at the term level via `b` and at the type level via `Boolean`::

$$
(terms) \quad e = {\color{red} i | b } | x | \lambda x. e | e_{1} \ e_{2}
$$
$$
(types) \quad \tau = {\color{red} Int | Boolean} | \tau \rightarrow \tau
$$

In addition to these types, we'll also assume that $\Gamma$ includes the following functions for working on such types (i.e. `+`, `&&`, `||`, and a monomorphic `eq` for each type):

$$
(environment) \quad \Gamma = { \{ \\
  (+) : Int \rightarrow Int, \\
  (intEq) :: Int \rightarrow Int \rightarrow Boolean, \\
  (\&\&) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
  (||) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
  (boolEq) :: Boolean \rightarrow Boolean \rightarrow Boolean, \\
\}}
$$

Finally, for readability, we'll assume infix notation is possible for these functions. So, the non-lambda-like expression $1 + 20$ desugars to the lambda-like expression $(+) \ 1 \ 20$.

Thus, we can now write expressions like $(\lambda x. intEq (x + 20) 21) \ 1$.

## Type Checker Modification

We add the following rule.

- An integer constant term. The below expression reads, "$i$ must have type `Int`."
    $$CONST\_INTEGER : {\over{\Gamma \vdash i : Int}}$$
- A boolean constant term. The below expression reads, "$b$ must have type `Boolean`."
    $$CONST\_BOOLEAN : {\over{\Gamma \vdash b : Boolean}}$$

The rest remain unchanged.

- A variable term. The below expression reads, "$x$ has type $\tau$ if the assumption exists in $\Gamma$."
    $$TAUT: {{x : \tau \in \Gamma}\over{\Gamma \vdash x : \tau}}$$
- Function definition. The below expression reads, "$\lambda x. e$ has type $\tau \rightarrow \tau$ if we assume $x$ has type $\tau$ while verifying that $e$ has type $\tau$."
    $$ABS: {{\Gamma_{x} \cup \{x : \tau' \} \vdash \epsilon : \tau}\over{\Gamma \vdash (\lambda x. \epsilon) : \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has type $\tau$ if $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB: {\Gamma \vdash e : \tau' \rightarrow \tau \qquad \Gamma \vdash e' : \tau' \over{\Gamma \vdash \epsilon \ \epsilon' : \tau}}$$

## Type Inference Modification

We add the following rule.

- An integer constant term. The below expression reads, "$i$'s inferred type is always `Int`."
    $$CONST\_INTEGER : {\over{\Gamma \vdash i : Int}}$$
- A boolean constant term. The below expression reads, "$b$'s inferred type is always `Boolean`."
    $$CONST\_BOOLEAN : {\over{\Gamma \vdash b : Boolean}}$$

The rest remain unchanged.

- A variable term. The below expression reads, "$x$ has the inferred type $\tau$ if the assumption exists in $\Gamma$."
    $$VAR: {{x : \tau \in \Gamma}\over{\Gamma \vdash x : \tau}}$$
- Function definition. The below expression reads, "$\lambda x. e$ has the inferred type $\tau \rightarrow \tau$ if we can infer that $x$ has type $\tau$ while and that $e$ has type $\tau$."
    $$ABS: {{\Gamma_{x} \cup \{x : \tau' \} \vdash \epsilon : \tau}\over{\Gamma \vdash (\lambda x. \epsilon) : \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has the inferred type $\tau$ if we can infer that $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB: {\Gamma \vdash e : \tau' \rightarrow \tau \qquad \Gamma \vdash e' : \tau' \over{\Gamma \vdash \epsilon \ \epsilon' : \tau}}$$
