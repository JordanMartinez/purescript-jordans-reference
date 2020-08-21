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

-- We can reify a YesNo by defining a callback function that receives
-- the corresponding type-level value as its only argument
-- (where we do type-level programming):

reifyYesNo :: forall returnType
            . YesNo
            -> (forall b. IsYesNoKind b => YesNoProxy b -> returnType)
            -> returnType
reifyYesNo Yes function = function yesK
reifyYesNo No  function = function noK

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
