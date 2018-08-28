# Prim's Other Submodules

In addition to Custom Type Errors, the Prim module has sub modules that are not imported by default. Within these modules, Prim defines a few more things for type-level programming.

In the below table, **"ValueTypeN" was abbreviated to VTN**

| Value-Level Type | Value-Level Instance(s) | Kind Name<br>(Corresponding Type&#8209;Level Type) | Kind Instances | Proxy |
| - | - | - | - | - |
| [Ordering](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Ordering) | `LT` `GT` `EQ` | [Ordering](https://pursuit.purescript.org/builtins/docs/Prim.Ordering) | `LT` `GT` `EQ` | [OProxy](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Ordering)
| [String](https://pursuit.purescript.org/builtins/docs/Prim#t:String) | `"literal string"` | [Symbol](https://pursuit.purescript.org/builtins/docs/Prim#k:Symbol) | `"literal symbol"` | [SProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Symbol#t:SProxy)
| [Record](https://pursuit.purescript.org/builtins/docs/Prim#t:Record)<br>(closest idea) | `Record (keyN :: VTN, ...)` | Row | `(keyN :: VTN, ...)` | [RProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Type.Data.Row#t:RProxy)
| [Boolean](https://pursuit.purescript.org/builtins/docs/Prim#t:Boolean) | `true`/`false` | [Done without using Kinds](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean) | `True`/`False` | [BProxy](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Data.Boolean#t:BProxy)
| List ( keyN :: VTN, ... )<br>(analogy; not real type) | `Nil`<br><br>`Cons a (ListR a)` | [RowList](https://pursuit.purescript.org/builtins/docs/Prim.RowList#k:RowList) | `Nil`<br><br>`Cons :: Symbol -> Type -> RowList` |  [RLProxy](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Type.Data.RowList#t:RLProxy)

## Prim's Functions

Some Type-Level functions have already been defined in Prim's submodules. See each submodule for their documentation.

Lastly, the compiler can already implement some of those type class instances for you. See the section on [Compiler Solvable Type Classes](https://github.com/purescript/documentation/blob/master/language/Type-Classes.md#compiler-solvable-type-classes) for more info.
