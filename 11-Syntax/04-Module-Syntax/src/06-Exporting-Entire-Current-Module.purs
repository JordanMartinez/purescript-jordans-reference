{-
Let's say you have a module with A LOT of entities
and you want to export ALL of them. (This 'trick' doesn't
work if you want to export some but not all entities.)

Rather than typing all of the exports, you can use the
"re-export module" syntax to export the current module
-}
module Syntax.Module.ExportingEntireCurrentModule
  (
    -- By exporting the current module,
    -- we can export all of its entities at once.
    module Syntax.Module.ExportingEntireCurrentModule
  ) where

-- 14 entities in total
a :: String
a = "a"

b :: String
b = "b"

c :: String
c = "c"

d :: String
d = "d"

e :: String
e = "e"

f :: String
f = "f"

g :: String
g = "g"

h :: String
h = "h"

i :: String
i = "i"

j :: String
j = "j"

k :: String
k = "k"

l :: String
l = "l"

m :: String
m = "m"

n :: String
n = "n"
