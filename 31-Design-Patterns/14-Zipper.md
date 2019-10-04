# Zipper

## The Problem

Examples of this problem are easier to explain than providing an initial definition:
- a way to track a player's position in a maze and efficiently update this position to a new valid position. Updating the position to an invalid position should be illegal.
- a way to navigate through a computer's file system by changing directories, one directory at a time. Moreover, we should be able to rename a directory efficiently.

In other words, one needs to be able to do a few things:
- store the current "position"
- modify the current "position"
- change the current "position" to some other "position" by following some "path"
- do this efficiently and with an API that prevents invalid positions.

## The Solution

This solution is called the `Zipper`.

There are libraries the implement this for variuos types. Reading through the code can help you understand it pretty quickly:

| Type | Library |
| - | - |
| `List` | [purescript-pointed-list](https://github.com/paluh/purescript-pointed-list)

For an non-code explanation on this concept, see these links:
- [Haskell Wikibook's explanation](https://en.wikibooks.org/wiki/Haskell/Zippers), which includes pictures to help understand how this idea in general works.
- [The original paper](https://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/huet-zipper.pdf)
- [Learn You a Haskell for Great Good](http://learnyouahaskell.com/zippers)'s explanation
- [The Haskell Wiki's article on it](https://wiki.haskell.org/Zipper), which includes a large number of additional resources

### Cursors

Cursors are one such application of this concept. See this [post](https://cs-syd.eu/posts/2018-10-28-cursor-list) that clearly explains the problem and solution it solves.

Then, see my conclusion to an exploration of defining a cursor-based data structure that supports multiple carets/selections [here](https://gist.github.com/JordanMartinez/526c5b09b33ffe97932d7990b0470043#file-multi-caret-selection-textcontent-purs-L381) with the full exploration [here](https://gist.github.com/JordanMartinez/526c5b09b33ffe97932d7990b0470043)
