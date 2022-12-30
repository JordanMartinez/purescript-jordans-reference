module Syntax.Basic.Newtype.Recursive where

-- The following code does not compile because type synonyms are
-- expanded to their definition. So, the following code produces
-- an infinite loop
--
-- data Either l r
--   = Left l
--   | Right r
-- type Foo = { value :: Either Int Foo }
--
-- which expands to...
--  { value :: Either Int Foo }
--  { value :: Either Int { value :: Either Int Foo } }
--  { value :: Either Int { value :: Either Int { value :: Either Int Foo } } }
--  { value :: Either Int { value :: Either Int { value :: Either Int ... } } }

-- We can workaround that problem by wrapping the type in a newtype
data Either l r
  = Left l
  | Right r

newtype Foo = Foo { value :: Either Int Foo }

example1 :: Foo
example1 = Foo { value: Left 1 }

example2 :: Foo
example2 = Foo { value: Right (Foo { value: Left 1 }) }

example3 :: Foo
example3 = Foo { value: Right (Foo { value: Right (Foo { value: Left 1 }) }) }
