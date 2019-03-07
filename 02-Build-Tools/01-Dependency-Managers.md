# Dependency Managers

## Why doesn't Purescript use `npm`?

The following provides a much shorter explanation of [Why the PureScript Community Uses Bower](https://harry.garrood.me/blog/purescript-why-bower/)

Short answer:
- Because NPM doesn't produce an error when multiple versions of the same transitive dependency are used.

Long answer:
- When package `child1` requires `parent v1.0.0` and package `child2` requires `parent v2.0.0`, NPM, will "nest" the packages, so that the code will compile.
- Should one or both packages export something that exposes `parent` and our code uses it, this will produce a runtime error, either because some API doesn't exist (e.g. one version changed/removed some API) or because a pattern match didn't work (e.g. an `instanceOf` check failed due to seeing different types defined in the `parent` package)
- Bower uses "flat" dependencies, so it will notify you that such an issue exists by asking you to choose the library version you want to use to resolve the issue.

## Two Solutions: Bower and Psc-Package

There are two solutions to dependency management where each has a different 'target audience' per say:
1. Bower (library developers)
2. Psc-package (application developers)

The community needs both solutions for reasons that will be explained later.

One can refer to each with a "crude name" that summarizes them:
- Typical package manager (Bower)
- Glorified `git clone` tool (psc-package)

Those names, plus these flowcharts, will help one get an overview of how they work:

### Bower Flowchart

![Bower-flowchart](./bower-flowchart.svg)

### Psc-Package Flowchart

![psc-package-flowchart](./psc-package-flowchart.svg)

## Dependency Managers Compared

Now for a side-by-side comparison (an "apples to oranges" comparison)

| | Bower | Psc-Package/Spago |
| - | - | - |
| Ideal User | <ul><li>Library Developers</li><li>People exploring the language/ecosystem</li></ol> | <ul><li>Application Developers</li><li>People learning the language via a CI-proven learning material</li></ul> |
| Official/Unofficial | Official<br>(parts of the PureScript compiler depend on it) | Unofficial
| Trajectory | Moving away? | Moving towards?
| Design Goals | ? | [See this summary](https://github.com/purescript/psc-package#design-goals)
| Pros | <ul><li>**Bower is required for one to publish a library's docs to [Pursuit](https://pursuit.purescript.org/)**</li><li>Bower caches its dependencies, so you can download a version of a package only once and use it everywhere on your system</li><li>It's the "official" dependency manager for Purescript</li></ul> | <ul><li>**One never experiences the aforementioned "transitive dependency conflicts"**</li><li>Uses Git to work, which is usually already installed on all systems</li><li>Reliably produces reproducible Purescript dependencies</li><li>Reduces verbosity somewhat by omitting the `purescript-` prefix on PureScript packages</li></ul>
| Cons | <ul><li>**When a recent compiler release has been made, one will encounter the 'transitive dependency' issue above quite frequently until all the libraries in the ecosystem are updated to the new release. Figuring out which version of a package works with another wastes a lot of time.**</li><li>Uses node to work, which may not be installed on all systems</li><li>Doesn't always produce reproducible dependencies due to its caching feature.</li></ul> | <ul><li>**One cannot publish a library's docs to Pursuit.**</li><li>Uses more storage space due to duplicating code when one has multiple projects across their system.</li><li>If the standard package set does not have some package in it, one must maintain their own copy or learn how to use [Spacchetti](https://github.com/spacchetti/spacchetti)/[Spago](https://github.com/spacchetti/spago).</li></ul>

## Explaining Psc-Package

### Psc-Package Terms

A **package** in this context is 4 things:
1. a Git repo
2. a tag in that repo
3. a set of its dependencies (which are also packages).
4. a name to refer to the combination of the above three things

Thus, a package is a unique named `repo-tag-dependencies` combination (e.g. `prelude` could indicate the [Prelude repo at the 'v0.4.1' tag](https://github.com/purescript/purescript-prelude/tree/v4.1.0)).

A **package set** consists of a set of packages. It's a JSON file that maps a package name to its corresponding repo-tag-dependencies combination.

### The Cause of the Pain Point

When using Bower, you have no idea whether a version of some dependency will compile with some other package. This pain point arises most often when a breaking changes compiler release is made. AFAIK, Phil Freeman (creator of PureScript) and others created `psc-package` to help fix this problem / start migrating to a non-Bower solution. Currently, Justin Woo maintains it.

Justin has defined [an "official" / "standard" package set](https://github.com/purescript/package-sets/blob/master/packages.json) that `psc-package` uses to download and compile one's dependencies. Why? So that he can prove via CI that all the packages in the set work/compile together without issue. This addresses the pain point from Bower. Moreover, it also stops each developer who uses `psc-package` from wasting time verifying the same package set locally as it can be done only once in Justin's repo.

This "guaranteed to work together" feature comes with implications:
- The "official" / "standard" package set must be immutable. Our confidence that packages work together is broken as soon as a new package is added. Adding a package requires reverifying that all the packages work when the package is added.
- Following from this, changing the package set in any way requires Justin to re-verify it via CI and make a new release of the "official" / "standard" package set.

These implications create the following problems:
1. You cannot use a package that is not yet defined in the "official" / "standard" package set.
2. You cannot use your own patched version of a package that is defined in the "official" / "standard" package set.

To account for the above issues, one would need to define their own local package set, which is quite tedious to do.

#### Solving the Pain Point

Justin fixed this by using `Spacchetti` and `Dhall`. Now, one can easily and quickly patch/change/add a package in some set using Dhall by following these steps:
1. Run `spacchetti local-setup`
2. Patch/Change/Add packages to the package set by modifying the `packages.dhall` file, which now includes my instructions and examples for how to do so (this was added [here](https://github.com/justinwoo/spacchetti-cli/pull/18/commits/f949f1ca951be3570a38c0f007b5a28ecf920cf1#diff-eb94b4b0f53b1dc125cfee4342687dd0R2))
3. Run `spacchetti insdhall`
4. Run `psc-package verify` (if you know it works, you can skip this step)
5. Run `psc-package install`

In other words, a potentially weeks-long problem can become a few-seconds fix.

## The `Batteries` Prelude

The closest idea Bower has to a `package set` is the [`batteries` prelude](https://github.com/tfausak/purescript-batteries) that is no longer maintained and doesn't work for PureScript 0.12.0. I looked through it a month ago and updated the dependencies in their `bower.json` file to [this file](updated-batteries.json), which enables one to use the [Halogen](https://github.com/slamdata/purescript-halogen) library, v4.0.0. (Note: this file is not a correctly-formatted Bower.json file). I abandoned it after I learned about psc-package, but I'm including it here in case others want to use Bower and find a use for it.
