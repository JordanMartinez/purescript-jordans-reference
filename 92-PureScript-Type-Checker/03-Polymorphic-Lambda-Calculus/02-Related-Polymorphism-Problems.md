# Related Polymorphism Problems

## Adding Support for Type Schemas

### Missing Language Constructs

We know that the `identity` function has type $unknownNowButKnownLater \rightarrow unknownNowButKnownLater$ where `unknownNowButKnownLater` could refer to `Int`, `Boolean`, `Int -> Boolean`, or any such type.

However, $unknownNowButKnownLater \rightarrow unknownNowButKnownLater$ is not a valid type because `unknownNowButKnownLater` isn't `Int`, `Boolean`, or $\tau \rightarrow \tau$. The problem is that our language does not support a notion of `unknownNowButKnownLater`. To support this construct, we'll need to modify our language.

But before doing that, what does `unknownNowButKnownLater` represent? `unknownNowButKnownLater` is essentially a placeholder type that will reference an actual type later. In other words, it functions similarly to a value-level variable but at the type-level. When we write $\lambda arg. arg + 1$, we're saying, "`arg` is a placeholder for a value that I will provide later."

A value-level variable uses two different terms in our language. Below, the color red represents the usage of the variable whereas the color blue represents the introduction of a variable:

$$
(terms) \quad e = i | b | {\color{red} x} | let \ x = e_{1} in \ e_{2} | {\color{blue} \lambda x.} e | e_{1} \ e_{2}
$$

We should follow suit for our type variables by making two modifications. First, we add a new construct for a type variable. Second, we add a construct for introducing a new type variable.

### Type Variables

We'll update our language to add another case in $\tau$ that represents type variables by using lowercase greek letters:
- $\alpha$ - pronounced "alpha"
- $\beta$ - pronounced "beta". (While this may appear uppercase, it's not. An uppercase beta is $\Beta$)
- etc.

$$
(types) \quad \tau = Int | Boolean | {\color{red} \alpha } | \tau \rightarrow \tau
$$

### Type Schemas

We'll also update our language to indicate that a term's type can either be a $\tau$ that doesn't use any type variables or a $\tau$ that does. Rather than putting this in $\tau$, most literature puts it into $\sigma$, which refers to a "type schema." While that is the more accurate terminology, think of type schemas as types that can have polymorphic types in them.

Unlike value-level lambdas which use "$\lambda \ variableName .$" to introduce a variable name, we will use "$\forall \ variableName$" to introduce a type-level variable. $\forall$ is pronounced "forall".

$$
(monomorphic \ types) \quad \tau = Int | Boolean | \alpha | \tau \rightarrow \tau
$$

$$
{\color{red} (polymorphic \ types) \quad \sigma = \forall \alpha. \sigma | \tau}
$$

$\sigma$ looks a bit weird at first, but let's follow its rules for defining one type to get more familiar with it:

| Step | How we're changing the previou expression | What the expression is at this step |
| - | - | - |
| 1 | Start with $\sigma$ | $\sigma$ |
| 2 | Replace $\sigma$ with the polymorphic branch | $\forall \alpha. \sigma$ |
| 3 | Replace $\sigma$ with the monomorphic branch | $\forall \alpha. \tau$ |
| 4 | Replace $\tau$ with a function type that uses the type variable, $\alpha$, only once | $\forall \alpha. \alpha \rightarrow Int$ |

### Summary

We made the following two changes to support the notion of a type-level variable. We won't update our type checker and type inference rules yet because there are still other issues to resolve:

$$
(monomorphic \ types) \quad \tau = Int | Boolean | {\color{red} \alpha} | \tau \rightarrow \tau
$$

$$
{\color{red} (polymorphic \ types) \quad \sigma = \forall \alpha. \sigma | \tau}
$$

where $\alpha$ is represented by lowercase Greek letters, such as:

- $\alpha$ - pronounced "alpha"
- $\beta$ - pronounced "beta". (While this may appear uppercase, it's not. An uppercase beta is $\Beta$)
- etc.

and $\forall$ is pronounced "forall".

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

## Summary

We've updated our language in the following two ways:

$$
(monomorphic \ types) \quad \tau = Int | Boolean | {\color{red} \alpha} | \tau \rightarrow \tau
$$
$$
{\color{red} (polymorphic \ types) \quad \sigma = \forall \alpha. \sigma | \tau}
$$

When it's safe to substitute one unknown type (e.g. $\alpha$) with another type (e.g. $Int$), we'll use the notion "$\alpha \mapsto Int$". However, we haven't yet determined how type inference rules should be updated to do this correctly.

The type inference algorithm will need to ensure type variables (e.g. $\alpha$) are unique for a given scope to ensure we only substitute the correct types with their corresponding type.
