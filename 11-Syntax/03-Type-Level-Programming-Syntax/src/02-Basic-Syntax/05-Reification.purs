module Syntax.TypeLevel.Reification where

-- ignore this
import Prelude (class Show)

-- Reification = value-level value -> type-level value

-- Given a yes/no data type
--
--  data YesNo = Yes | No

-- In value-level programming,
ignoreMe :: String
ignoreMe =
    -- we can write something like this...
    yesno_to_string_function   a_yesno_value_determined_at_runtime

{-
This function does not know which value of the YesNo type
(i.e. `Yes` or `No`) it will be when the program is executed.
However, since the function knows how to map both values
of the YesNo type into an value of a String type, it doesn't matter.

Similarly, for type-level programming, we won't always know which
value of the value-level type it will be. However, if we know how to
reify every value of that value-level type into an value of
a type-level type, it doesn't matter.

Reification works by using callback functions:
-}

-- Given the following code, which
--   - defines the type-Level YesNo and its two values
--   - defines a Proxy type and its two values
--   - defines the reflection function for both values ...
data YesNo = Yes | No

foreign import kind YesNoKind
foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind

data YesNoProxy (b :: YesNoKind) = YesNoProxyValue

yesK :: YesNoProxy YesK
yesK = YesNoProxyValue

noK :: YesNoProxy NoK
noK = YesNoProxyValue

class IsYesNoKind (b :: YesNoKind) where
  reflectYesNo :: YesNoProxy b -> YesNo

instance yesYesNo :: IsYesNoKind YesK where
  reflectYesNo _ = Yes

instance noYesNo :: IsYesNoKind NoK where
  reflectYesNo _ = No

-- We can reify a YesNo by
--   - defining a type class that constrains a type
--       to only have kind "YesNoKind"
--   - declaring a single and only value of that type class
--   - define a callback function that recives the corresponding
--       type-level value as its only argument
--       (where we do type-level programming):

class IsYesNoKind b <= YesNoKindConstraint b

-- every value of our type-level type satisfies the constraint
-- no other instance should exist.
instance typeConstraint :: IsYesNoKind b => YesNoKindConstraint b

reifyYesNo :: forall returnType
            . YesNo
            -> (forall b. YesNoKindConstraint b => YesNoProxy b -> returnType)
            -> returnType
reifyYesNo Yes function = function yesK
reifyYesNo No  function = function noK

{-
One might ask,
    "Why not move the `forall b` part to the `forall returnType` part
    of the function's type signature, so that it reads...

    reifyYesNo :: forall b r. YesNoKindConstraint b =>
                  YesNo
               -> (YesNoProxy b -> r)
               -> r

I'm not yet entirely sure how to answer that yet. However, this is what
I currently think:

  We cannot let `reifyYesNo` determine what `b` is because "function" is actually
  two different functions. The below functions are too simple to
  demonstrate why this may be useful, but imagine an entire chain of
  type-level programming before the value potentially gets reflected back as a
  value-level value:

  - if YesNo is Yes, we could use the function

      toRed :: YesNoProxy YesK -> String
      toRed _ = "red"

  - if YesNo is No, we could use the function

      toBlue :: YesNoProxy NoK -> String
      toBlue _ = "blue"

      reifyYesNo Yes toBlue

-}

-- necessary for not getting errors while trying the functions in the REPL

instance showYesNo :: Show YesNo where
    show Yes = "Yes"
    show No  = "No"

-- necessary to compile

yesno_to_string_function :: YesNo -> String
yesno_to_string_function Yes = "yes"
yesno_to_string_function No  = "no"

a_yesno_value_determined_at_runtime :: YesNo
a_yesno_value_determined_at_runtime = Yes
