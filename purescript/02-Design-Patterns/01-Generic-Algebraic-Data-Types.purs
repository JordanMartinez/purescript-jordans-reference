data GenericAlgebraicDataType a
  = Constructor1 Int a
  | Constructor2 String a

function :: forall a b. GenericAlgebraicDataType a -> b
function Constructor1 int    a = -- do something with int value
function Constructor2 string a = -- do something with string value
