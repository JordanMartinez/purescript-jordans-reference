# Custom Type Errors

## Pre-reqs for This Folder

To understand this folder's contents, you should read and be somewhat familiar with Type-Level Syntax. If you haven't already done so, go read through that folder's contents.

## Scope of This Folder

This folder will demonstrate how to write Custom Type Errors (i.e. custom compiler warnings and errors) and why one might find it useful. It provides the foundations for understanding why something happens in the next folder's code. This folder does not get deep into how to do type-level programming. That will be covered later.

In this folder, we'll be using the infix aliases from [purescript-typelevel-eval](https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0). We won't be directly importing it here because it does not yet exist in the default package set (as of this writing).
