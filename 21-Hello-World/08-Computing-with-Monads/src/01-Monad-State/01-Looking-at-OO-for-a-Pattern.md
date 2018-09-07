# Looking at OO for a Pattern

We'll look at three examples of OO code to help us understand it's equivalent in FP code.

## Incrementing an Integer

Given this code:
```javascript
a = 0;
x = a++;
y = a++;
z = a++;
// which we'll rewrite to use a function that receives an argument
a = 0;
x = getAndIncrement(a);
y = getAndIncrement(a);
z = getAndIncrement(a);
```
`getAndIncrement` is an example of an impure function because it does not return the same value each time it is called. Moreover, `a`'s value changes over time, so that `a /= 0` at the end of our program. How might we write the same thing using pure functions? We'll demonstrate a few attempts and explain their problems before showing the final working solution

```javascript
// we'll make the function pure
// and call it "add1"
a = 0;
x = add1(a);
y = add1(a);
z = add1(a);

// Values end states are:
a == 0
x == y == z == 1
```
The problem is `add1` receives the wrong state as an argument. If we pass the returned state from our previous call into the next call, we can resolve this problem:
```javascript
a = 0;
x = add1(x);
y = add1(y);
z = add1(z);

// Values end states are:
a == 0
x == 1
y == 2
z == 3
```
At this point, we could do state manipulation using a recursive function...
```purescript
runNTimes :: forall a. Int -> (a -> a) -> a
runNTimes 0 _ output = output
runNTimes count func arg = runNTimes (count - 1) func (func arg)
```
... but state manipulation is more complicated than that. While this idea may work for a simple state manipulation like an integer, it does not work for larger data structures as the next two examples will show.

## Random Number Generators

Given this code:
```javascript
x = random.nextInt
y = random.nextInt
z = random.nextInt

// rewritten to use function arg syntax
x = nextInt(random);
y = nextInt(random);
z = nextInt(random);
```
`nextInt` is an impure function because it does not return the same value each time it is called. How might we write the same thing using pure functions? We'll demonstrate a few attempts and explain their problems before showing the final working solution
```javascript
// Assume that  `nextInt` is now pure...
x = nextInt(random);
y = nextInt(random);
// ... then 'x' ALWAYS equals 'y'
// A random number can sometimes be the same one as before,
// but this shouldn't always be true

// To make `x /= y`, we need a new `random` instance, something like:
x = nextInt(random1);
y = nextInt(random2);
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
(Tuple x random2) = nextInt(random1);
(Tuple y random3) = nextInt(random2);
```

## Popping Stacks

We'll explain this idea once more using a different context: Stacks. In OO, we can write the following code:
```javascript
// assuming we have a non-empty stack:
//   (top) [1, 2, 3, 4, 5] (bottom)
x = stack.pop // x == 1
y = stack.pop // y == 2
z = stack.pop // z == 3

// rewritten using "function arg" syntax
x = pop(stack);
y = pop(stack);
z = pop(stack);
```

`pop` is an impure function as calling it will not return the same value each time it is called. How might we write the same thing using pure functions?
```javascript
// Assume that  `nextInt` is now pure...
x = pop(stack);
y = pop(stack);
// ... we just popped the same value twice off of the stack
// so that 'x' is always the same value/object as 'y'
// In other words
pop(stack) == x == y == 1

// To make `y` == 2, we need a version of `stack` that will return `2`
// as its next value to `pop`. In other words, something like...
x = pop(originalStack);
y = pop(originalStack_withoutX);
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
(Tuple x originalStack_withoutX)    = pop(originalStack);
(Tuple y originalStack_withoutXorY) = pop(originalStack_withoutX);
```

## Identifying the Pattern

Here's the solution we came up with:
```javascript
(Tuple x random2) = randomInt(random1);
(Tuple y random3) = randomInt(random2);

(Tuple x originalStack_withoutX)    = pop(originalStack);
(Tuple y originalStack_withoutXorY) = pop(originalStack_withoutX);

// and generalizing it to a pattern, we get
(Tuple value1,  instance2        ) = stateManipulation(instance1);
(Tuple value2,  instance3        ) = stateManipulation(instance2);
(Tuple value3,  instance4        ) = stateManipulation(instance3);
// ...
(Tuple value_N, instance_N_plus_1) = stateManipulation(instanceN);
```
Turning this into Purescript syntax, we get:
```purescript
state_manipulation_function :: forall state value. (state -> Tuple value state)
```
