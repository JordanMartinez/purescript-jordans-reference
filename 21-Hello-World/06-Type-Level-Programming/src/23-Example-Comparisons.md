# Example Comparisons

The examples in the preceding files demonstrated what using `Proxy` arguments are like and what using Visible Type Applications (VTAs) are like. Both can be used to achieve the same output of a given computation. The difference is in how.

`Proxy` arguments are value-level arguments. So, one can define multiple functions, compose them together, and get a final result. VTAs, on the other hand, are not value-level arguments. So, all of the computation one wants to do is often put into the entire function or value where it's used.

However, because `VTAs` aren't value-level arguments, it also means the type class dictionary overhead can be more easily optimized away. The same can't be said for `Proxy` arguments.
