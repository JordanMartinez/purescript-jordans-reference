# What Are Phantom Types

Phantom Types come in two forms:
1. a data type without any instances
2. a generic type that is declared in type's definition that is never used in its data constructors
```purescript
-- 1. ReadOnly has no instances
data ReadOnly

-- 2. `unusedType` is never used in Data's data constructor
data Data unusedType = Data
```

## Why Are PhantomTypes Useful?

- Use a phantom type to restrict what a developer can do with a type
    - [ST](https://pursuit.purescript.org/packages/purescript-st/4.0.0/docs/Control.Monad.ST.Internal#t:ST) uses a [Region](https://pursuit.purescript.org/packages/purescript-st/4.0.0/docs/Control.Monad.ST.Internal#k:Region) type to prevent local mutation from escaping some scope.
- Use a phantom type to restrict how a developer can use a function
    - See ["Restricting ArgumentTypes.purs"](./02-Restricting-Argument-Types.purs)
