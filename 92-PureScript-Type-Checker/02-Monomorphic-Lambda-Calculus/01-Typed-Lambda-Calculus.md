# Typed Lambda Calculus

To address the problem raised above, we need a tool that checks the expression. This tool is composed of two parts:
1. annotating terms with monomorphic types
1. typechecking the resulting expression's type.

## Adding Monomorphic Types

The first restriction made to lambda calculus is annotating terms with monomorphic types. For example:

A type, $\tau$, is one of the following:
1. a primitive type, $t$
2. a function type, $\tau \rightarrow \tau$

$$
(types) \quad \tau = t | \tau \rightarrow \tau
$$

Examples include:
- $t$
- $t \rightarrow t$
- $t \rightarrow (t \rightarrow t)$
- $(t \rightarrow t) \rightarrow (t \rightarrow t)$

A term, $e$, is one of the following:
1. a variable
2. a function definition
3. function application:

$$
(terms) \quad e = x :: \tau | \lambda x. e :: \tau_{1} \rightarrow \tau_{2} | e_{1} \ e_{2} :: \tau \\
$$

When using LaTeX, $x :: \tau$ reads "The expression $x$ has type $\tau$.

Examples of the above language:
- $x :: \tau$
- $\lambda x. \lambda y. y :: \tau_{1} \rightarrow \tau_{2} \rightarrow \tau_{2}$
- $\lambda x. \lambda y. x \ y :: (\tau_{1} \rightarrow \tau_{2}) \rightarrow \tau_{1} \rightarrow \tau_{2}$

## The Simplest Type Checker

The second part is the type checker. The type checker uses one rule for each term to determine whether the expression is "well-typed." Before covering the rules, it's necessary to introduce syntax frequently used in type systems.

### Explaining the Visuals

A horizontal bar (below) is often used in this syntax. This bar visual typically represents the following idea:: $Conclusion$ is true if and only if $Premise$ is true:
$$
{
Premise
}\over{
  Conclusion
}
$$

If the top part of the bar is empty, then there's nothing to prove:
$$
{
}\over
{
  Conclusion
}
$$

The visual is read from bottom-to-top, left-to-right. For example, reading each number below in order is the same the order in which one would read the visual:
$$
{
\#2 \quad \quad \#3
}\over{
  \#1 \ \#4
}
$$

In some situations, the bar can have multiple levels of nesting:
$$
{
{
  {\large \#3 \quad \#4}\over{\large \#2 \ \#5}
} \quad \quad {
  {\large \#7 \quad \#8}\over{\large \#6 \ \#9}
}
}\over{
  \#1 \ \#10
}
$$

$\Gamma$ (pronounced "Gamma") represents a set of assumptions. Each assumption indicates what type a given term has. Here are some examples of what $\Gamma$ might represent:
- $\{\}$ - the empty set:: no assumptions exist yet
- $\{ x :: i \}$ - a set with one assumption where $x$ has type $\tau$.
- $\{ x :: i, f :: i \rightarrow i \}$ - a set with two assumptions
  - $x$ has type $i$
  - $f$ has type $i \rightarrow i$.

$\Gamma_{x}$ means it does not currently have any assumptions about that variable

If $\Gamma$ appears as is below and above the bar, then its set of assumptions remains unchanged:

$$
{
\Gamma
}\over{
  \Gamma
}
$$

In some cases, $\Gamma$ may be extended on the top bar, so that it includes a new assumption. Below $\Gamma$ has been extended to include a new assumption, that $x$ has type $\tau$:

$$
{
\Gamma_{x} \cup \{ x :: \tau \}
}\over{
  \Gamma
}
$$

$\vdash$ separates $\Gamma$ from the rest of the expression.

$$
\Gamma \vdash expression
$$

### Type Checker Rules

Below is our language so far:

$$
(terms) \quad e = x :: \tau | \lambda x. e :: \tau_{1} \rightarrow \tau_{2} | e_{1} \ e_{2} :: \tau \\
$$
$$
(types) \quad \tau = t | \tau \rightarrow \tau
$$

With the visuals explained, each term above has a corresponding rule with how to check its type:

- A variable term. The below expression reads, "$x$ has type $\tau$ if the assumption exists in $\Gamma$."
    $$TAUT:: {{x :: \tau \in \Gamma}\over{\Gamma \vdash x :: \tau}}$$
- Function definition. The below expression reads, "$\lambda x. e$ has type $\tau \rightarrow \tau$ if we assume $x$ has type $\tau$ while verifying that $e$ has type $\tau$."
    $$ABS:: {{\Gamma_{x} \cup \{x :: \tau' \} \vdash \epsilon :: \tau}\over{\Gamma \vdash (\lambda x. \epsilon) :: \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has type $\tau$ if $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB:: {\Gamma \vdash e :: \tau' \rightarrow \tau \qquad \Gamma \vdash e' :: \tau' \over{\Gamma \vdash \epsilon \ \epsilon' :: \tau}}$$

#### Example 1

The expression $\lambda f. \lambda x. x$ would produce the following visual:
$$\large
      ABS: {\large
        {\large ABS:
          {\large {\large TAU:
            {\large {\large x :: \tau' \in \{f :: \tau,\ x :: \tau' \}}\over{\large
              \{f :: \tau,\ x :: \tau' \} \vdash x :: \tau'
            }}
          }\over{\large
            \{ f :: \tau \} \ \vdash (\lambda x. x) :: \tau' -> \tau'
          }}
        }\over{\large
        \{\} \vdash (\lambda f. \lambda x. x) :: \tau \rightarrow \tau' \rightarrow \tau'}
      }
      $$

Following the logic represented above, we can conclude that the expression is well-typed.

#### Example 2

The expression $(\lambda f. f x) \ 1$ would produce the following visual:

$$COMB: {\Gamma \vdash {\color{red} 1 :: \tau' \rightarrow \tau } \qquad \Gamma \vdash x :: \tau' \over{\Gamma \vdash (\lambda f. f x) \ 1 :: \tau}}$$

Following the logic above, we can see that $1$ must be proved to have type $\tau' \rightarrow \tau$ for the rest of the proof to work. Intuitively, we know that $1$, being a literal constant value, must have type $\tau$, not $\tau' \rightarrow \tau$.
