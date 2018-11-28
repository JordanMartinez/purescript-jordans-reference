# Location-TBD

...Or the "I don't know where to put this yet" file.

**Everything that appears here will be moved elsewhere. Thus, moving a link from here to somewhere else will not be considered as a 'breaking change'.**

- [New Guide for Purescript Duplex - A Bidirectional Route-Parsing Library](https://discourse.purescript.org/t/new-guide-for-purescript-routing-duplex-a-bidirectional-route-parsing-library/500)
- [Glassery - A detailed explanation of Optics/Lenses, etc.](http://oleg.fi/gists/posts/2017-04-18-glassery.html)
- [Type Class Abstractions to Use for Data Structures](https://discourse.purescript.org/t/typeclass-abstraction-to-use-for-data-structures/479/12)

- [Quirky Type-Learning Challenge - The Game of Pattern Matching](https://blog.functorial.com/posts/2017-10-28-The-Game-Of-Pattern-Matching.html)

- Array vs List
> hello. when should I use `Array` and when `List`?

> It depends on which operations you want to do. Any update on an array is Ө(n) but random lookup is O(1). Lists have efficient operations at the front, and everything else is O(n). Array updates copy all other elements, resulting in twice the memory usage, while for most list operations the result and the source share part of the list. However, lists use a less compact layout in memory.
> Rules of thumb: if you create the sequence one and read it many times, use an array. Folds over arrays are faster, length is constant time and lookup is constant time. If you want to constantly manipulate the structure, especially at the front, use a list.
> If your number of elements is very small (i.e. n is bounded), try both and measure. Array might in many cases be faster for few elements, even with random updates. Mostly because cloning of arrays is implemented directly in V8, whereas rebuilding lists is done with many many PureScript operations.
