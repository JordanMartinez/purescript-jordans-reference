# The Remorseless Free Monad

What follows is a quick summary of the [Reflection without Remorse](http://okmij.org/ftp/Haskell/zseq.pdf) paper. This summary:
- explains what's at the heart of the original `Free`'s performance problem
- explains using a very high-level "read the paper if you want to understand the 'type magic'" explanation for how the "reflection without remorse" version of `Free` fixes that performance problem.

## Similar Shapes: The Free Monoid and the Free Monad

Surpisingly, these two "free" types bear a similar resemblence:
```haskell
data List a   = Nil    | Cons    a (List a  )
data Free f a = Pure a | Impure (f (Free f a))
```
A list is just an unbalanced tree. Thus, `Free` is essentially the same as `List`, except that it stores a higher-kinded type (kind `Type -> Type`) rather than a concrete type (kind `Type`)

This similarity will be used to explain why `Free` has performance problems.

## The Direction Matters

Let's talk about `Semigroup`:
```haskell
class Semigroup a where
  append :: a -> a -> a

infix 4 append as <>

instance Semigroup Int where
  append i1 i2 = i1 + i2
```
`Semigroup` requires its implementation to adhere to the law of association, meaning that, when `append` is used on the output of a previous `append` and some other value, the location of the parenthenses don't matter:
```haskell
1 <> 2 <> 3 <> 4 <> 5 <> 6 <> 7 <> 8

-- no association: Tree-like structure
-- Start
  1 <> 2  <>  3 <> 4   <>   5 <> 6 <>   7 <> 8
-- Add parentheesis, starting from the 'leaves'
 (1 <> 2) <> (3 <> 4)  <>  (5 <> 6) <> (7 <> 8)
((1 <> 2) <> (3 <> 4)) <> ((5 <> 6) <> (7 <> 8))

-- Left association: List-like structure
-- Start
      1 <> 2  <> 3  <> 4  <> 5  <> 6  <> 7  <> 8
-- Add parenthesis, starting from the left
     (1 <> 2) <> 3  <> 4  <> 5  <> 6  <> 7  <> 8
    ((1 <> 2) <> 3) <> 4  <> 5  <> 6  <> 7  <> 8
   (((1 <> 2) <> 3) <> 4) <> 5  <> 6  <> 7  <> 8
  ((((1 <> 2) <> 3) <> 4) <> 5) <> 6  <> 7  <> 8
 (((((1 <> 2) <> 3) <> 4) <> 5) <> 6) <> 7  <> 8
((((((1 <> 2) <> 3) <> 4) <> 5) <> 6) <> 7) <> 8
-- Finish:
((((((1 <> 2) <> 3) <> 4) <> 5) <> 6) <> 7) <> 8

-- Right association: List-like structure
-- Start
1 <> 2 <> 3 <> 4 <> 5 <> 6 <> 7 <> 8
-- add parenthesis, starting from the right
1 <>  2 <>  3 <>  4 <>  5 <>  6 <> (7 <> 8)
1 <>  2 <>  3 <>  4 <>  5 <> (6 <> (7 <> 8))
1 <>  2 <>  3 <>  4 <> (5 <> (6 <> (7 <> 8)))
1 <>  2 <>  3 <> (4 <> (5 <> (6 <> (7 <> 8))))
1 <>  2 <> (3 <> (4 <> (5 <> (6 <> (7 <> 8)))))
1 <> (2 <> (3 <> (4 <> (5 <> (6 <> (7 <> 8))))))
-- Finish:
1 <> (2 <> (3 <> (4 <> (5 <> (6 <> (7 <> 8))))))
```
We can see that the output of adding up all these integers, regardless of where we put the parenthesis, will still be the same output value  (that's the law of associativity).

However, functions that are "associative" sometimes take longer to output that value depending on which "direction" it goes. As an example, consider the `Semigroup` instance for `List`:
```haskell
data List a
  = Nil
  | Cons a (List a)

infix 4 Cons as :
-- Nil == []
-- 1 : Nil == [1]
-- 1 : 2 : 3 : Nil == [1, 2, 3]

-- Right associative: Start
(1 : Nil) <>  (2 : Nil) <>  (3 : Nil) <>  (4 : Nil) <> (5 : Nil)        -- 0
(1 : Nil) <>  (2 : Nil) <>  (3 : Nil) <> ((4 : Nil) <> (5 : Nil))       -- 0
(1 : Nil) <>  (2 : Nil) <> ((3 : Nil) <> ((4 : Nil) <> (5 : Nil)))      -- 0
(1 : Nil) <> ((2 : Nil) <> ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))     -- 0
append (1 : Nil) ((2 : Nil) <> ((3 : Nil) <> ((4 : Nil) <> (5 : Nil)))) -- 1
1 : (append Nil ((2 : Nil) <> ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))) -- 2
1 : ((2 : Nil) <> ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))              -- 3
1 : (append (2 : Nil) ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))          -- 4
1 : (2 : (append Nil ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))           -- 5
1 : (2 : ((3 : Nil) <> ((4 : Nil) <> (5 : Nil))))                       -- 6
1 : (2 : (3 : (append Nil <> ((4 : Nil) <> (5 : Nil)))))                -- 7
1 : (2 : (3 : ((4 : Nil) <> (5 : Nil)))))                               -- 8
1 : (2 : (3 : (4 : (append Nil (5 : Nil)))))                            -- 9
1 : (2 : (3 : (4 : (5 : Nil))))                                         -- 10
1 : (2 : (3 : (4 : 5 : Nil)))                                           -- 11
1 : (2 : (3 : 4 : 5 : Nil))                                             -- 12
1 : (2 : 3 : 4 : 5 : Nil)                                               -- 13
1 : 2 : 3 : 4 : 5 : Nil                                                 -- 14

-- Left associative: Start
--  List1         List2         List3         List4        List5
   (1 : Nil) <>  (2 : Nil) <>  (3 : Nil) <>  (4 : Nil) <> (5 : Nil)       -- 0
  ((1 : Nil) <>  (2 : Nil)) <>  (3 : Nil) <>  (4 : Nil) <> (5 : Nil)      -- 0
 (((1 : Nil) <>  (2 : Nil)) <>  (3 : Nil)) <>  (4 : Nil) <> (5 : Nil)     -- 0
((((1 : Nil) <>  (2 : Nil)) <>  (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil)    -- 0
(((append (1 : Nil) (2 : Nil)) <>  (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil) -- 1
(((1 : (append Nil (2 : Nil))) <>  (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil) -- 2
(((1 : (2 : Nil)) <>  (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil)              -- 3
(((1 :  2 : Nil ) <>  (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil)              -- 3
-- At this point, we will need to iterate
-- through the List1 all over again!
((append (1 : 2 : Nil) (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil)             -- 4
((1 : (append (2 : Nil) (3 : Nil))) <>  (4 : Nil)) <> (5 : Nil)           -- 5
((1 : 2 : (append Nil (3 : Nil))) <>  (4 : Nil)) <> (5 : Nil)             -- 6
((1 : 2 : (3 : Nil)) <>  (4 : Nil)) <> (5 : Nil)                          -- 7
((1 : 2 :  3 : Nil) <>  (4 : Nil)) <> (5 : Nil)                           -- 7
-- At this point, we will need to iterate
-- through the List1 AND List2 all over again!
(append (1 : 2 : 3 : Nil) (4 : Nil)) <> (5 : Nil)                         -- 8
(1 : (append (2 : 3 : Nil) (4 : Nil))) <> (5 : Nil)                       -- 9
(1 : 2 : (append (3 : Nil) (4 : Nil))) <> (5 : Nil)                       -- 10
(1 : 2 : 3 : (append Nil (4 : Nil))) <> (5 : Nil)                         -- 11
(1 : 2 : 3 : (4 : Nil)) <> (5 : Nil)                                      -- 12
(1 : 2 : 3 : 4 : Nil) <> (5 : Nil)                                        -- 12
-- At this point, we will need to iterate
-- through the List1 AND List2 AND List3 all over again!
append (1 : 2 : 3 : 4 : Nil) (5 : Nil)                                    -- 13
1 : (append (2 : 3 : 4 : Nil) (5 : Nil))                                  -- 14
1 : 2 : (append (3 : 4 : Nil) (5 : Nil))                                  -- 15
1 : 2 : 3 : (append (4 : Nil) (5 : Nil))                                  -- 16
1 : 2 : 3 : 4 : (append Nil (5 : Nil))                                    -- 17
1 : 2 : 3 : 4 : (5 : Nil)                                                 -- 18
1 : 2 : 3 : 4 : 5 : Nil                                                   -- 18
```
The law of associativity guarantees that the output of a non/left/right-associative function will always be the same. However, the above code demonstrates that one direction of function application (right association) can be faster than another (left association).

So, let's think about why this occured. Due to the way the type is defined, `List` must use recursion to get to its tail `Nil` before it can replace that tail, `Nil`, with the list to which it is being appended. Since `List` and `Free` are structured similarly, then `Free` will also suffer the same performance costs if it uses a left-associative function to reach its tail, `Pure`. So, which function does `Free` use that acts just like `append`? The `bind` function. Every `bind`/`>>=` call will iterate through the entire `Free` structure, apply the function to its `Pure a` value and then rewrap everything in an `Impure` value:
```haskell
-- Thus, this code...
freeMonad >>= f >>= g >>= h >>= ...
-- is synonymous with the runtime performance hit as this code...
(((list <> f) <> g) <> h) <> ...
```
When we call `freeMonad >>= f`, we iterate through `freeMonad`'s entire structure. When we take that output and `bind`/`>>=` it to `g`, we iterate through `freeMonad`'s entire structure plus any new nesting values that `f` added to it. When we take that output and `bind`/`>>=` it to `h`, the total cost is `freeMonad + f's additional structure + g's additional structure`. As a result, `Free`'s performance suffers because of its recursive nature.

Is recursion by itself bad? No, recursion can be quite helpful; it's not the problem. Rather, the problem with `List`'s left-associative `<>` function is the slow recursive-time access to `List`'s tail. Since `List` represents a sequence of values, we can fix the `append` problem by using a different sequence-like data structure that grants fast constant-time access to its tail. Similarly, to fix the problem with `Free`, we should define it differently, so that the "data structure" to which it is similar also has constant-time tail access (i.e. constant time access to its `Pure` value).

This sounds easy until you remember what `bind`'s type signature allows:
`bind :: forall a b. m a -> (a -> m b) -> m b`.
In other words, `bind` must work "for all `a` and `b` types" where these types can differ in-between multiple `bind` calls.

Fortunately, the paper's authors figured out how to do this using a `FingerTree` (data structure with constant time head and tail access) that stores a special type that represents a `bind`'s type signature and which can be composed just like multiple `bind` functions. This "type magic" won't be explained here; you'll need to read the paper (see Section 4 and 5) on your own to understand it fully.

To quote from their documentation, Purescript's `Free` monad is "the Free monad implemented in the spirit of [that] paper."

Now that we understand what the `Free` monad is, let's see why it's useful.
