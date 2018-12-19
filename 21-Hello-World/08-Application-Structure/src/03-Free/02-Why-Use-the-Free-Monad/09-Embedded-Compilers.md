# Embedded Compilers

Previously, we saw that we could "interpret" the `Free` monad into another monad, namely, `Effect`. However, what if we recursively interpreted the `Free` monad into another `Free` monad for a few rounds until the last one gets interpreted into the `Effect` monad?
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
This allows us to write one high-level language that gets "interpreted" into a lower-level language, which itself gets interpreted into an even lower-level language. Each `~>` is going from a more abstract language to specific capabilities to specific implementations that support such capabilities. Updating our code above to use meta-language, we would have something like this:
```purescript
-- Let your domain experts write their domain-specific "programs"
-- using a familiar domain-specific language...
data Core e = -- data types and other core things
type Domain1 e = Free (Coproduct4 Core1 Core2 Core3 Core4) e

-- and let your technical experts "translate" them into working programs
-- via NaturalTransformations
type API e = Free (Coproduct3 Domain1 Domain2 Domain3) e
type Infrastructure e = Free Effect e

-- given this...
Core ~> Domain1
Domain1 ~> API
API ~> Infrastructure
-- we compose them to get this
Core ~> Infrastructure

-- which enables this...
runProgram :: (Core ~> Infrastructure) -> Free Core e -> Effect e
-- ... a program written by a domain-expert in a domain-specific
-- language who is ignorant of all the technical details that make it work...
--
-- ... that has been optimized and works for numerous backends by
-- your technical experts.
--
-- In addition, we can always change the infrastructure code to use a new
-- framework, UI, database, etc. without rewriting any of the domain-specific code.
```

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
