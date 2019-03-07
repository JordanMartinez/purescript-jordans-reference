# Modern FP Architecture

## Key Articles

Now might be a good time to re-read these articles:
- [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html)
- [Three Layer Haskell Cake](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html)
- [the `ReaderT` Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)
- [the Capability Design Pattern](https://www.tweag.io/posts/2018-10-04-capability.html)
- [A Modern Architecture for FP: Part 1](http://degoes.net/articles/modern-fp)
- [A Modern Architecture for FP: Part 2](http://degoes.net/articles/modern-fp-part-2)
- [Freer Monads, More Better Programs](reasonablypolymorphic.com/blog/freer-monads/index.html)
- [Freer doesn't come for free](https://medium.com/barely-functional/freer-doesnt-come-for-free-c9fade793501)

## Evaluating MTL and Free

Let's now examine one post's criteria for each approach. The following is my guess at where things stand^^:

| | Extensible? | Composable? | Efficient? | Terse? | Inferrable?
| - | - | - | - | - | - |
| MTL | Yes via the Capability Design Pattern | Yes via newtyped monadic functions? | ? | ~`n^2` instances for `Monad[Word]`<br>boilerplate capability type classes | ? |
| Free/Run | Yes via open rows and `VariantF` | Yes via embedded domain-specific languages | ? | boilerplate smart constructors | ? |

^^ Note: The `MTL vs Free` debate is pretty heated in FP communities.

In the `Hello World/Games` folder, we'll implement the same programs for each concept mentioned above as more concrete examples.
