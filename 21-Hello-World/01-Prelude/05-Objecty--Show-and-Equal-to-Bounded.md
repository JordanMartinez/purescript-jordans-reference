# Objecty

In Java, every object has 3 methods:
- toString
- equals
- hashCode

However, not every object needs these types (e.g. singletons, the String object, etc.). Furthermore, `equals` should only work between objects of the same type (i.e. `4 == "4"` shouldn't compile).

## Show, Equal, Ord, Bounded

Since the documentation for these type classes are clear, we will redirect you to them instead of repeating them here:
- [Show](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Show). Note: although it does not currently exist in Prelude, one might also consider a type class `Debug` to distinguish between a String-version of a type for end-users and a String-version of a type for developers when they are debugging code
- [Equal](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Eq) determines whether two instances of the same type are equal. In this way, it avoids the problem that Java has above.
- [Ordering](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Ordering) is a data type for specifying whether something is less than (LT), equal to (EQ), or greater than (GT) something else.  [Ord](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Ord) takes two `a` types and returns an Ordering. Ord uses `total ordering`. There are a different kinds of ordering that require a different number and type of laws:
    - **Preorder**: reflexive and transitive laws
    - **Parital order**: reflexive, transitive, and antisymmetric
    - **Total order**: reflexive, transitive, antisymmetric, and total (e.g. it can order every instance of a given type)
- [Bounded](https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Data.Bounded) just adds an upper and lower bound to Ord.

## Useful Derived Functions

Most of these come from `Ord`:
- min - self-explanatory
- max - self-explanatory
- clamp - `clamp lowerBound value upperBound`
- between - `between lowerBound value upperBound`
