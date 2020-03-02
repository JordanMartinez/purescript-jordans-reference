# Closing Thoughts

## Stack-Safe Recursive Functions

At this point, you should read through the `Design Patterns/Stack Safety.md` file. That file covers the two other kinds of loops: recursive loops and `Effect`-based loops like `whileE`, `forE`, and `untilE`.

## When to Use It? Array vs List
> Hello. When should I use Array and when List?

> It depends on which operations you want to do. Any update on an array is `Ө(n)` but random lookup is `O(1)`. Lists have efficient operations at the front, and everything else is `O(n)`. Array updates copy all other elements, resulting in twice the memory usage, while for most list operations the result and the source share part of the list. However, lists use a less compact layout in memory.
>
> Rules of thumb: if you create the sequence once and read it many times, use an array. Folds over arrays are faster, length is constant time and lookup is constant time. If you want to constantly manipulate the structure, especially at the front, use a list.
>
> If your number of elements is very small (i.e. `n` is bounded), try both and measure. Array might in many cases be faster for few elements, even with random updates. Mostly because cloning of arrays is implemented directly in V8, whereas rebuilding lists is done with many many PureScript operations.

See [Typeclass abstractions to use for data structures](https://discourse.purescript.org/t/typeclass-abstraction-to-use-for-data-structures/479). For algebraic graphs, consider using [`purescript-alga`](https://github.com/thomashoneyman/purescript-alga).
