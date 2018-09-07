## OO State Reexamined

We'll look at two examples of OO code to help us understand it's equivalent in FP code. The first will be using random number generators and the second will use stacks

### Random Number Generators

Given this code:
```javascript
x = random.nextInt
y = random.nextInt
z = random.nextInt
```
`nextInt` is an impure function because it does not return the same value each time it is called. How might we write the same thing using pure functions? We'll demonstrate a few attempts and explain their problems before showing the final working solution
```javascript
// Assume that  `nextInt` is now pure...
x = random.nextInt
y = random.nextInt
// ... then 'x' ALWAYS equals 'y'
// A random number can sometimes be the same one as before,
// but this shouldn't always be true

// To make `x /= y`, we need a new `random` instance, something like:
x = random1.nextInt
y = random2.nextInt
```
However, this creates a problem: for a function that needs to use N random numbers, I need to create N random numbers before passing them into that function. If that exact number is not known at compile-time, then I can't define or use such a function.
```purescript
use_1_random_number :: RandomInt -> Result

use_2_random_number :: RandomInt -> RandomInt -> Result

use_N_random_number :: -- um.....
```
The solution is to make `nextInt` return two things via the `Tuple a b` type
- the random int value
- a new instance of `random`
```javascript
(Tuple x random2) = random1.nextInt
(Tuple y random3) = random2.nextInt
```

### Popping Stacks

We'll explain this idea once more using a different context: Stacks. In OO, we can write the following code:
```javascript
// assuming we have a non-empty stack:
//   (top) [1, 2, 3, 4, 5] (bottom)
x = stack.pop // x == 1
y = stack.pop // y == 2
z = stack.pop // z == 3
```

`pop` is an impure function as calling it will not return the same value each time it is called. How might we write the same thing using pure functions?
```javascript
// Assume that  `nextInt` is now pure...
x = stack.pop
y = stack.pop
// ... we just popped the same value twice off of the stack
// so that 'x' is always the same value/object as 'y'
// In other words
stack.pop == x == y == 1

// To make `y` == 2, we need a version of `stack` that will return `2`
// as its next value to `pop`. In other words, something like...
x = originalStack.pop
y = originalStack_withoutX.pop
```
Similar to the random number generator issue from before, what do I do if I need multiple values from the stack in a function?

One might try to deconstruct the Stack into its values and pass those values into a function that uses them. However, we still can't write a function that takes N values from a Stack
```purescript
uses_first_stack_value :: StackValue1 -> Result

uses_first_two_stack_values :: StackValue1 -> StackValue2 -> Result

uses_first_N_stack_values :: -- um.....
```
The solution is to make `pop` return two things via the `Tuple a b` type:
- the popped value
- a new version of `stack` without the popped value
```javascript
(Tuple x originalStack_withoutX)    = originalStack.pop
(Tuple y originalStack_withoutXorY) = originalStack_withoutX.pop
```

### Identifying the Pattern

Here's the solution we came up with:
```javascript
(Tuple x random2) = random1.nextInt
(Tuple y random3) = random2.nextInt

(Tuple x originalStack_withoutX)    = originalStack.pop
(Tuple y originalStack_withoutXorY) = originalStack_withoutX.pop

// and generalizing it to a pattern, we get
(Tuple value1,  instance2        ) = instance1.stateManipulation
(Tuple value2,  instance3        ) = instance2.stateManipulation
(Tuple value3,  instance4        ) = instance3.stateManipulation
// ...
(Tuple value_N, instance_N_plus_1) = instanceN.stateManipulation
```
Turning this into Purescript syntax, we get:
```purescript
not_yet_named_function :: forall state value. (state -> Tuple value state)
```
