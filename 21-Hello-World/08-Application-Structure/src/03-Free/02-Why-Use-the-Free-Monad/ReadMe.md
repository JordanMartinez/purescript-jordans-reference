# The Expression Problem

## Brief Summary

The [Expression Problem](http://www.daimi.au.dk/~madst/tool/papers/expression.txt) can be summarized into three ideas:
> The goal is to define a data type by cases, where
> 1. one can add new cases to the data type and
> 2. (one can add) new functions over the data type,
> 3. without recompiling existing code, and
> 4. while retaining static type safety.

| | Pre-existing compiled function | Function is added
| - | - | - |
| Pre-existing compiled data type | All languages | FP: Add a function in a new file<br> OO: ???
| Data type is added | FP: ???<br>OO: Add a subclass in a new file | Problem's Solution^^ |

^^ This cannot be defined until the corresponding FP/OO issue (marked as `???`) is resolved

## A Solution to the Expression Problem

The paper, [Data Types à la carte](http://www.cs.ru.nl/~W.Swierstra/Publications/DataTypesALaCarte.pdf), synthesized a number of known-at-the-time-of-writing ideas into a solution to the Expression problem by figuring out a way to compose complicated data types. When they applied their findings to the `Free` monad, they found that they could "run" multiple monads inside of one monad.

This folder is a summmary and commentary on the paper linked above. It is meant to be read alongside of or after you read the paper. While you, the reader, could just read the paper and ignore the rest of this folder's contents, there are some advantages to reading through this folder's contents alongside of the paper:
- Sometimes, the above paper will state that something is true, but not show why. This folder will explore that more and show why it's true.
- Sometimes, the paper may use unfamiliar terminology or use symbolic data types. This folder will explain the terminology and use alphabetical names to refer to some data types.
- The last file in this folder (i.e. `Embedded Compilers.md`) explains one of the key features one obtains by using the `Free` monad approach

## Reading the Paper and This Folder Side-by-Side

Rather than follow the paper exactly, this folder will define and solve a simpler version of the Expression Problem to demonstrate the basic idea of the solution. With that foundation, the paper's real problem will be explored and solved.

**In addition, the paper explains how to write a `show` function that pretty prints the mathetmatical expression. This folder's contents will not overview that part of the paper. The full reasons will be explained when we get to that part.**

### Contents of The Paper

The paper above has 8 sections:
1. Introduction (what is the expression problem and an example of it?)
2. Fixing the Expression Problem (how do we compose data types?)
3. Evaluation (how do we evaluate composed data types?)
4. Automating Injections (how do we reduce boilerplate when working with composed data types?)
5. Examples (Provide a full example of a solution to our problem)
6. Monads for Free (Why is this relevant to Free monads?)
7. Applications (Using this approach to define extensible effects by composing Free monads)
8. Discussion

This folder has 8 files:
1. Seeing and Solving a Simple Problem
2. Reducing boilerplate via Either
3. Seeing and Solving a Harder Problem
4. Writing the Evaluate Function
5. Writing the Show function (optional)
6. From Expression to Free
7. Defining Modular Monads
8. Embedded Compilers

### Correspondance Table

| This Folder | General Idea | Corresponding Paper section | General idea |
| - | - | - | - |
| 1 (File) | Prep work: Defining and solving a simple version of the problem by composing data types | Sections 1/2/3/5 (ish) | Laying a foundation
| 2 (File) | Prep work: Abstract data type composition via `Either` | Section 4 (ish) | Laying a foundation
| 3 (File) | Showing why the paper's problem is hard to solve, but still solvable; reveal `Coproduct` | Sections 1/2/4/5 (ish) | -
| 4 (File) | - | Sections 3/5 | Writing the `evaluate` function
| 5 (File) | Optional reading | Sections 3/5 | Writing the `show` function
| 6 (Folder) | Show that `Expression` is really `Free` | Section 6 | -
| 7 (File) | Using 'languages' to model effects | Section 6 | Simulating the State monad
| 8 File | Defining abstract syntax trees via `Free` | Sections 6/7 | Its relevance to and application for `Free` monads
