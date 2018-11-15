module Syntax.TypeLevel.Reification where

-- ignore this
import Prelude (class Show)

-- Reification = value-level instance -> type-level instance

-- In value-level programming,
ignoreMe :: String
ignoreMe =
    -- we can write something like this...
    boolean_to_string_function   a_boolean_value_determined_at_runtime

{-
This function does not know which instance of the Boolean type
(i.e. `true` or `false`) it will be when the program is executed.
However, since the function knows how to map both instances
of the Boolean type into an instance of a String type, it doesn't matter.

Similarly, for type-level programming, we won't always know which
instance of the value-level type it will be. However, if we know how to
reify every instance of that value-level type into an instance of
a type-level type, it doesn't matter.

Reification works by using callback functions:
-}

-- Given the following code, which
--   - defines the type-Level Boolean (named here Boolean_) and its two instances
--   - defines a Proxy type and its two instances
--   - defines the reflection function for both instances ...
data Boolean_ = True_Value | False_Value

foreign import kind BooleanKind
foreign import data True :: BooleanKind
foreign import data False :: BooleanKind

data BooleanProxy (b :: BooleanKind) = BooleanProxyInstance

trueK :: BooleanProxy True
trueK = BooleanProxyInstance

falseK :: BooleanProxy False
falseK = BooleanProxyInstance

class IsBooleanKind (b :: BooleanKind) where
  reflectBoolean :: BooleanProxy b -> Boolean_

instance trueBoolean :: IsBooleanKind True where
  reflectBoolean _ = True_Value

instance falseBoolean :: IsBooleanKind False where
  reflectBoolean _ = False_Value

-- We can reify a boolean by
--   - defining a type class that constrains a type
--       to only have kind "BooleanKind"
--   - declaring a single and only instance of that type class
--   - define a callback function that recives the corresponding
--       type-level instance as its only argument
--       (where we do type-level programming):

class IsBooleanKind b <= BooleanKindConstraint b

-- every instance of our type-level type satisfies the constraint
-- no other instance should exist.
instance typeConstraint :: IsBooleanKind b => BooleanKindConstraint b

reifyBoolean :: forall returnType
             . Boolean_
             -> (forall b. BooleanKindConstraint b => BooleanProxy b -> returnType)
             -> returnType
reifyBoolean True_Value  function = function trueK
reifyBoolean False_Value function = function falseK

{-
One might ask,
    "Why not move the `forall b` part to the `forall returnType` part
    of the function's type signature, so that it reads...

    reifyBool :: forall b r. BooleanKindConstraint b =>
                 Boolean
              -> (BooleanProxy b -> r)
              -> r

I'm not yet entirely sure how to answer that yet. However, this is what
I currently think:

  We cannot let `reifyBool` determine what `b` is because "function" is actually
  two different functions. The below functions are too simple to
  demonstrate why this may be useful, but imagine an entire chain of
  type-level programming before the value potentially gets reflected back as a
  value-level instance:

  - if the Boolean is true, we could use the function

      toRed :: BooleanProxy True -> String
      toRed _ = "red"

  - if the Boolean is false, we could use the function

      toBlue :: BooleanProxy False -> String
      toBlue _ = "blue"

      reifyBool false toBlue

-}

-- necessary for not getting errors while trying the functions in the REPL

instance showBoolean_ :: Show Boolean_ where
    show True_Value  = "True_Value"
    show False_Value = "False_Value"

-- necessary to compile

boolean_to_string_function :: Boolean -> String
boolean_to_string_function true = "true"
boolean_to_string_function false = "false"

a_boolean_value_determined_at_runtime :: Boolean
a_boolean_value_determined_at_runtime = true
