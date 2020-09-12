# List

Rather than using `Array` to store multiple values of some type, FP programmers usually use `List`. Why? The former is not recursive-friendly whereas the latter is.

Understand the upcoming definition using this diagram:
```
    List
   /   \
head   tail
      /  \
   head  tail
           \
           ....
          /  \
       head  Nil
```
```haskell
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
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, which is either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>

(To improve `List`'s performance, one could use a tree-like data structure instead.)
