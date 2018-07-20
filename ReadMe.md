# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created.

## Setting up Purescript for the first time

Follow the instructions from [this blog post](https://qiita.com/kimagure/items/570e6f2bbce5b4724564), which is more up-to-date than the current Purescript by Example book.

Since Purescript uses very fine-grained modules, its hard to know which libraries to use for various needs. Thus, there is a [Batteries included Prelude](https://github.com/tfausak/purescript-batteries/blob/master/src/Batteries.purs) that is unfortunately outdated for Purescript `0.12.0`. However, I checked their dependencies and updated them (see the `/build-tools/updated-batteries.json` file). Some libraries were deprecated and thus no longer appear. Many others were updated to a new version.

## Awesome Purescript index

[See the index](https://github.com/passy/awesome-purescript)

## Deprecated packages

Some packages that worked for older versions of Purescript have been deprecated over time.

[This repo](https://github.com/purescript-deprecated) stores the list

## Purescript Cookbook

[The Purescript Cookbook](http://codingstruggles.com/ps-cookbook/) aims to demonstrate a few simple concepts
