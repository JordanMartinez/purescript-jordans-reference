# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created. These have been gathered into the following folders

- 11-Syntax - how to use syntax to write code in Purescript (PS versions: `0.12.0`)
- 21-Hello-World - everything you need to know (Monad explanation using pictures included) in how to write your first "Hello World" program (and actually understand what it's doing)
- 31-Design Patterns - commonly-used patterns to solve problems in FP languages
- 41-Ecosystem - a better overview of the libraries in Purescript (categorized by tags)

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- a link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- corrections for any mistakes I've made
- improvements to anything I've written thus far

### License

Since the license of this project is still being determined, I will not currently accept pull requests. I do hope to receive PRs in the future after the license has been determined. Feel free to open an issue to start a discussion on this topic.

## Learning Purescript using this project

- Git clone this repo
- To build this project and insure it compiles, run `pulp --psc-package build --src-path "purescript" `
- Read the pages in order, including folders (i.e. a depth-first graph search).
    - In other words, starting in `purescript/11-Syntax/src/`, one should read the `00-Comments.purs` file first, then the `01-Data-and-Types.purs` file, then read all the files inside the folder, `02-Values-and-Functions` in their order. (If a topic was deemed too long in content to put into one file, the topic was turned into a folder that has a file for each subtopic.)


## Setting up Purescript for the first time

Follow the instructions from [this blog post](https://qiita.com/kimagure/items/570e6f2bbce5b4724564), which is more up-to-date than the current Purescript by Example book.

## Helpful Links

- [Awesome Purescript Index](https://github.com/passy/awesome-purescript)
- [Pursuit - Docs for Purescript packages](http://pursuit.purescript.org/)
- [Deprecatd packages](https://github.com/purescript-deprecated)
- [Purescript Cookbook](http://codingstruggles.com/ps-cookbook/) - aims to demonstrate a few simple concepts
