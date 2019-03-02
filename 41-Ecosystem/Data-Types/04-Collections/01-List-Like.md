# List-Like

## Array (Mutable)

https://pursuit.purescript.org/packages/purescript-arrays/5.0.0/docs/Data.Array.ST

## Array (Immutable)

```purescript
[]  -- empty array
[1] -- array with content
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-arrays](https://pursuit.purescript.org/packages/purescript-arrays/5.0.0/docs/Data.Array)<br>(Utils library) | `Array a` | Immutable strict size-NOT-known-at-compile-time array

| Usage | Values & their Usage
| - | -
| Recursive-resistant, great-performant list type | --
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `Array` |

## Vec

```purescript
newtype Vec s a = -- implementation

empty :: -- TypeLevel Programming

cons :: -- TypeLevel Programming

infixr 5 cons as +>

1 +> 2 +> empty -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-sized-vectors](https://pursuit.purescript.org/packages/purescript-sized-vectors/3.1.0/docs/Data.Vec) | `Vec s a` | Immutable strict size-known-at-compile-time array

## List (Strict)

```purescript
-- Data.List.Types

data List a
  = Nil
  | Cons a (List a)

infixr 6 Cons as :

-- example
1 : 2 : Nil -- Cons 1 (Cons 2 Nil) -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable strict singly-linked list

| Usage | Values & their Usage
| - | -
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `List` |

## List (Lazy)

```purescript
-- Data.List.Lazy.Types

newtype List a = -- implementation

nil :: forall a. List a
-- implementation

cons :: forall a. a -> List a -> List a
-- implementation

infixr 6 cons as :

-- example
1 : 2 : Nil -- cons 1 (cons 2 nil) -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.3.0/docs/Data.List.Lazy.Types#t:List) | `List a` | Immutable lazy singly-linked list

| Usage | Values & their Usage
| - | -
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `List` |

## List (Size Known at Compile-Time)

https://pursuit.purescript.org/packages/purescript-safelist/2.0.0/docs/Data.List.Safe
