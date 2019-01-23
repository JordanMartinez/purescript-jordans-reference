# Qualified Do/Ado

This section uses advanced features that you will likely not need to use as a beginner. Over time, once you have learned more about FP, this feature might be useful. Look over it now to understand the basic idea behind it, but realize that you will likely not need to use it until much later.

## The Problem

"do" and "ado" are purely syntax sugar. Rather than having to write some rather verbose
nested code, we can use these two keywords to make the compiler do all of that for us.

However, sometimes this syntax sugar is nice to have for type classes that are like `Applicative` and `Monad` but differ in slight ways. As an example of such type classes, look at [IxMonad](https://pursuit.purescript.org/packages/purescript-indexed-monad/0.2.0/docs/Control.IxMonad#t:IxMonad). 

Since `0.12.2`, we can now use a feature called "Qualified Do" / "Qualified Ado" syntax that allows us to re-use this syntax sugar. What follows is the requirements one needs to implement before this feature will work.
