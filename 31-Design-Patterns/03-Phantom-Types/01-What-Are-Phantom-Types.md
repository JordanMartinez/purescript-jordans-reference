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
