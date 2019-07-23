# Aff

If you're writing a program, you should almost always use `Aff` to run your native side-effectful computations rather than `Effect`. Here are some of its advantages:
- prevents "callback hell" for which Node.js is well-known.
- enables concurrent programming (but not parallel programming as JavaScript is single-threaded).
- is a stack-safe monad (`Effect` is not currently stack-safe).

`Aff` is basically what one would get if one implemented JavaScript Promises as a Monad.

**Before continuing one with this folder's contents, watch [Async Programming in PureScript](https://www.youtube.com/watch?v=dbM72ap30TE) to learn what problem `Aff` solves and a tour of its API for how to use it** (actual video on YouTube is titled: "LA PureScript Meetup 12/05/17").

If, after watching the above video, you are tempted to figure out how `Aff` works internally, let me strongly recommend against that. The JavaScript code used to implement `Aff` is difficult to understand. You're time would be better invested elsewhere. Rather, I'd recommend looking at it when you have a better grasp of FP concepts.

## Folder's Contents

To provide an example as to why `Aff` is so great, we'll first look at `Node.ReadLine`'s API, see the problems that arise when using it, and then demonstrate how `Aff` addresses these problems.

Then, we'll show how we wrote the functions we used above to wrap `Effect` in `Aff`.

## Compilation Instructions

```bash
spago run -m ConsoleLessons.ReadLine.Effect
spago run -m ConsoleLessons.ReadLine.AffMonad
```
