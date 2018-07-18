data List a
  = Nil -- empty list / end of list
  | Cons a List -- a = head; List = Tai

-- [1, 2, 3]
Cons 1 (Cons 2 (Cons 3 Nil))
