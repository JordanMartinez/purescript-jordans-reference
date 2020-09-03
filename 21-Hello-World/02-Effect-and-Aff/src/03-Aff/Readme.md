# Aff

If you're writing an application (as opposed to a library), you should almost always use `Aff` to run your native side-effectful computations rather than `Effect`. Here are some of its advantages:
- prevents "callback hell" for which Node.js is well-known.
- enables concurrent programming (but not parallel programming as JavaScript is single-threaded).
- is a stack-safe monad (`Effect` is not currently stack-safe).

`Aff` is basically what one would get if one implemented JavaScript Promises as a Monad.

**Before continuing one with this folder's contents, watch [Async Programming in PureScript](https://www.youtube.com/watch?v=dbM72ap30TE) to learn what problem `Aff` solves and a tour of its API for how to use it** (actual video on YouTube is titled: "LA PureScript Meetup 12/05/17").

If, after watching the above video, you are tempted to figure out how `Aff` works internally, let me strongly recommend against that. The JavaScript code used to implement `Aff` is difficult to understand. Your time would be better invested elsewhere. Rather, I'd recommend looking at it when you have a better grasp of FP concepts.

## Folder's Contents

First, we'll overview some of `Aff`s API via some working examples that one can play with. Since all programs must be run in `Effect`, this will show the simplest way to start running computations in the `Aff` monad: `launchAff_`

Second, we'll show _one_ way for making it possible to run an `Effect`-based computations in an `Aff` monadic context. (Note: this solution won't work for the `ST` monadic context in the `Effect` folder's `Local-State.purs` example.) Then, we'll show how to fix the issue we experienced in our the `Effect` folder's `Timeout-and-Interval.purs` file.

Third, we'll use the `Node.ReadLine` library to show how to convert `Effect`-based computations that require callbacks into `Aff`-based computations via `makeAff`. We'll also show the more complicated way to run a computation in the `Aff` monad, but which exposes all of `Aff`'s features: `runAff`.

Finally, we'll link to other `Aff`-based libraries that one will likely find helpful.
