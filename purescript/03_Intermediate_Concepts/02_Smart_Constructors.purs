module FlawedConstructors
  (
    TheType(DumbConstructor)
  , example
  ) where

-- Let's assume that String value below
-- should only be of three kinds: "apple", "orange", and "banana".
-- (Note: "String" is the wrong type for our situation. We should be using
--   something like "data Fruit = Apple | Orange | Banana".
--   I'm doing this to teach a concept. Don't do this in real code.)
data TheType = DumbConstructor String

example :: TheType -> Int
example DumbConstructor "apple" = 1
example DumbConstructor "orange" = 2
example DumbConstructor "banana" = 42
example DumbConstructor _ = -1 -- This should never occur

-- Since the type and its constructor are both exported,
-- this enables a user of this module to use it incorrectly.
-- For example, in code outside this module, one could incorrectly write
example (DumbConstructor "fire") -- returns -1



-- Rather than use dumb constructors, let's use smart constructors
module SmartConstructors
  ( TheType -- Notice how `DumbConstructor` isn't exported

  , apple   -- but that functions that wrap the constructor are
  , orange
  , banana
  ) where

data TheType = DumbConstructor String

apple :: TheType
apple = DumbConstructor "apple"

orange :: TheType
orange = DumbConstructor "orange"

banana :: TheType
banana = DumbConstructor "banana"

example :: TheType -> Int
example DumbConstructor "apple" = 1
example DumbConstructor "orange" = 2
example DumbConstructor "banana" = 42
example DumbConstructor _ = -1 -- This should never occur

-- Since "DumbConstructor" isn't exported, one is forced to use
-- the apple, orange, or banana smart constructors to get an instance of
-- `TheType`. Thus, it prevents one from creating incorrect "TheType" instances.
preventBadInstances :: Array TheType
preventBadInstances =
  [ example apple -- returns 1
  , example orange -- returns 2
  , example banana -- returns 42
  -- now one cannot write
  , example (DumbConstructor "fire") {- compiler error:
    "You don't have access to that constructor!" -}
  ]
