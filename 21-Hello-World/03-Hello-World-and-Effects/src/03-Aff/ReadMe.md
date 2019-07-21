# Aff

If you're writing a program, you should almost always use `Aff` to run your native side-effectful computations rather than `Effect`. Here are some of its advantages:
- prevents "callback hell" for which Node.js is well-known.
- enables parallel programming (but not concurrent programming as JavaScript is single-threaded).
- is a stack-safe monad (`Effect` is not currently stack-safe).

**Before continuing one with this folder's contents, watch [Async Programming in PureScript](https://www.youtube.com/watch?v=dbM72ap30TE) to learn what problem Aff solves and how it works** (actual video on YouTube is titled: "LA PureScript Meetup 12/05/17").

## Folder's Contents

To provide an example as to why `Aff` is so great, we'll first look at `Node.ReadLine`'s API, see the problems that arise when using it, and then demonstrate how `Aff` addresses these problems.

Then, we'll show how we wrote the functions we used above to wrap `Effect` in `Aff`.

## Compilation Instructions

```bash
spago run -m ConsoleLessons.ReadLine.Effect
spago run -m ConsoleLessons.ReadLine.AffMonad
```
