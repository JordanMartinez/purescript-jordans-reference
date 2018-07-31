-- Indentation Rules:

function :: forall a b. a -> b
function a = bodyOfFunction -- normal example

function :: forall a b. a -> b
function a = -- this will show the valid places where indentation can be
wrongIndentation
  validAndConventional
    validButNotConventional {-
      and so forth... -}

whereFunction1 :: forall a b. a -> b
whereFunction1 a =
  where
  validFunctionPosition1 :: TypeSignature
  -- implementation

  validFunctionPosition2 :: TypeSignature
  -- implementation

  validValuePosition :: TypeSignature
  -- implementation

whereFunction2 :: forall a b. a -> b
whereFunction2 a =
  where
    validFunctionPosition1 :: TypeSignature
    -- implementation

    validFunctionPosition2 :: TypeSignature
    -- implementation

    validValuePosition :: TypeSignature
    -- implementation

letInFunction1 :: forall a b. a -> b
letInFunction1 =
  let binding = expression
  in bodyOfFunctionThatUses binding

letInFunction2 :: forall a b. a -> b
letInFunction2 =
  let
    binding = expression
  in
    bodyOfFunctionThatUses binding

-- See the `do` notation syntax for how to use `let` properly there
