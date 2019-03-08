# Psc-Package Explained

## What is it?

A way to use specific versions of libraries that are known to compile together without problems, as verified by CI.

## Why Use It?

`psc-package` only allows you to use dependencies that compile together. You do not have to track down which version of a dependency to use, and then figure out whether all your dependencies compiler together.

When a new PureScript release with breaking changes occurs, using `bower` is painful until the ecosystem "catches up." Since a new release draws in a lot of people, their initial exploration of PureScript can be horrible.

`psc-package` also allows you to
- 'patch' a dependency with your own version
    - fix a bug in its implementation
    - update a library to a newer PS release
    - update a library to use a different version of a transitive dependency so it can work now
- use dependencies defined locally
    - a project you use frequently, like a custom `Prelude` library.

## How does it work?

### Psc-Package Terms

A **package** in this context is 4 things:
1. a Git repo
2. a tag in that repo
3. a set of its dependencies (which are also packages).
4. a name to refer to the combination of the above three things

Thus, a package is a unique named `repo-tag-dependencies` combination (e.g. `prelude` could indicate the [Prelude repo at the 'v0.4.1' tag](https://github.com/purescript/purescript-prelude/tree/v4.1.0)).

A **package set** consists of a set of packages. It's a JSON file that maps a package name to its corresponding repo-tag-dependencies combination.

### The Process It Uses

![psc-package-flowchart](./assets/psc-package-flowchart.svg)

`psc-package` will use a package set to download (via `git clone`) one's dependencies' source code and use the PureScript compiler to compile one's dependencies' source code alongside of one's project's source code.

Defining a local package set is tedious. Thus, it's easier to use [the "official" package set](https://github.com/purescript/package-sets/blob/master/packages.json). This "official" package set includes most of the packages you need. All packages in this set have been verified by CI to compile together without issue.

## Problem Points?

None besides being unable to use this workflow to develop libraries.
