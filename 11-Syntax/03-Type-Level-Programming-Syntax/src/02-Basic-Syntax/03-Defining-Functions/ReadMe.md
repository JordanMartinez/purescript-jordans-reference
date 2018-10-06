# Defining Functions

Normally, when we define a function for value-level programming, it looks like this:
```purescript
function :: InputType -> OutputType
function InputInstance = OutputInstance
```

In other words, when given `InputInstance`, return `OutputInstance`. The direction of this "relationship" is ALWAYS in one direction: to the right (i.e. `->`).

When we define a function for type-level programming, we're not defining a function that takes some input and returns an output. Rather, we are defining a "relationship" between some input(s) and some output(s). Because we're doing this at compile-time, this "relationship" already knows (i.e. has fully evaluted) what all of the entities described in the relationship are. Thus, these "relationships" can be applied in multiple directions to create multiple functions. One could say that type-level functions work in **all directions**. To put it another way...:
- `function InputInstance` outputs `OutputInstance`
- `function OutputInstance` outputs `InputInstance`

Let's give a much clearer example by solving an equation:
```
total = x + y
```
Right now, the equation is making us solve for `total`. However, with some simple rearranging, we can make it solve for `x`
```
total = x + y
total - y = x + y - y
total - y = x
x = total - y
```
We can also make it solve for `y`:
```
total = x + y
total - x = x - x + y
total - x = y
y = total - x
```
Thus, we can take this "relationship"/equation and figure out one entity if we know the other two entities. Putting it into programming terms, if we have one relationship/equation (like that above), we can define three functions:
1. `f1 :: X -> Y     -> Total`
2. `f2 :: X -> Total -> Y`
3. `f3 :: Y -> Total -> X`

This is the same idea used in type-level programming. So, how does this actually work in Purescript? Multi-parameter type classes and functional dependencies.

| The Relationship/Equation | The Number of Functions & its type signature | The implementation of a function
| - | - | - |
| a type class | the number of functional dependencies | type class instances

For example, assuming we had a type-level number called `IntK`, we could write both an `add` and two `subtract` functions using just one relationship:
```purescript
-- the relationship itself, where each entity is already fully known...
class AddOrSubtract (left :: IntK) (right :: IntK) (total :: IntK)
  -- the normal "add" function: "total = left + right"
  | left right -> total

  -- the first 'subtract' function: "right = total - left"
  , left total -> right
  -- the second 'subtract' function: "left = total - right"
  , right total -> left
```
Then, we could use this one relationship as three different functions:
```purescript
-- given two IntK values, I can add them together by returning
-- `total`, which is "calculated" via the type class `AddOrSubtract`
addTwoIntK :: AddOrSubtract left right total => left -> right -> total

-- given two IntK values, I can subtract one from another by
-- returning `left`/`right`, which is "calculated"
-- via the type class `AddOrSubtract`
subtractIntK_1 :: AddOrSubtract left right total => left -> total -> right

subtractIntK_2 :: AddOrSubtract left right total => right -> total -> left
```
