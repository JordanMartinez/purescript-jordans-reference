# List

`List` is what FP programmers typically use to store a sequence of values because it is friendly to recursion. `Array` is what most mainstream languages use. Due to JavaScript's strict runtime (as opposed to Haskell's lazy runtime), most PureScript developers will use `Array` instead of `List`. However, explaining some FP concepts are easier to do using `List` rather than `Array`.

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
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/) | `List a` | Immutable strict/lazy singly-linked list

| Usage | Values & their Usage
| - | -
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, which is either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
