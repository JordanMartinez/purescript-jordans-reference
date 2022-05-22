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
var add1 = (i) => i + 1;

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
x = add1(a);
y = add1(x);
z = add1(y);

// Values end states are:
a == 0
x == 1
y == 2
z == 3
```
At this point, we could do state manipulation using a recursive function...
```haskell
runNTimes :: forall a. Int -> (a -> a) -> a -> a
runNTimes 0 _ output = output
runNTimes count func arg = runNTimes (count - 1) func (func arg)
```
... but state manipulation is more complicated than that. What if we wanted to add 1 at one point and add 2 at another? What if we want to subtract 5 as well? In short, this approach does not work when we increase the complexity of the state manipulation. The next two examples will focus on a different kind of state manipulation.

## Random Number Generators

Given this code:
```javascript
x = random.nextInt
y = random.nextInt
z = random.nextInt

// rewritten to use "function arg" syntax
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

// To make `x /= y`, we need a new `random` value, something like:
x = nextInt(random1);
y = nextInt(random2);
```
The solution is to make `nextInt` return two things via the `Tuple a b` type
- the random int value
- a new value of `random`
```javascript
(Tuple x random2) = nextInt(random1);
(Tuple y random3) = nextInt(random2);
```
where `Tuple a b` is just a box that holds two values of the same/different types:
```haskell
data Tuple a b = Tuple a b
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
(Tuple value1,  value2        ) = stateManipulation(value1);
(Tuple value2,  value3        ) = stateManipulation(value2);
(Tuple value3,  value4        ) = stateManipulation(value3);
// ...
(Tuple value_N, value_N_plus_1) = stateManipulation(valueN);
```
Turning this into Purescript syntax, we get:
```haskell
state_manipulation_function :: forall state value. (state -> Tuple value state)
```
