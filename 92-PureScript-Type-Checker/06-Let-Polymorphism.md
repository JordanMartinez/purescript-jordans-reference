# Let Polymorphism

## The Problem

So far, things haven't been that interesting for the type checking or type inference. Once we add let bindings, the problem of polymorphism appears.

`identity` is a function that returns the argument it receives: $\lambda x. x$. Previously, we could write the following expression and it would infer and typecheck fine:
$$
({\color{red} (\lambda x. x)} \ true) \ \&\& \ (intEq \ ({\color{red} (\lambda x. x)} \ 1) \ 1)
$$

The inferred type of the first case of $\lambda x. x$ is $Int \rightarrow Int$ whereas the second case is $Boolean \rightarrow Boolean$. Once we refactor the expression, so that $\lambda x.x$ appears only once...

$$
let \ identity = \lambda x. \ x \\
in \ ({\color{red} identity} \ true) \ \&\& \ (intEq \ ({\color{red} identity} \ 1) \ 1)
$$

... we get a type checking issue. Using our previous type inferencing rules, we would infer that `identity` in the first usage has type $Boolean \rightarrow Boolean$ and in the second usage has type $Integer \rightarrow Integer$. When we type check the first usage with its second usage, the type check fails.

This problem is known as "Let Polymorphism." Polymorphism is when a given expression can have two or more types depending on how that expression.

## Exploring the issue

### What Humans Do

Returning to `identity` function above, why is it that we as humans can tell that the usage of it is safe whereas the type checker and inferencer cannot?

When we see the definition of `identity` as $\lambda x. x$, there are 4 facts:
1. `identity` is a function
1. that function takes only one argument
1. the type of that function's returned value must be the same as the type of the argument
1. we cannot know what the type of the argument and returned value is.

Thus, these expressions would typecheck...
- $identity \ 1$
- $identity \ (\lambda x. x)$
- $(\&\&) \ (identity true) \ true$

... whereas the following expressions would never typecheck:
- `identity 1 2` because we're attempting to pass in two arguments rather than one.
- `(&&) (identity 1) true` because the returned type of the `identity` usage here is `Int` and `&&` expects its first argument's type to be `Boolean`

Thinking about this differently, we have infomation needed and provided at two different parts of the expression:
1. The binding site (e.g. $let \ identity = \lambda x. x$)
2. The usage site (e.g. $identity \ 1$)

| Location | What info it provides to the type inferencer | What info it needs to type inference correctly |
| - | - | - |
| Binding site | <ol><li>Whether it's a function or not and, if so, how many arguments it takes</li></ol> | The info the Usage Site provides |
| Usage site | <ol><li>If a function, what values and their corresponding inferred types are passed to it</li><li>The inferred type of the returned value based on what other expression depend on it</li></ol> | The info the Binding Site provides |

Thus, we need to solve this issue in two steps:
1. At the binding site, we need another type-level construct in our language that indicates "this expression's type is a function type, but it's input and output types are unknown".
2. At the usage site, we need a rule in the type inference program that knows how to take such "function types with unknowns" and figure out what those "unknowns" are.

The next two sections will cover how each step works.

