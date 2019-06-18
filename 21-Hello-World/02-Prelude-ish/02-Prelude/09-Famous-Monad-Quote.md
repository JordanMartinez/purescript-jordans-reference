# Famous Monad Quote

There's a famous quote regarding monads:

> A Monad is just a Monoid in the category of Endofunctors

The below table was a summarized version of someting `cvlad` explained in the FP Slack channel when explaining that quote to another person.

| When we want to compose... | ...and we don't need "empty" value | ...and we do need "empty" value |
| - | - | - |
| values of same type | Semigroup | Monoid
| values of different types where the second value DOES NOT have a runtime dependency on the first value | Apply | Applicative
| values of different types where the second value DOES have a runtime dependency on the first value | Bind | Monad

To understand the quote more, see this link's 2-minute concise summary, which was also provided by `cvlad`: https://twitter.com/kenscambler/status/955441793465696257
