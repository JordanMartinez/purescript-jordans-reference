# Adding Type Schemas

## Missing Language Constructs

We know that the `identity` function has type $unknownNowButKnownLater \rightarrow unknownNowButKnownLater$ where `unknownNowButKnownLater` could refer to `Int`, `Boolean`, `Int -> Boolean`, or any such type.

However, $unknownNowButKnownLater \rightarrow unknownNowButKnownLater$ is not a valid type because `unknownNowButKnownLater` isn't `Int`, `Boolean`, or $\tau \rightarrow \tau$. The problem is that our language does not support a notion of `unknownNowButKnownLater`. To support this construct, we'll need to modify our language.

But before doing that, what does `unknownNowButKnownLater` represent? `unknownNowButKnownLater` is essentially a placeholder type that will reference an actual type later. In other words, it functions similarly to a value-level variable but at the type-level. When we write $\lambda arg. arg + 1$, we're saying, "`arg` is a placeholder for a value that I will provide later."

A value-level variable uses two different terms in our language. Below, the color red represents the usage of the variable whereas the color blue represents the introduction of a variable:

$$
(terms) \quad e = i | b | {\color{red} x} | let \ x = e_{1} in \ e_{2} | {\color{blue} \lambda x.} e | e_{1} \ e_{2}
$$

We should follow suit for our type variables by making two modifications. First, we add a new construct for a type variable. Second, we add a construct for introducing a new type variable.

## Type Variables

We'll update our language to add another case in $\tau$ that represents type variables by using lowercase greek letters:
- $\alpha$ - pronounced "alpha"
- $\beta$ - pronounced "beta". (While this may appear uppercase, it's not. An uppercase beta is $\Beta$)
- etc.

$$
(types) \quad \tau = Int | Boolean | {\color{red} \alpha } | \tau \rightarrow \tau
$$

## Type Schemas

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

## Summary

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
