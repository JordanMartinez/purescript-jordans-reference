# Type-Level Programming

The Prim module has sub modules that are not imported by default. Within these modules, Prim defines a few more things for type-level programming. These type classes' instances are [derived by the compiler](https://github.com/purescript/documentation/blob/master/language/Type-Classes.md#compiler-solvable-type-classes)

## Type-Level Types, Values, and Proxies

In the below table, **"ValueTypeN" was abbreviated to VTN**

| Value-Level Type | Value-Level Value(s) | Kind Name<br>(Corresponding Type&#8209;Level Type) | Kind Values |
| - | - | - | - |
| [Ordering](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Ordering) | `LT` `GT` `EQ` | [Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering) | `LT` `GT` `EQ` |
| [String](https://pursuit.purescript.org/builtins/docs/Prim#t:String) | `"literal string"` | [Symbol](https://pursuit.purescript.org/builtins/docs/Prim#k:Symbol) | `"literal symbol"` |
| [Record](https://pursuit.purescript.org/builtins/docs/Prim#t:Record)<br>(closest idea) | `Record (keyN :: VTN, ...)` | Row | `(keyN :: VTN, ...)` |
| [Boolean](https://pursuit.purescript.org/builtins/docs/Prim#t:Boolean) | `true`/`false` | [Boolean](https://pursuit.purescript.org/builtins/docs/Prim.Boolean) | `True`/`False` |
| List ( keyN :: VTN, ... )<br>(analogy; not real type) | `Nil`<br><br>`Cons a (ListR a)` | [RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList#k:RowList) | `Nil`<br><br>`Cons :: Symbol -> Type -> RowList` |

## Real-World examples

- [purescript-alphasucc](https://pursuit.purescript.org/packages/purescript-alphasucc/0.1.0)
- [purescript-trout](https://github.com/owickstrom/purescript-hypertrout) -  Type-Level Routing. Used in [purescript-hypertrout](https://github.com/owickstrom/purescript-hypertrout).
- [purescript-kushikatsu](https://github.com/justinwoo/purescript-kushikatsu) - Simple type-level routing
- [purescript-chirashi](https://github.com/justinwoo/purescript-chirashi) - An easy way to work with Errors by inserting a Variant, and reading it out later.
- [purescript-variant](https://pursuit.purescript.org/packages/purescript-variant/5.0.0)
- [purescript-typelevel-eval](https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0)

## Ideas

- [Type-Safe Versioned APIs](https://chrispenner.ca/posts/typesafe-api-versioning). This idea could be combined with the onion architecture and `Run`
