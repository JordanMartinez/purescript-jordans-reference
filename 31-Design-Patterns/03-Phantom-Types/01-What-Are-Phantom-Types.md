# What Are Phantom Types

Phantom Types come in two forms:
1. a data type without any values
2. a generic type that is declared in type's definition that is never used in its data constructors
```haskell
-- 1. ReadOnly has no values
data ReadOnly

-- 2. `unusedType` is never used in Data's data constructor
data Data unusedType = Data
```

## Why Are PhantomTypes Useful?

See [Motivation behind Phantom Types](https://stackoverflow.com/questions/28247543/motivation-behind-phantom-types/28250226#28250226) for a quick overview before looking below for some examples.

- Use a phantom type to restrict what a developer can do with a type
    - [ST](https://pursuit.purescript.org/packages/purescript-st/4.0.0/docs/Control.Monad.ST.Internal#t:ST) uses a [Region](https://pursuit.purescript.org/packages/purescript-st/4.0.0/docs/Control.Monad.ST.Internal#k:Region) type to prevent local mutation from escaping some scope.
- Use a phantom type to restrict how a developer can use a function
    - See ["Restricting ArgumentTypes.purs"](./02-Restricting-Argument-Types.purs)
    - See [Pathy](https://github.com/slamdata/purescript-pathy#introduction), which uses them to track the distinctions of relative/absolute file paths and of file/directory
- Use phantom types to estimate the state of "the real world" in a monadic computation:
    - Search for an explanation of Indexed Monads
- Use phantom types to "save" proofs
    - Watch [Ghosts of Departed Proofs](https://www.youtube.com/watch?v=2cAxOJEiL00) (not the best video quality, but very interesting ideas)
