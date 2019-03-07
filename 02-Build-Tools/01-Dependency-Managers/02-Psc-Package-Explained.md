# Psc-Package Explained

## What is it?

A way to use specific versions of libraries that are known to compile together without problems, as verified by CI.

## Why Use It?

When a new PureScript release with breaking changes occurs, it is difficult to know which dependencies compile together. Until the ecosystem "catches up," using Bower is painful.
Since `psc-package` only allows you to use dependencies that compile together, this is never an issue.

`psc-package` also allows you to 'patch' a dependency without needing to submit a PR. This can arise when you want to add a function inside a dependency's module for convenience or fix a bug in its implementation.

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

### Problems Caused by Using the "Official" Package Set

Problem 1: Packages not yet defined in the "official" package set are unusable.

The "official" / "standard" package set must be immutable. Our confidence that packages work together is broken as soon as a new package is added. Adding a package requires reverifying that all the packages work when the package is added.

Thus, if your package is not already in the "official" package set. You can't use it.

Problem 2: One cannot easily/quickly "patch" a package in the "official" package set.

### Problems Caused by Using a Local Package Set

The advantages of a local package set is the amount of customization you have available. You can patch the packages in the package set.

However, it's really tedious to create a new package set for each one of your projects. It's also tedious to modify a JSON file by hand.

## Solution to the Problem Points: Spacchetti

Spacchetti essentially clones the 'official' package set for you into a local file and makes it easy to edit it correctly by using Dhall. Thus, one gets all the advantages of having the "official" package set with the quick and painless customization one wants.

To patch/change/add a package in a local version of the "official" package set using Dhall, one follows these steps:
1. Run `spacchetti local-setup`
2. Patch/Change/Add packages to the package set by modifying the `packages.dhall` file, which now includes [my instructions and examples for how to do that](https://github.com/justinwoo/spacchetti-cli/pull/18/commits/f949f1ca951be3570a38c0f007b5a28ecf920cf1#diff-eb94b4b0f53b1dc125cfee4342687dd0R2)
3. Run `spacchetti insdhall` to create a local package set
4. Run `psc-package verify` to verify that all packages compile together without problems (if you know it works, you can skip this step)
5. Run `psc-package install` to download the source code of the dependencies and make it possible to use them in your project.
