# Related Polymorphism Problems

## Adding Support for Unknown Types

We know that the `identity` function has type $unknown \rightarrow unknown$ where `unknown` could refer to `Int`, `Boolean`, `Int -> Boolean`, or any such type. However, $unknown \rightarrow unknown$ is not a valid type because `unknown` isn't `Int`, `Boolean`, or $\tau \rightarrow \tau$. We'll update our language to add another case in $\tau$ that represents `unknown`. We'll use lowercase greek letters to indicate such `unknown` types:
- $\alpha$ - pronounced "alpha"
- $\beta$ - pronounced "beta". (While this may appear uppercase, it's not. An uppercase beta is $\Beta$)
- etc.

$$
(types) \quad \tau = Int | Boolean | {\color{red} \alpha } | \tau \rightarrow \tau
$$

With that change, we can now say that `identity` has type $\alpha \rightarrow \alpha$. Similarly, we could define the expression, $let \ const = \lambda x. \lambda y. x \ in \ const \ 1 \ 2$. `const` has type $\alpha \rightarrow \beta \rightarrow \alpha$ and evaluates to 1.

## Solving Unknowns by Substitution

How do we handle type inference and type checking for an expression like `identity 1`.

Looking at our type checker's rule for function application, we have:
$$COMB: {\Gamma \vdash e :: \tau' \rightarrow \tau \qquad \Gamma \vdash e' :: \tau' \over{\Gamma \vdash \epsilon \ \epsilon' :: \tau}}$$

This gets us a diagram like the following. Since the type checker verifies that one type is the same type as another type, it will fail here because $\alpha \neq Int$ (shown in red):
$$COMB: {\Gamma \vdash identity :: {\color{red} \alpha} \rightarrow \alpha \qquad \Gamma \vdash 1 :: {\color{red} Int} \over{\Gamma \vdash identity \ 1 :: \ ???}}$$

What would need to change to make this type check? The type inferencer would need to replace all appearances of $\alpha$ with $Int$. In other words, rather than the above, the type checker would need to see something like this:
$$COMB: {\Gamma \vdash identity :: Int \rightarrow Int \qquad \Gamma \vdash 1 :: Int \over{\Gamma \vdash identity \ 1 :: Int}}$$

Thus, before the type checker checks the expression's inferred type, the type inferencer must replace all appearances of $\alpha$ with $Int$ before the type checker runs. Put differently, we need to update our type inference rules to indicate that an unknown type like $\alpha$ can be substituted with another type like $Int$ via a notation like "$\alpha \mapsto Int$". Moreover, we need to clarify when and where such a substitution gets "created" or "introduced" before we can use it to substitute unknown types like $\alpha$.

In a later section, we'll show when and where a substitution like $\alpha \mapsto Int$ gets introduced and how it substitutes one type with another type.

## Adding Scope via Type Schemas

When substituting unknown types with other types, we need to be careful to only substitute the correct types. For example, let's say we have a function, $let \ constantOne = \lambda x. 1$ whose type is $\alpha \rightarrow Int$. If we call $constantOne \ true$, the $\alpha$ should be replaced with $Boolean$, but the $Int$ should not be replaced with $Boolean$. Thus, the type of this `constantOne` usage should be $Boolean \rightarrow Int$, not $Boolean \rightarrow Boolean$.

The following expression is a more complex example. To help clarify the types, I'll use `let name = expression :: type`:
$$
let \ const_{1} = \lambda x. \lambda y. x :: \alpha \rightarrow \beta \rightarrow \alpha \\
let \ const_{2} = \lambda x. \lambda y. x :: \alpha \rightarrow \beta \rightarrow \alpha \\
let \ const_{3} = \lambda x. \lambda y. x :: \alpha \rightarrow \beta \rightarrow \alpha \\
in \ const_{1} \ const_{2} \ const_{3}
$$

Let's see what the type of this expression should be.
1. Let's start with $const_{1}$
    - $\alpha \rightarrow \beta \rightarrow \alpha$
2. Replace all $\alpha$s with the type for $const_{2}$:
    - $(\alpha \rightarrow \beta \rightarrow \alpha) \rightarrow \beta \rightarrow (\alpha \rightarrow \beta \rightarrow \alpha)$
3. Replace all $\beta$s with the type for $const_{3}$:
    - $(\alpha \rightarrow \beta \rightarrow \alpha) \rightarrow (\alpha \rightarrow \beta \rightarrow \alpha) \rightarrow (\alpha \rightarrow \beta \rightarrow \alpha)$

Did I apply the substitutions correctly? The answer is no. The $\alpha$ type in $const_{2}$ (shown in red) is a different type than the $\alpha$ type in $const_{3}$ (shown in blue), but the type above implies that they are the same. The same could be said for $\beta$.

$({\color{red} \alpha} \rightarrow \beta \rightarrow {\color{red} \alpha}) \rightarrow ({\color{blue} \alpha} \rightarrow \beta \rightarrow {\color{blue} \alpha}) \rightarrow ({\color{red} \alpha} \rightarrow \beta \rightarrow {\color{red} \alpha})$

To resolve this ambiguity, we need to bind these types to some type-level variable that has scope. We'll do that by further modifying our language to have "type schemas." A value-level lambda function (e.g. $1$ in "$(\lambda x. x + 2) \ 1$") uses bounded variables (e.g. the $x$ in $\lambda x. 1$) to indicate when and where $x$ refers to the value `1`. All variables defined in a given scope must have a unique name to ensure we don't refer to one when we meant to refer to another. We will use a similar notion of lambda functions to indicate the scope of a type-level variable via "$\forall variableName .$" because types correspond to logic (a handwavy explanation, but true nonetheless).

Thus, we update our language to include $\sigma$:

$$
(monomorphic \ types) \quad \tau = Int | Boolean | \alpha | \tau \rightarrow \tau
$$
$$
{\color{red} (polymorphic \ types) \quad \sigma = \forall \alpha. \sigma | \tau}
$$

Note: $\sigma$ represents either a polymorphic type or a monomorphic type. Rather than using its official term of "type schema", which is more accurate, I'll be using "polymorphic types" in this language for clarity. A language that supports $\sigma$ as defined here is one that supports polymorphic types in addition to monomorphic ones.

Returning to our expression....

$$
let \ const_{1} = \lambda x. \lambda y. x :: \forall \alpha. \forall \beta. \alpha \rightarrow \beta \rightarrow \alpha \\
let \ const_{2} = \lambda x. \lambda y. x :: \forall \alpha. \forall \beta. \alpha \rightarrow \beta \rightarrow \alpha \\
let \ const_{3} = \lambda x. \lambda y. x :: \forall \alpha. \forall \beta. \alpha \rightarrow \beta \rightarrow \alpha \\
in \ const_{1} \ const_{2} \ const_{3}
$$

... we now get the following:
1. Let's start with $const_{1}$
    - $\forall \alpha. \forall \beta. \alpha \rightarrow \beta \rightarrow \alpha$
2. Replace all $\alpha$s with the type for $const_{2}$. Since $\alpha$ was already used as a type variable name, we'll use $alpha_{1}$. Similarly, since $\beta$ is alrady being used as a type variable, we'll refer to $const{2}$'s $\beta$ as $\beta_{1}:
    - $\forall \beta. \forall \alpha_{1}. \forall \beta_{1}. (\alpha_ \rightarrow \beta_{1} \rightarrow \alpha_) \rightarrow \beta \rightarrow (\alpha_ \rightarrow \beta_{1} \rightarrow \alpha_)$
3. Replace all $\alpha$s with the type for $const_{2}$. Since $\alpha$ and $\alpha_{1} was already used as a type variable name, we'll use $\alpha_{2}$ and similarly for $\beta_{2}$:
    - $\forall \alpha_{1}. \forall \beta_{1}. \forall \alpha_{2}. \forall \beta_{1}. (\alpha_{1} \rightarrow \beta_{2} \rightarrow \alpha_{1}) \rightarrow (\alpha_{2} \rightarrow \beta_{2} \rightarrow \alpha_{2}) \rightarrow (\alpha_{1} \rightarrow \beta_{1} \rightarrow \alpha_{1})$

Put differently, we can only state what the full type of $const_{1} const_{2} const{3}$ is once we have substituted all 4 type variables with another type.
