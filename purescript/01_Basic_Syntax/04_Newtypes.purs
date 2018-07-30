-- useful for creating a custom type class implementation for a given type
newtype NewTypeName = OnlyConstructor OnlyArgument

-- For example....
newtype Miles = Miles Int
instance showMiles :: Show Miles where
  show (Miles i) = show i <> " miles" -- "<>" appends two strings in this context

print :: Miles -> String
print miles = "You ran " <> show miles <> "."
