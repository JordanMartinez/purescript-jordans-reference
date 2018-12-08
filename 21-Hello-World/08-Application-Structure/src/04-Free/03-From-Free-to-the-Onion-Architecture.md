# From Free to the Onion Architecture

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
This allows us to write "onion architecture" programs without the impure unreasonable OO code and instead with the pure reasonable FP code. Each `~>` is going from a more central circle (e.g. Domain) to a less central circle (e.g. API). Updating our code above to use meta-language, we would have something like this:
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
