# Project Prelude

If you ever find yourself thinking, "I wish `<ModuleName>` was in `Prelude`," or "I wish I didn't have to import `<ModuleName>` in each PureScript file," this design pattern is for you.

PureScript files can often have a lot of lines for just the import statements. While it makes it easier to see which function is being used in a given file, it can be tedious to import everything, even with tooling that enables auto-importing.

However, most projects and applications will define a project-specific Prelude to be used just in that project. Rather than typing something like this in each of your files:
```purescript
import Prelude

import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Reader.Class (class MonadReader, ask, local)
import Control.Monad.State.Class (class MonadState, get, put, modify_)
import Data.Array ((:), (!!))
import Data.Bifunctor (class Bifunctor, bimap, lmap, rmap)
import Data.Maybe (Maybe(..), maybe, fromJust)
import Data.Newtype (class Newtype, un)
import Data.Generic.Rep (class Generic)
import Data.Either (Either(..), either, fromLeft, fromRight)
import Data.Foldable (foldl, fold, foldr, any, all, sum, product, foldM, for_, traverse_)
import Data.Traversable (for, traverse, scanl, scanr)

-- actual code below this
```
You might type this in your file:
```purescript
import AppPrelude

-- actual code below this
```

where `AppPrelude.purs` looks like this:
```purescript
module AppPrelude (module Exports) where

-- Export the things we care about
import Effect (Effect) as Exports
import Effect.Class (class MonadEffect, liftEffect) as Exports
import Effect.Aff (Aff, launchAff_) as Exports
import Effect.Aff.Class (class MonadAff, liftAff) as Exports
import Control.Monad.Reader.Class (class MonadReader, ask, local) as Exports
import Control.Monad.State.Class (class MonadState, get, put, modify_) as Exports
import Data.Array ((:), (!!)) as Exports
import Data.Bifunctor (class Bifunctor, bimap, lmap, rmap) as Exports
import Data.Maybe (Maybe(..), maybe, fromJust) as Exports
import Data.Newtype (class Newtype, un) as Exports
import Data.Generic.Rep (class Generic) as Exports
import Data.Either (Either(..), either, fromLeft, fromRight) as Exports
import Data.Foldable (foldl, fold, foldr, any, all, sum, product, foldM, for_, traverse_) as Exports
import Data.Traversable (for, traverse, scanl, scanr) as Exports

-- Re-export what the Prelude module (as of prelude v4.1.1) rexports:
https://github.com/purescript/purescript-prelude/blob/v4.1.1/src/Prelude.purs
import Control.Applicative (class Applicative, pure, liftA1, unless, when) as Exports
import Control.Apply (class Apply, apply, (*>), (<*), (<*>)) as Exports
import Control.Bind (class Bind, bind, class Discard, discard, ifM, join, (<=<), (=<<), (>=>), (>>=)) as Exports
import Control.Category (class Category, identity) as Exports
import Control.Monad (class Monad, ap, liftM1, unlessM, whenM) as Exports
import Control.Semigroupoid (class Semigroupoid, compose, (<<<), (>>>)) as Exports

import Data.Boolean (otherwise) as Exports
import Data.BooleanAlgebra (class BooleanAlgebra) as Exports
import Data.Bounded (class Bounded, bottom, top) as Exports
import Data.CommutativeRing (class CommutativeRing) as Exports
import Data.DivisionRing (class DivisionRing, recip) as Exports
import Data.Eq (class Eq, eq, notEq, (/=), (==)) as Exports
import Data.EuclideanRing (class EuclideanRing, degree, div, mod, (/), gcd, lcm) as Exports
import Data.Field (class Field) as Exports
import Data.Function (const, flip, ($), (#)) as Exports
import Data.Functor (class Functor, flap, map, void, ($>), (<#>), (<$), (<$>), (<@>)) as Exports
import Data.HeytingAlgebra (class HeytingAlgebra, conj, disj, not, (&&), (||)) as Exports
import Data.Monoid (class Monoid, mempty) as Exports
import Data.NaturalTransformation (type (~>)) as Exports
import Data.Ord (class Ord, compare, (<), (<=), (>), (>=), comparing, min, max, clamp, between) as Exports
import Data.Ordering (Ordering(..)) as Exports
import Data.Ring (class Ring, negate, sub, (-)) as Exports
import Data.Semigroup (class Semigroup, append, (<>)) as Exports
import Data.Semiring (class Semiring, add, mul, one, zero, (*), (+)) as Exports
import Data.Show (class Show, show) as Exports
import Data.Unit (Unit, unit) as Exports
import Data.Void (Void, absurd) as Exports
```
