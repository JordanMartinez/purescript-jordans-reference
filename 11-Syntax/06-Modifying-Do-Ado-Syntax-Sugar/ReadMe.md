# Modifying Do/Ado Syntax Sugar

This folder documents how one can modify what occurs when using "do notation" and "ado notation." You will likely not need to use these as a beginner. Over time, once you have learned more about FP, these features may be useful. Feel free to skip or skim through this on your first read.

## The Problem

"do notation" and "ado notation" are purely syntax sugar. Rather than having to write some rather verbose code, we can use these two keywords to make the compiler do all of that for us.

It would be nice if this syntax sugar could be modified to work for other situations to help reduce the code verbosity. Presently, there are two ways to do this:
- Rebindable Do/Ado
- Qualified Do/Ado (available since the `0.12.2` release)

Each will be covered in the following folders and why one might want to do that.
