# TypeChecker Docs

## Preface

**Disclaimer: all of the content written here is my interpretation of various papers, articles and other such sources. All of this might be wrong in whole or in part.**

- [Using Latex in Markdown](https://ashki23.github.io/markdown-latex.html#latex)
- [List of LaTeX Symbols](https://latex.wikia.org/wiki/List_of_LaTeX_symbols)

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

While the untyped lambda calculus above can express many things, it also enables one to "compute" an expression that crashes. For example, "$(\lambda f. f x) \ 1$" assumes `1` is a function, not a value, passes `x` as an argument to the supposed function, and then crashes when it realizes that `1` is not a function.

The above example highlights the first problem with this language: it can express "bad" programs. Ideally, the programmer would know before running the computation whether it is "good" and reduces to a final value or "bad" like the example above. One way to move towards this ideal is by adding restrictions to the language (e.g. types). Unfortunately, while such restrictions may reject "bad" programs, they might also reject "good" programs. Ideally, the "perfect" lambda calculus is one that
- has all the computational power of untyped lamda calculus
- rejects all "bad" programs without rejecting any "good" program.

It is the second principle that makes this hard. All attempts towards this goal come with tradeoffs as the rest of this document attempts to cover.

## The Basics of Typed Lambda Calculus

To address the problem raised above, we need a tool that checks the expression. This tool is composed of two parts:
1. annotating terms with monomorphic types
1. typechecking the resulting expression's type.

### Adding Monomorphic Types

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
(terms) \quad e = x : \tau | \lambda x. e : \tau_{1} \rightarrow \tau_{2} | e_{1} \ e_{2} : \tau \\
$$

When using LaTeX, $x : \tau$ reads "The expression $x$ has type $\tau$.

Examples of the above language:
- $x : \tau$
- $\lambda x. \lambda y. y : \tau_{1} \rightarrow \tau_{2} \rightarrow \tau_{2}$
- $\lambda x. \lambda y. x \ y : (\tau_{1} \rightarrow \tau_{2}) \rightarrow \tau_{1} \rightarrow \tau_{2}$

### The Simplest Type Checker

The second part is the type checker. The type checker uses one rule for each term to determine whether the expression is "well-typed." Before covering this further, it's necessary to introduce syntax frequently used in type systems.

#### Explaining the Visuals

A horizontal bar (below) is often used in this syntax. This bar visual typically represents the following idea: $expression_{1}$ is true if and only if $expression_{2}$ is true:
$$
{
expression_{2}
}\over{
  expression_{1}
}
$$

If the top part of the bar is empty, then there's nothing to prove:
$$
{
}\over
{
  expression
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
- $\{\}$ - the empty set: no assumptions exist yet
- $\{ x : i \}$ - a set with one assumption where $x$ has type $\tau$.
- $\{ x : i, f : i \rightarrow i \}$ - a set with two assumptions
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
\Gamma_{x} \cup \{ x : \tau \}
}\over{
  \Gamma
}
$$

$\vdash$ separates $\Gamma$ from the rest of the expression.

$$
\Gamma \vdash expression
$$

#### Type Checker Rules

With that being explained, each term above has a corresponding rule with how to check its type:

- A variable term. The below expression reads, "$x$ has type $\tau$ if the assumption exists in $\Gamma$."
    $$TAUT: {\over{\Gamma \vdash x : \tau}} (x : \tau \in \Gamma)$$
- Function definition. The below expression reads, "$\lambda x. e$ has type $\tau \rightarrow \tau$ if we assume $x$ has type $\tau$ while verifying that $e$ has type $\tau$."
    $$ABS: {{\Gamma_{x} \cup \{x : \tau' \} \vdash \epsilon : \tau}\over{\Gamma \vdash (\lambda x. \epsilon) : \tau' \rightarrow \tau}}$$
- Function application. The below expression reads, "$e_{1} e_{2}$ has type $\tau$ if $e_{1}$ has type $\tau \rightarrow \tau$ and $e_{2}$ has type $\tau$."
    $$COMB: {\Gamma \vdash e : \tau' \rightarrow \tau \qquad \Gamma \vdash e' : \tau' \over{\Gamma \vdash \epsilon \ \epsilon' : \tau}}$$

#### Example 1

The expression $\lambda f. \lambda x. x$ would produce the following visual:
$$\large
      ABS: {\large
        {\large ABS:
          {\large {\large TAU:
            {\large \over{\large
              \{f : \tau,\ x : \tau' \} \vdash x : \tau'
            }}
          }\over{\large
            \{ f : \tau \} \ \vdash (\lambda x. x) : \tau' -> \tau'
          }}
        }\over{\large
        \{\} \vdash (\lambda f. \lambda x. x) : \tau \rightarrow \tau' \rightarrow \tau'}
      }
      $$

Following the logic represented above, we can conclude that the expression is well-typed.

#### Example 2

We get a visual like the following for $(\lambda f. f x) \ 1$

$$COMB: {\Gamma \vdash {\color{red} 1 : \tau' \rightarrow \tau } \qquad \Gamma \vdash x : \tau' \over{\Gamma \vdash (\lambda f. f x) \ 1 : \tau}}$$

Following the logic above, we can see that $1$ must be proved to have type $\tau' \rightarrow \tau$ for the rest of the proof to work. Intuitively, we know that $1$, being a literal constant value, must have type $\tau$, not $\tau \rightarrow \tau$.

The algorithm that type checks such an expression using these rules is called unification.

### Unification: Type-Checking an expression

### The Bounds Check

For example, the expression, `(\x. x x) (\x. x x)`, is an infinite loop: applying the function argument to the function produces the same expression.

Returning to the "bad" program we had previously...
$$
(\lambda x. x x) (\lambda x. x x)
$$
...here is its visual:

