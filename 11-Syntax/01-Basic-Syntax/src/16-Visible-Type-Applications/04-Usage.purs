module Syntax.Basic.VisibleTypeApplications.Usage where

-- When one opts-in to the VTA-supported type variables,
-- one does not need to use VTAs to call the function.

multiVtaFn :: forall @a @b @c. a -> b -> c -> String
multiVtaFn _a _b _c = "returned value"

-- Proof that we don't have to use VTAs for the function to still work.
-- The compiler will infer that `a`, `b`, and `c` have type `Int`.
usage_noVtas :: String
usage_noVtas = multiVtaFn 1 2 3

-- Proof that we can type-apply only as many types as we want.
usage_useVtas1 :: forall b c. Int -> b -> c -> String
usage_useVtas1 = multiVtaFn @Int

usage_useVtas2 :: forall a c. a -> Int -> c -> String
usage_useVtas2 = multiVtaFn @_ @Int

usage_useVtas2b :: forall a c. a -> Int -> c -> String
usage_useVtas2b = multiVtaFn @_ @Int @_ -- The second @_ is pointless but unharmful.

usage_useVtas3 :: forall a b. a -> b -> Int -> String
usage_useVtas3 = multiVtaFn @_ @_ @Int

-- Proof that we can apply the third type argument and apply the first value argument
-- to get a derived function.
usage_mixed :: forall b. b -> Int -> String
usage_mixed = multiVtaFn @_ @_ @Int "a"

-- Here's a more interesting usage of VTAs. Once a type variable is brought into scope,
-- whether through a normal type variable (e.g. `forall a.`) 
-- or VTA-supported type variable (e.g. `forall @a.`), 
-- we can apply that type variable as a type argument to functions that support VTAs.
-- In the below example, `returnFoo`'s `x` is being specified to whatever `a` and `b` are.`
outerFunction :: forall a b. a -> b -> String
outerFunction aVal bVal = returnSecond (returnFoo @a aVal) (returnFoo @b bVal)
  where
  returnFoo :: forall @x. x -> String
  returnFoo _x = "foo"

  returnSecond :: forall first second. first -> second -> first
  returnSecond first _ = first