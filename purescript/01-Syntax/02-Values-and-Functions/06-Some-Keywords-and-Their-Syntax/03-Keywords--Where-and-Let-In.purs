{-
The 'where' keyword enables us to break large functions
  down into smaller functions (or values) that compose.
It's different from the `let-in` syntax in that things are defined
  after the main function: -}
whereFunction1 :: forall a b c. a -> b -> c
whereFunction1 arg1 arg2 = bToCFunction (madeUpFunction arg1)
  -- indentation of 'where' starts 2 spaces after
  -- the start of function declaration
  where
  -- an example function that has the same indentation as 'where'
  madeUpFunction :: a -> b
  -- implementation

  -- We don't need to define 'forall' here because it's reusing the type signature
  --   from the containing function.
  bToCFunction :: b -> c
  -- implementation

  someValue :: ValueType
  someValue = create (someComplex (dataType (usingFunction withThisArg)))

{-
The 'let...in' syntax does the same thing as 'where' but it defines things
  before the main function that uses the smaller functions (or values): -}
letInFunction1 :: forall a b. a -> b
letInFunction1 =
  let
    binding = expression
  in
    somethingThatUses binding -- wherever `binding` is used, we mean `expression`

letInFunction2 :: forall a b. a -> b
letInFunction2 =
  let
    binding1 = expression
    binding2 = expression
  in
    somethingThatUses binding1 and binding2

{-
See the indentation rules to correctly indent your where clause
   in the context of the containing function and how far to indent your
   madeUpFunctions.
-}
