# Records: Use Type, Data, or Newtype?

Short answer: use `type`

**Type:** ideal, but defining typeclass instances on it requires defining it for all records, which is usually not what you want.
```haskell
type TypedRecord = { anInt :: Int }
```

**Newtype:** use if you need a type class instance and you only need to wrap a single record
```haskell
newtype NewtypedRecord = NR { anInt :: Int }
```

**Data:** use if you need a type class instance and you need to wrap a record AND something else. Unfortunately, this will perform unboxing during runtime.
```haskell
data DataRecord = DR { anInt :: Int } { aString :: String }
```
