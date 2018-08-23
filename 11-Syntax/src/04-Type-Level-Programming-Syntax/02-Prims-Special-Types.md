# Prim's Special Kinds

Every Purescript project imports the Prim package by default. This is what
was used to describe the kind of Int, Array, and Function. Now that we have
a deeper understanding of the language and know what type-level programming is,
we can show more types and kinds and explain them further.

Recall from earlier:

| Example | Kind | Meaning
| - | -: | - |
| String | Type | Concrete value
| Int | Type | Concrete value
| Box a | Type -> Type | Higher-Kinded Type (by 1)<br>One type needs to be defined before the type can be instantiated
| (a -> b)<br>Function a b | Type -> Type -> Type | Higher-Kinded Type (by 2)<br>Two types need to be defined before the type can be instantiated
| { key: value }<br>{ key1: value1, key2:value2 } | # Type | n number of types known at compile time

Here's a comparison chart to help one grasp Type-Level concepts:

### Ordering

| Level | Kind | Declaration |
| - | - | - |
| Value-Level | Type | `data Ordering = LT \| GT \| EQ`
| Type-Level | Ordering | `data LT :: Ordering`<br>`data EQ :: Ordering`<br>`data GT :: Ordering`

### Rows

| Level | Kind | Declaration |
| - | - | - |
| Value-Level | # Type | `{}`<br>`{ keyName :: ValueType }`<br>`{ k1 :: ValueType1, k2 :: ValueType2}`
| Type-Level | RowList | `Nil`<br>`Cons "keyName" ValueType Nil`<br>`Cons "k1" ValueType1 (Cons "k2" ValueType2 Nil)`

### Strings

| Level | Kind | Creation | Append |
| - | - | - |
| Value-Level | String | "string" | "a" &lt;&gt; "b"
| Type-Level | Symbol | SProxy ("string" :: Symbol) |

- `Type` == Kind 0
- `# Type` = n-sized number of types known at compile time


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
