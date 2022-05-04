# Type-Level Primitives

In addition to Custom Type Errors, the Prim module has sub modules that are not imported by default. Within these modules, Prim defines a few more things for type-level programming. These type classes' instances are [derived by the compiler](https://github.com/purescript/documentation/blob/master/language/Type-Classes.md#compiler-solvable-type-classes)

## Types of Relationships

As explained in the Syntax folder, we use logic programming and unification to compute type-level expressions. To define type-level functions, we define a relationship and the various ways (functional dependencies) that the types can unify. However, there are actually two types of relationships in type-level programming:
1. A relationship that can define multiple type-level functions.
2. A relationship that can assert that something is true.

The first one is easy to understand and is used frequently. However, we have never mentioned assertion relationships. For some examples, see these type classes:
- [Lacks](https://pursuit.purescript.org/builtins/docs/Prim.Row#t:Lacks)
- [Homogenous](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row.Homogeneous#t:Homogeneous)

In my current understanding, I'd guess that these likely do not appear that often in type-level code, but they may be critical for some use cases.

## Type-Level Types, Values, and Proxies

In the below table, **"ValueTypeN" was abbreviated to VTN**

| Value-Level Type | Value-Level Value(s) | Kind Name<br>(Corresponding Type&#8209;Level Type) | Kind Values |
| - | - | - | - |
| [Ordering](https://pursuit.purescript.org/packages/purescript-prelude/4.1.1/docs/Data.Ordering) | `LT` `GT` `EQ` | [Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering) | `LT` `GT` `EQ` |
| [String](https://pursuit.purescript.org/builtins/docs/Prim#t:String) | `"literal string"` | [Symbol](https://pursuit.purescript.org/builtins/docs/Prim#k:Symbol) | `"literal symbol"` |
| [Int](https://pursuit.purescript.org/builtins/docs/Prim#t:Int) | `1`<br />`(-1)` | [Int](https://pursuit.purescript.org/builtins/docs/Prim#k:Int) | `1`<br />`(-1)` |
| [Record](https://pursuit.purescript.org/builtins/docs/Prim#t:Record)<br>(closest idea) | `Record (keyN :: VTN, ...)` | [row kinds](https://github.com/purescript/documentation/blob/master/language/Types.md#rows) | `(keyN :: Kind, ...)` |
| [Boolean](https://pursuit.purescript.org/builtins/docs/Prim#t:Boolean) | `true`/`false` | [Boolean](https://pursuit.purescript.org/builtins/docs/Prim.Boolean) | `True`/`False` |
| List ( keyN :: VTN, ... )<br>(analogy; not real type) | `Nil`<br><br>`Cons a (ListR a)` | [RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList#k:RowList) | `Nil`<br><br>`Cons :: Symbol -> Type -> RowList` |

## Type-Level Modules

Rather than explaining things, read through the source code of these modules and you should be able to get a good intuition for how this stuff works. For additional examples, see the Ecosystem folder and check out some of the data structures (e.g. Array, Matrix) that have been augmented with type-level programming.

| Kind | Modules |
| - | - |
| Boolean | [Prim.Boolean](https://pursuit.purescript.org/builtins/docs/Prim.Boolean)
| Ordering | [Prim.Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering)<br>
| Symbol | [Prim.Symbol](https://pursuit.purescript.org/builtins/docs/Prim.Symbol)<br> [Type.Data.Symbol](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/7.0.0/docs/Type.Data.Symbol)
| Int | [Prim.Int](https://pursuit.purescript.org/builtins/docs/Prim.Int)
| Row | [Prim.Row]()<br>[Type.Row](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/7.0.0/docs/Type.Row)<br>[Type.Row.Homoegeneous](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/7.0.0/docs/Type.Row.Homogeneous)<br>[Record](https://pursuit.purescript.org/packages/purescript-record/3.0.0)<br>[Heterogenous](https://pursuit.purescript.org/packages/purescript-heterogenous/0.1.0)^^
| RowList | [Prim.RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList)
| Higher-Order Functions | [Type.Eval](https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0)
| N/A | [Type.IsEqual](https://pursuit.purescript.org/packages/purescript-type-isequal/0.1.0)<br> [Type.Proxy](https://pursuit.purescript.org/packages/purescript-prelude/6.0.0/docs/Type.Proxy) |

^^ **The `purescript-heterogenous` library is mind-blowing** and is exlained by its author in the following video. This video is potentially difficult-to-understand but will make more sense as one gets used to more FP concepts. **Around 14 minutes in, Nate gets up and moves elsewhere. So, skip to `16:37` when this occurs to avoid wasting time**:
[PS Unscripted - Heterogenous](https://www.youtube.com/watch?v=oNbkpZZAhgk&index=11&list=WL&t=0s)
