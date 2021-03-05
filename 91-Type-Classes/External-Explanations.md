# External Explanations

## Contravariant

- George Wilson's [Contravariant Functors: The Other Side of the Coin](https://www.youtube.com/watch?v=IJ_bVVsQhvc)

## Comonad

- Chris Penner's [Comonads by Example](https://github.com/ChrisPenner/comonads-by-example) (I highly recommend it).
- Gabriel Gonzalez's [You Could have Invented Comonad](http://www.haskellforall.com/2013/02/you-could-have-invented-comonads.html)
- Phil Freeman's [Comonads as Spaces](https://blog.functorial.com/posts/2016-08-07-Comonads-As-Spaces.html)
- Nihil Shah's [Cofree Comonads and their Uses](https://www.youtube.com/watch?v=ydZ_fLwo9yI)

## IndexedMonad (i.e. `IxMonad`)

An IndexedMonad uses the compiler to ensure:
1. monadic computations occur in the proper order
2. one monadic computation will change what the final output will be

Links:
- Kwan's [Indexed Monad overview](https://kseo.github.io/posts/2017-01-12-indexed-monads.html)
- `What I wish I knew when Learning Haskell`'s [Indexed Monad section](http://dev.stephendiehl.com/hask/#indexed-monads)
- Justin Woo's [Using IxMonad to enforce good hamburger building in PureScript](https://qiita.com/kimagure/items/a0ee7313e8c7690bf3f5)

Real-world problem where it would help: `purescript-selda`, a library that allows one to write type-safe database queries, would prevent some aggregate queries from working when they are invalid. The ([thesis' (PDF)](https://github.com/Kamirus/purescript-selda/blob/master/selda.pdf)) relevant sections are 2.3, 2.4,  and 5 (paragraph 5 and down).
