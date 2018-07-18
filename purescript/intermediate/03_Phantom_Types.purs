module ProblemsThatPhantomTypesFix
  (
    Attribute
  , attribute
  ) where

newtype Attribute = Attribute { key :: String, value :: String }

-- convenience constructor
attribute :: String -> String -> Attribute
attribute = Attribute { key: _, value: _ }

infix 4 attribute as :=

-- This will succesfully compile when it shouldn't, leading to problems
-- later on during runtime.
example :: Array Attribute
example =
  [ "width" := "not a valid number"
  , "height" := "not a valid number"
  , "style" := "not a valid style"
  ]

-- The problem is that the `width` function should specify
-- a valid type for its second parameter, one that can also be turned
-- into a String.
-- Let's show an example that doesn't use Phantom Types first
-- before showing why they are a better solution

module FirstPossibleSolution
  (
    Attribute

  , width
  , height
  , style

  , Style(..)
  ) where

newtype Attribute = Attribute { key :: String, value :: String }

-- This time, we're not going to export the smart constructor 'attribute'
-- Rather, we'll change its type signture and export wrappers around it

-- assume there are instances of ToString for Int and Style
class ToString a where
  toString :: a -> String

-- Read "given a string and any value that can be turned into a string"
attribute :: forall a. ToString a => String -> a -> Attribute
attribute key value = Attribute { key: key, value: toString value }

-- new smart constructor
width :: Int -> Attribute
width = attribute "width"

-- new smart constructor
height :: Int -> Attribute
height = attribute "height"

data Style = Normal | Bold | Italic

-- new smart constructor
style :: Style -> Attribute
style = attribute0 "style"

-- This gets rid of our runtime issues, but it makes things less readable
-- as we have now lost the "key := value" syntax.
-- Now, we have to use a less-readible "key value" syntax
example :: Array Attribute
example =
  [ width 40
  , height 200
  , style Bold
  ]

-- How can we get the "key := value" syntax back? We want a syntax like
-- `width := 400`. To get that, attribute needs to somehow force the second
-- parameter to be a specific type based on the first parameter it receives.
--
-- This is where Phantom Types come to the rescue
module PhantomTypes
  (
    Attribute

  , width
  , height
  , style

  , Style(..)
  ) where

newtype Attribute = Attribute { key :: String, value :: String }

-- assume there are instances of ToString for Int and Style
class ToString a where
  toString :: a -> String

-- A phantom type is a type defined in the type
-- but not used in its instances / constructors
data TheType phantomType = Constructor String

-- In our case, we can write:
newtype AttributeKey desiredValueType = AttributeKey String

-- Let's update attribute to use the phantom type to restrict
-- what the second parameter can be in our function. Recall that
-- "a" in this situation means "desired value type":
attribute :: forall a. ToString a => AttributeKey a -> a -> Attribute
attribute (AttributeKey key) value =
  Attribute { key: key, value: toString value }

infix 4 attribute as :=

-- Now, we can update width's type signature to force its
-- expected argument to be an int
width :: AttributeKey Int
width = AttributeKey "width"

height :: AttributeKey Int
height = AttributeKey "height"

data Style = Normal | Bold | Italic
-- and the same for style
style :: AttributeKey Style
style = AttributeKey "style"

-- Alright!
example :: Array Attribute
example =
  [ width := 40
  , height := 200
  , style := Bold
  ]
