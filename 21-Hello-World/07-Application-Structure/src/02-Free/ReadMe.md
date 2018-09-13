# Free

The fact that "`bind` forces us to return the same monad type" created a problem for us when we wanted to run a sequential computation using multiple monads. In the `mtl` approach, we got around that problem by nesting monads inside one another. However, what if we didn't fight against `bind` and simply used just one monad? That's one of the ideas behind `Free`, but that's not the main idea behind it.
