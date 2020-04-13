# Libraries

The Prim module has sub modules that are not imported by default. Within these modules, Prim defines a few more things for type-level programming. These type classes' instances are [derived by the compiler](https://github.com/purescript/documentation/blob/master/language/Type-Classes.md#compiler-solvable-type-classes)

## Type-Level Types, Values, and Proxies

In the below table, **"ValueTypeN" was abbreviated to VTN**

| Value-Level Type | Value-Level Value(s) | Kind Name<br>(Corresponding Type&#8209;Level Type) | Kind Values | Proxy |
| - | - | - | - | - |
| [Ordering](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Ordering) | `LT` `GT` `EQ` | [Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering) | `LT` `GT` `EQ` | [OProxy](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Ordering)
| [String](https://pursuit.purescript.org/builtins/docs/Prim#t:String) | `"literal string"` | [Symbol](https://pursuit.purescript.org/builtins/docs/Prim#k:Symbol) | `"literal symbol"` | [SProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Symbol#t:SProxy)
| [Record](https://pursuit.purescript.org/builtins/docs/Prim#t:Record)<br>(closest idea) | `Record (keyN :: VTN, ...)` | Row | `(keyN :: VTN, ...)` | [RProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Type.Data.Row#t:RProxy)
| [Boolean](https://pursuit.purescript.org/builtins/docs/Prim#t:Boolean) | `true`/`false` | [Done without using Kinds](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean)<br><br>[Done using Kinds](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean) | `True`/`False` | [Kind-less BProxy](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean#t:BProxy)<br><br>[Kind-full BProxy](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean#t:BProxy)
| List ( keyN :: VTN, ... )<br>(analogy; not real type) | `Nil`<br><br>`Cons a (ListR a)` | [RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList#k:RowList) | `Nil`<br><br>`Cons :: Symbol -> Type -> RowList` |  [RLProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Type.Data.RowList#t:RLProxy)

## Type-Level Modules

Rather than explaining things, read through the source code of these modules and you should be able to get a good intuition for how this stuff works.

| Kind | Modules |
| - | - |
| Boolean | ["Kind-less" Data.Typelevel.Bool](https://pursuit.purescript.org/packages/purescript-typelevel/4.0.0/docs/Data.Typelevel.Bool)<br>["Kind-full Type.Data.Boolean](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean)
| Ordering | [Prim.Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering)<br>
| Symbol | [Prim.Symbol](https://pursuit.purescript.org/builtins/docs/Prim.Symbol)<br> [Type.Data.Symbol](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Symbol)<br>[purescript-alphasucc](https://pursuit.purescript.org/packages/purescript-alphasucc/0.1.0)
| Number | [Data.Typelevel.Number](https://pursuit.purescript.org/packages/purescript-typelevel/4.0.0/docs/Data.Typelevel.Num)<br>[Tanghulu](https://github.com/justinwoo/purescript-tanghulu)
| Row | [Prim.Row]()<br>[Type.Row](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row)<br>[Type.Row.Homoegeneous](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row.Homogeneous)<br>[Record](https://pursuit.purescript.org/packages/purescript-record/1.0.0)<br>[Heterogenous](https://pursuit.purescript.org/packages/purescript-heterogenous/0.1.0)
| RowList | [Prim.RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList)
| Higher-Order Functions | [Type.Eval](https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0)
| N/A | [Type.IsEqual](https://pursuit.purescript.org/packages/purescript-type-isequal/0.1.0)<br> [Type.Proxy](https://pursuit.purescript.org/packages/purescript-proxy/3.0.0/docs/Type.Proxy)<br>[Data.Typelevel.Undefined](https://pursuit.purescript.org/packages/purescript-typelevel/4.0.0/docs/Data.Typelevel.Undefined) |

## Real-World examples

- [purescript-trout](https://github.com/owickstrom/purescript-hypertrout) -  Type-Level Routing. Used in [purescript-hypertrout](https://github.com/owickstrom/purescript-hypertrout).
- [purescript-kushikatsu](https://github.com/justinwoo/purescript-kushikatsu) - Simple type-level routing
- [purescript-chirashi](https://github.com/justinwoo/purescript-chirashi) - An easy way to work with Errors by inserting a Variant, and reading it out later.
- [purescript-variant](https://pursuit.purescript.org/packages/purescript-variant/5.0.0)

## Ideas

- [Type-Safe Versioned APIs](https://chrispenner.ca/posts/typesafe-api-versioning). This idea could be combined with the onion architecture and `Run`
