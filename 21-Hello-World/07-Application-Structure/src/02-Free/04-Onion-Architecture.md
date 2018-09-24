# Onion Architecture

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
This allows us to write "onion architecture" programs without the impure unreasonable OO code and instead with the pure reasonable FP code. For a clearer idea of what "onion architecture" is, see these videos:
- [A Quick Introduction to Onion Architecture](https://www.youtube.com/watch?v=R2pW09tMCnE&start=6&end=528)
- [Domain-Driven Design through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

Each `~>` is going from a more central circle (e.g. Domain) to a less central circle (e.g. API). Updating our code above to use meta-language, we would have something like this:
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
-- ... a working program written by a domain-expert in a domain-specific
-- language who is ignorant of all the technical details that make it work.
--
-- In addition, we can always change the infrastructure code to use a new
-- framework, UI, database, etc. without rewriting any code of the main code.
```

Thus, this recursive nature is what can lead to stack overflows and hence why we need to use `Run` instead of `Free`.

## Examples and Implications

To see some examples and the implications of this idea, read the following links and translate the `IO` monad to `Effect` and the mention of Purescript's now-outdated `Eff` monad to `Effect`:
- [A Modern Architecture for FP: Part 1](http://degoes.net/articles/modern-fp)
- [MTL-version of Onion Architecture](https://gist.github.com/ocharles/6b1b9440b3513a5e225e)
- MTL vs Free Deathmatch - [Video](https://www.youtube.com/watch?v=JLevNswzYh8) & [Slides](https://www.slideshare.net/jdegoes/mtl-versus-free)
- [A Modern Architecture for FP: Part 2](http://degoes.net/articles/modern-fp-part-2)
