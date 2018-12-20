# Embedded Compilers

Previously, we saw that we could "interpret" the `Free` monad into another monad, namely, `Effect`, to simulate state manipulation effects. However, what if we recursively interpreted the `Free` monad into another `Free` monad for a few rounds until the last one gets interpreted into the `Effect` monad?
```purescript
type Free1 = Free f a
type Free2 = Free g a
type Free3 = Free h a

-- assuming there is a natural transformation from one to another...
Free1 ~> Free2
Free2 ~> Free3
Free3 ~> Effect
-- means we can effectively write this
Free1 ~> Effect
```
This allows us to write one high-level language that gets "interpreted" into a lower-level language, which itself gets interpreted into an even lower-level language. Each `~>` is going from a high-level abstract language to a lower-level more-platform-specific language. In other words, a compiler of sorts. Updating our code above to use meta-language, we would have something like this:
```purescript
-- Let your domain experts write their domain-specific "programs"
-- using a familiar domain-specific language...
data Core e = -- data types and other core things
type Domain1 e = Free (Coproduct4 Core1 Core2 Core3 Core4) e

-- and let your technical experts "translate" them into working programs
-- via NaturalTransformations
type API e = Free (Coproduct3 Domain1 Domain2 Domain3) e

-- given this...
Core ~> Domain1
Domain1 ~> API
API ~> Effect
-- we compose them to get this
Core ~> Effect

-- which enables this...
runProgram :: (Core ~> Infrastructure) -> Free Core e -> Effect e
-- ... a program written by a domain-expert in a domain-specific
-- language who is ignorant of all the technical and platform-specific
-- details that make it work...
--
-- ... that has been optimized and works for numerous backends by
-- your technical experts.
--
-- Similar to the ReaderT design pattern, we can always change
-- the infrastructure code to use a new framework, UI, database, etc.
-- without rewriting any of the domain-specific code.
```

### Free Applicative

Since each `~>` acts like a compiler that compiles the higher-level language (input) into a lower-level language (output), one can also "optimize" a compiler's output in some cases via `FreeAp`, the Free Applicative type. Unfortunately, this is not covered here (_yet_), but one should be aware of it. John De Goes overviews this idea below.

## Related Posts

To see some examples and the implications of this idea, read the following links and translate the `IO` monad to `Effect` and the mention of Purescript's now-outdated `Eff` monad to `Effect`. Also note that `MTL` works faster than `Free` on Haskell, but I don't know their performance comparison on Purescript:
- [A Modern Architecture for FP: Part 1](http://degoes.net/articles/modern-fp)
- MTL-version of Onion Architecture
    - [Original Haskell version](https://gist.github.com/ocharles/6b1b9440b3513a5e225e)
    - [My port to Purescript](https://gist.github.com/JordanMartinez/4eb9dd1f5ac4e5220ab3d2cc500c0fce)
- MTL vs Free Deathmatch - [Video](https://www.youtube.com/watch?v=JLevNswzYh8) & [Slides](https://www.slideshare.net/jdegoes/mtl-versus-free)
- [A Modern Architecture for FP: Part 2](http://degoes.net/articles/modern-fp-part-2)
- [Free? monads with mtl](https://gist.github.com/ocharles/252bc296b659aa32e915e02d02537064) - Linking to this because it relates, but I'm still understanding it myself.

Note: one can also mix the two approaches. I'm not yet sure of the pros/cons to this approach.
