# Monoids Reconsidered

The below table is a summarized version of something `cvlad` explained:

| When we want to compose... | ...and we don't need "empty" value, we use | ...and we do need "empty" value, we use |
| - | - | - |
| two values of same type | Semigroup | Monoid
| two values of different types where the second value DOES NOT have a runtime dependency on the first value | Apply | Applicative
| two values of different types where the second value DOES have a runtime dependency on the first value | Bind | Monad

What was `@cvlad` explaining? The meaning to this famous quote (in category theory terms):

> A Monad is just a Monoid in the category of Endofunctors

To understand the quote more, see this link's 2-minute concise summary, which was also provided by `cvlad`: https://twitter.com/kenscambler/status/955441793465696257
