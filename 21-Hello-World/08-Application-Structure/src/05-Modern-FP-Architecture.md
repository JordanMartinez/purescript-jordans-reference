# Modern FP Architecture

To see some examples and the implications of this idea, read the following links and translate the `IO` monad to `Effect` and the mention of Purescript's now-outdated `Eff` monad to `Effect`. Also note that `MTL` works faster than `Free` on Haskell, but I don't know their performance comparison on Purescript:
- [A Modern Architecture for FP: Part 1](http://degoes.net/articles/modern-fp)
- [MTL-version of Onion Architecture](https://gist.github.com/ocharles/6b1b9440b3513a5e225e)
- MTL vs Free Deathmatch - [Video](https://www.youtube.com/watch?v=JLevNswzYh8) & [Slides](https://www.slideshare.net/jdegoes/mtl-versus-free)
- [A Modern Architecture for FP: Part 2](http://degoes.net/articles/modern-fp-part-2)

Checkout the `Hello World/Games` folder for more examples and explanations on this idea.
