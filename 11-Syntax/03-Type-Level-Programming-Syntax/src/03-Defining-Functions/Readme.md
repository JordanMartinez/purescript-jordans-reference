# Defining Functions

## Solve for X

Normally, when we define a function for value-level programming, it looks like this:
```haskell
function :: InputType -> OutputType
function InputValue = OutputValue
```

In other words, when given `InputValue`, return `OutputValue`. The direction of this "relationship" is ALWAYS in one direction: to the right (i.e. `->`).

When we define a function for type-level programming, we're not defining a function that takes some input and returns an output. Rather, we are defining a "relationship" between some input(s) and some output(s). In other words, these "relationships" can be applied in multiple directions to create multiple functions. One could say that type-level functions work in **multiple directions**. To put it another way...:
- `function InputValue` outputs `OutputValue`
- `function OutputValue` outputs `InputValue`

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
| a multi-parameter type class | functional dependencies (the exact number depends) | type class instances

For example, assuming we had 1) a type-level number called `IntK`, 2) its value-level Proxy type, `IProxy`, and 3) instances for the below type class, we could write an `add` and two `subtract` functions using just one relationship:
```haskell
-- the relationship itself
class AddOrSubtract :: IntK -> IntK -> IntK -> Constraint
class AddOrSubtract x y total
  -- the normal "add" function: "total = x + y"
  | x y -> total

  -- the first 'subtract' function: "y = total - x"
  , x total -> y
  -- the second 'subtract' function: "x = total - y"
  , y total -> x
```
Then, we could use this one relationship as three different functions:
```haskell
-- given two IntK values, I can add them together by returning
-- `total`, which is "calculated" via the type class `AddOrSubtract`
addTwoIntK :: forall x y total
            . AddOrSubtract x y total
           => IProxy x -> IProxy y -> IProxy total
addTwoIntK _ _ = IProxyValue

-- given two IntK values, I can subtract one from another by
-- returning `x`/`y`, which is "calculated"
-- via the type class `AddOrSubtract`
subtractIntK_1 :: forall x y total
                . AddOrSubtract x y total
               => IProxy x -> IProxy total -> IProxy y
subtractIntK_1 _ _ = IProxyValue

subtractIntK_2 :: forall x y total
                . AddOrSubtract x y total
               => IProxy y -> IProxy total -> IProxy x
subtractIntK_2 _ _ = IProxyValue
```

## Unification

### An Overview and How Type-Level Functions "Compute"

Recall that the type checker / type constraint solver "computes" type-level expressions by figuring out what type something is. Thus, the above analogy is helpful for understanding type-level programming, but it is incomplete without an explanation on how types "unify". In short, **unification** is the way by which the compiler infers or figures out some type. For our context, it is how the type checker computes the "type-level output" of a type-level function. It does this by unifying the undefined types in a type class' definition with a concrete type's instance of that type class.

Let's review something first. In a type class definition and its instance, we have terms to refer to specific parts of it:
```haskell
class Show a where
  show :: a -> String

{-            |  1   |         |  2  |                                -}
instance (Show a) => Show (Box a) where
  show (Box a) = show a
```
1. Instance Context
2. Instance Head

The "Instance Context" and "Instance Head" terms are crucial to understanding the unification rules below.

Unification is how logic programming works. A popular language which uses logic programming to compute is Prolog, which has a nice explanation on unification. (Curious readers can see the bottom of the file for links about Prolog). To see the rules for how this works in general, I've adapted the Prolog unification rules defined by Blackburn et al. below:
1. Two concrete terms unify. A "term" for this explanation is either a `Type` or a `Kind`:
    - Type
        - `String` unifies with `String`
        - `String` does not unify with `Int`
    - Kind
        - kind `BooleanK` unifies with kind `BooleanK`
        - kind `BooleanK` does not unify with kind `IntK`
    - a Kind term only unifies with other Kind terms, not Type terms.
    - a Type term only unifies with other Type terms, not Kind terms.
2. A concrete term and a polymorphic/generic term (i.e. term variable) unify and the term variable is assigned to a concrete term:
    - Similar to how a variable can be assigned a value, `let a = 5`, so one assigns a term to a term variable: `a = Int` (type variable assigned to a concrete type) or `a = IntK` (kind variable assigned to a concrete kind). By this analogy, every time one sees an `a` type/kind in a type/kind signature, they can replace it with `Int`/`IntK`.
3. Two term variables unify and their relationship is saved
    - Ignoring the `forall .` syntax, given `f :: Add a b c => Add c d e => a -> b -> d -> e`, the `c` type/kind in both `Add` constraints are unified and their relationship is "saved". As soon as one of them is assigned to a concrete term, the other will be assigned that term, too.
4. Complex "term chains" (e.g. a type class and a concrete type's instance of that type class) unify if and only if all of their corresponding arguments unify:
    - the number of parameter terms in the type class is the same number of terms in the instance
        - `class MyClass first second`
        - `instance MyClass String Int`
    - instance types unify with the class' constraints
        - `class (SuperClass constrained) <= ThisClass constrained`
        - `instance SuperClass String`
        - `instance ThisClass String`
    - types in the instance context unify with their corresponding class
        - `instance OtherConstraint a`
        - `instance (OtherConstraint a) => FastClass a`
    - the type of terms in the type class unify only with their corresponding term type in the instance:
        - The type class' Kind terms are made to unify only with other Kind terms, not Type terms, in the instance
        - The type class' Type terms are made to unify only with other Type terms, not Kind terms, in the instance.
    - a term variable is only assigned once and is not assigned to two different concrete term during the unification process

A type-level function can only "compute" a type-level expression when the types unify. This will fail in a few situations (this list may not be exhaustive):
- infinite unification: to unify some term, `a`, one must unify some term, `b`, which can only be unified if `a` is unified. After making X many recursive steps, the type inferencer will eventually give up and throw an error. This is a hard-coded number in the Purescript compiler.
- situations where the type inferencer cannot infer the correct type/kind
- situations where one needs to do "backtracking".

### Backtracking Is Not (Currently) Supported

Here is an example of "backtracking". It will make more sense after you have read through the `Pattern-Matching-Using-Instance-Chains.purs` file.
```haskell
class MyClass a
  someValue :: Boolean

instance (SomeConstraint a) => MyClass a where
  someValue = true
else instance MyClass a where
  someValue = false
```
Here's the steps the compiler walks through:
1. Find the first instance for MyClass ('firstInstance')
2. Commit to that instance and check whether the `a` type fulfills the `SomeConstraint` type class, too.
3. The `a` type does not satisfy that type class constraint.
4. The type checker fails.

The issue lies in step 2: the instance head is checked before the instance context. Once the type inferer commits to some instance, it cannot 'backtrack' to the starting position after realizing that its current instance fails. Ideally, the type inferer would jump back to step 2 and realize that there is another instance ('secondInstance') that always works for any `a` type (since there is no constraint).

"Backtracking" could be implemented in the compiler by using instance guards, but this has not yet been done. For the current progress on this issue, see [the related Purescript issue](https://github.com/purescript/purescript/issues/3120).

### More Resources for Understanding Unification

To understand unification at a deeper level, see these links:
- [Type Inference from Scratch](https://www.youtube.com/watch?v=ytPAlhnAKro). This video explains the ideas behind the notation used in the paper below.
- [Introduction to Type Inference](https://www.youtube.com/watch?v=il3gD7XMdmA). This video will explain a few more pieces of the notation used in the paper below as well as the problems that arise in type inference. Unfortunately, the teacher goes through concepts quickly and runs out of time, so not everything is immediately understandable through the first viewing.
- [Phil's overview of the Purescript Type's System](https://www.youtube.com/embed/SPpIbiZFPRY?start=2258), where he shows how the compiler unifies types using the same notation above.
- [The original paper describing instance chains](http://web.cecs.pdx.edu/~mpj/pubs/instancechains.pdf).

## Functional Dependencies Reexamined

At times, it can be difficult for the type checker to infer what a given type is. Thus, one uses functional dependencies (FDs) to help the compiler. As a reminder, FDs inform the compiler how to infer what some types are given that it knows other types:
```haskell
class Add :: IntK -> IntK -> IntK -> Constraint
class Add x y total
  | x y -> total
  , y total -> x
  , x total -> y
```
However, sometimes the functional dependencies get a bit more complicated because there are two types on the right-hand side of the arrow. This is where our analogy of a "FDs are type-level functions" starts to break down since a value-level function can only return one value at a time. (Granted, one can use a `Tuple` or `Record` to return multiple values in a container, but the principle still applies.) **With our "relationships", a single FD can sometimes define multiple type-level functions depending on how we use them.**

For example, look at the second FD of [`Prim.Row.Cons`](https://pursuit.purescript.org/builtins/docs/Prim.Row#t:Cons):
```haskell
-- Note: Symbol is a type-level String
class Cons :: forall kind. Symbol -> kind -> Row kind -> Row kind -> Constraint
class Cons label a tail row
  | label a tail -> row
  , label row -> a tail
```
The first FD can be read as

> If you give me a label, its type-level value, and a pre-existing row (i.e. tail), then I can append that "label and type-level value" association to the tail and give you back the result of the append (i.e. row)."

The second FD can be read as
> If you provide me a row and the name of a label in that row, then I can give you either
>   1) that label's type
>   2) a row that excludes that label-value association (i.e. the tail)", or
>   3) both

Let's demonstrate a few different examples via the REPL. This will be covered in more detail in this folder:
1. Run `spago repl`
2. Import the `Prim.Row` module via `import Prim.Row`
3. Use the `:paste` followed by `CTRL+D` to paste the multi-line `verify*` functions below into the REPL.
4. Pass the corresponding arguments into the function to verify that it compiles.
```
-- spago repl
-- import Prim.Row

-- :paste
verifyAddingRowToTailCompiles
  :: forall tail finalRow
   . Cons "first" String tail finalRow
  => Record tail -> Record finalRow -> String
verifyAddingRowToTailCompiles _ _ =
  "If you see this message rather than an error, the relationship is true."
-- CTRL+D

-- Run the below function
verifyAddingRowToTailCompiles {apple: "haha"} {apple: "haha", first: "text" }

-- Great! Let's now switch the `tail` and `finalRow` types
-- in the `Cons` relationship. 

-- :paste
verifyRemovingRowFromTailCompiles
  :: forall tail finalRow
   . Cons "first" String finalRow tail
  => Record tail -> Record finalRow -> String
verifyRemovingRowFromTailCompiles _ _ =
  "If you see this message rather than an error, the relationship is true."
-- CTRL+D

-- Run the below function
verifyRemovingRowFromTailCompiles {apple: "haha", first: "text" } {apple: "haha"}
```

## Prolog Links

Learning Prolog is not necessary to understand how to do type-level programming. However, one may want to learn more about it to understand the idea of unification better. If so, these links helped me understand Prolog:
- the "Learn Prolog Now" book, [chapter 1 - 2](http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-html)
- the ["Learn X in Y minutes where X = Prolog"](https://learnxinyminutes.com/docs/prolog/)
- this [Intro to Prolog](https://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/)

## Works Cited

(for lack of a better section header name...)

Blackburn, Patrick, et al. "2.1: Unification." _Learn Prolog Now!_ vol. 7, College Publications, 2006, http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse5. Accessed 9 Oct. 2018
