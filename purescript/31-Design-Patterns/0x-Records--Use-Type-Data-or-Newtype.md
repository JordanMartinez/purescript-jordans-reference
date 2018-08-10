Ideal, but defining typeclass instances on it requires defining it for all records
```purescript
type TypeWithRecord0 = { anInt :: Int }
```

Allows defining type class instances, but performs unnecessary unboxing
```purescript
data TypeWithRecord1 = T { anInt :: Int }
```

Use if it's a single wrapper
```purescript
newtype TypeWithRecord2 = TWR { anInt :: Int }
```
