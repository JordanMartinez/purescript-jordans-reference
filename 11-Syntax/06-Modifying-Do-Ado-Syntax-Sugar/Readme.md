# Modifying Do/Ado Syntax Sugar

This folder documents how one can modify what occurs when using "do notation" and "ado notation." You will likely not need to use these as a beginner. Over time, once you have learned more about FP, these features may be useful. Feel free to skip or skim through this on your first read.

## The Problem

"do notation" and "ado notation" are purely syntax sugar. Rather than having to write some rather verbose code, we can use these two keywords to make the compiler do all of that for us.

It would be nice if one could modify how this syntax sugar gets desugared in some situations. For example...
- ado notation:
    - removing some of the boilerplate needed to use Applicatives to validate data.
- do notation:
    - using `IndexedMonad`-based computations (i.e. monads with phantom types that provide more context about what can/can't happen at that computation step) in the same way we would use `Monad`-based computations.

Presently, there are two ways to do this:
- Rebindable Do/Ado
- Qualified Do/Ado (available since the `0.12.2` release)

Each will be covered in the following folders. To keep it simple, we'll use the `Box` monad to explain how it works. Unfortunately, this monadic type isn't a good example as to why one would want to use this.
