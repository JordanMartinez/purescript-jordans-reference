# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created.

## Setting up Purescript for the first time

Follow the instructions from [this blog post](https://qiita.com/kimagure/items/570e6f2bbce5b4724564), which is more up-to-date than the current Purescript by Example book.

Since Purescript uses very fine-grained modules, its hard to know which libraries to use for various needs. Thus, there is a [Batteries included Prelude](https://github.com/tfausak/purescript-batteries/blob/master/src/Batteries.purs) that is unfortunately outdated for Purescript `0.12.0`. However, I checked their dependencies and updated them (see the `/build-tools/updated-batteries.json` file). Some libraries were deprecated and thus no longer appear. Many others were updated to a new version.

## Helpful Links

### Awesome Purescript index

[See the index](https://github.com/passy/awesome-purescript)

### Deprecated packages

Some packages that worked for older versions of Purescript have been deprecated over time.

[This repo](https://github.com/purescript-deprecated) stores the list

### Purescript Cookbook

[The Purescript Cookbook](http://codingstruggles.com/ps-cookbook/) aims to demonstrate a few simple concepts

## Purescript Syntax and Ecosystem

The Purescript folder in this repo seeks to include all resources necessary for learning enough of Purescript (version 0.12.0) to use it to solve most programming problems:

- Syntax - how to use syntax to write code in Purescript
- Libraries
    - Prelude - the library that defines basic types and whatnot
- Design Patterns - commonly-used patterns to solve problems

### Guidelines

- Git clone this repo
- To build this project and insure it compiles, run `pulp --psc-package build --src-path "purescript" `
- Read the pages in order, including folders (i.e. a depth-first graph search).
    - In other words, starting with `purescript/01-Syntax/`, one should read the `00-Comments.purs` file first, then the `01-Data-and-Types.purs` file, then read all the files inside the folder, `02-Values-and-Functions` in their order. (If a topic was deemed too long in content to put into one file, the topic was turned into a folder that has a file for each subtopic.)
