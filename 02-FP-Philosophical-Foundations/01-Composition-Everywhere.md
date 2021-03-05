# Composition Everywhere

**TL;DR**

Watch [The Power of Composition](https://youtu.be/vDe-4o8Uwl8?t=8)

<hr>

By "composition," we mean, "Assemble a few low-level reusable pieces into a higher-level piece." Here are some examples:
- (Classic example) [Legos](https://www.wikiwand.com/en/Lego). Using small blocks of plastic, people can create all sorts of interesting things.
- Furniture. Using wood, metal, fabric, glass, and nails, people can create tables, chairs, desks, cabinets, etc.

Composition makes FP code easy to refactor because we can always reassemble the smaller pieces into something new or different.

But what kinds of things do we compose? In Functional Programming, we compose types (called `algebraic data types`) and functions.

## Composing Types Algebraically

Algebraic Data Types (ADTs) use Algebra to define the total number of values a given type (i.e. named Set) can have.

There are two videos worth watching in this regard. The table and visualizations that follow merely summarize their points, except for the ideas behind the `List` and `Tree` types in the second video.
- ['Algebraic Data Types' as "Composable Data Types" (stop at 29:26)](https://youtu.be/Up7LcbGZFuo?t=1155)
    - Same ideas already explained in the above "Power of Composition" video:
    - It uses a different syntax than `PureScript` but the ideas still apply.
- [The Algebra of Algebraic Data Types](https://www.youtube.com/watch?v=YScIPA8RbVE)
    - Warning: video has terrible sound quality!
    - explains the "algebraic laws" behind ADTs
    - covers `List`s and `Tree`s (unlike first video)

| Name | Math Operator | Logic Operator | PureScript Type | Idea |
| - | - | - | - | - |
| Product Type | `x * y` | AND | `Tuple` | "One value from type `x` **AND** one value from type `y`" |
| Sum Type | `x + y` | OR | `Either` | "One value from type `x` **OR** one value from type `y`" |
| Exponential Type | `y^x` | ??? | `InputType -> OutputType` | ??? |

![Composing Types](./assets/Composing-Types.svg)

## Composing Functions

Similar to types, functions also compose but in a slightly different way. Look over the below image and then watch the video at the end (if you haven't seen it already).

![Composing Functions](./assets/Composing-Functions.svg)

Video link: [Logging a function's name each time it is called: migrating an "object-oriented paradigm" solution to an "functional paradigm" solution](https://www.youtube.com/embed/i9CU4CuHADQ?start=540)
