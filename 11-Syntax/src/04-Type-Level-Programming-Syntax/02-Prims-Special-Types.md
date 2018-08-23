# Prim's Special Kinds

Every Purescript project imports the Prim package by default. This is what
was used to describe the kind of Int, Array, and Function. Now that we have
a deeper understanding of the language and know what type-level programming is,
we can show more types and kinds and explain them further.

Previously, we said:
> Kinds = "How many more types do I need defined before I have a 'concrete' type?"

We can now add to that definition the idea of which "level" the type represents: the 'value-level' (runtime) or the type-level (compiletime):
> Kinds = "How many more types do I need defined before I have a 'concrete' type **and at which level is the type**?"

Recall from earlier:

| Example | Kind | Meaning
| - | -: | - |
| String | Type | Concrete value
| Int | Type | Concrete value
| Box a | Type -> Type | Higher-Kinded Type (by 1)<br>One type needs to be defined before the type can be instantiated
| (a -> b)<br>Function a b | Type -> Type -> Type | Higher-Kinded Type (by 2)<br>Two types need to be defined before the type can be instantiated
| { key: value }<br>{ key1: value1, key2:value2 } | # Type | n number of types known at compile time

## Syntax Pattern: Value-Level vs Type-Level

To map a value-level entity to a type-level entity, refer to this mapping:

### Type and Data Constructor

- `data Data` becomes `DataKind`
- `DataConstructor` becomes `data DataConstructor :: DataKind`:
```purescript
data ValueLevelType
  = DataConstructor1
  | DataConstructor2

--- becomes ---

kind TypeLevelType

data DataConstructor1 :: TypeLevelType
data DataConstructor2 :: TypeLevelType
```

### Literal Value

- `ValueType` becomes `ValueKind`
- `<literal value>` becomes `data ValueProxy (name :: ValueKind) = ValueProxy`
```purescript
value :: String
value = "string"

--- becomes ---

kind StringKind

data ValueProxy (s :: StringKind) = ValueProxy
```

## Prim's Type-Level Kinds and Functions

Here's a comparison chart to help one grasp Type-Level concepts:

### Ordering

| Level | Kind | Declaration |
| - | - | - |
| Value-Level | Type | <code>data Ordering = LT &#124; GT &#124; EQ</code>
| Type-Level | Ordering | `data LT :: Ordering`<br>`data GT :: Ordering`<br>`data EQ :: Ordering`

### Strings

| Level | Kind | Creation | Append |
| - | - | - |
| Value-Level | String | `"string"` | `"a" <> "b" == "ab"`
| Type-Level | Symbol | SProxy ("string" :: Symbol) |

- `Type` == Kind 0
- `# Type` = n-sized number of types known at compile time

### Rows

| Level | Kind | Declaration |
| - | - | - |
| Value-Level | # Type | `{}`<br>`{ keyName :: ValueType }`<br>`{ k1 :: ValueType1, k2 :: ValueType2}`
| Type-Level | RowList | `Nil`<br>`Cons "keyName" ValueType Nil`<br>`Cons "k1" ValueType1 (Cons "k2" ValueType2 Nil)`


Symbol = a type-level String of kind *
-}
--
-- data TypeString :: Type -> Symbol
--
-- data TypeConcat :: Symbol -> Symbol -> Symbol
--
-- class Union (l :: # Type) (r :: # Type) (u :: # Type) | l r -> u, r u -> l, u l -> r
--
-- class RowCons (l :: Symbol) (a :: Type) (i :: # Type) (o :: # Type) | l a i -> o, l o -> a i
