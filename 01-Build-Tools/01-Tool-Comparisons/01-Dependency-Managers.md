# Dependency Managers

## Why doesn't Purescript use `npm`?

The following provides a much shorter explanation of [this article](https://harry.garrood.me/blog/purescript-why-bower/)

Short answer:
- Because NPM doesn't produce a compiler error when multiple versions of the same transitive dependency are used.

Long answer:
- When package `foo` requires `bar v1.0.0` and package `baz` requires `bar v2.0.0`, NPM, will "nest" the packages, so that they will compile
- Should one or both packages export something that exposes `bar` and our code uses it, this will produce a runtime error, either because some API doesn't exist (e.g. one version changed/removed some API) or because a pattern match didn't work (e.g. an `instanceOf` check failed due to seeing different `data Bar` types)
- Bower (the 'official' version) uses "flat" dependencies, so we get the compile error when this situation arises. How? It'll ask you what you want to do to resolve the issues. Rather than decide one over the other, you pull out and rethink through your dependencies.

However, `bower` isn't the only package manager one can use. `psc-package` is also used throughout the community.

## Which dependency manager should I use: Bower or PSC-Package?

One can refer to each with a "crude name" that summarizes them:
- Typical package manager (Bower)
- Glorified `git clone` tool (psc-package)

Those names, plus these flowcharts, will help one get an overview of how they work:

### Bower Flowchart

![Bower-flowchart](./bower-flowchart.svg)

### Psc-Package Flowchart

![psc-package-flowchart](./psc-package-flowchart.svg)

Now for a side-by-side comparison (an "apples to oranges" comparison)

| | Bower | Psc-Package |
| - | - | - |
| Design Goals | ? | [See this summary](https://github.com/purescript/psc-package#design-goals)
| Official/Unofficial | Official<br>(parts of `purs` depend on it) | Unofficial
| Trajectory | Moving away? | Moving towards?
| Pros | <ul><li>**Bower is required for one to publish docs to [Pursuit](https://pursuit.purescript.org/)**</li><li>Bower caches its dependencies, so you can download a version of a package only once and use it everywhere on your system</li><li>It's the "official" dependency manager for Purescript</li></ul> | <ul><li>**Defines a set of versions of specific packages that are proven via CI to work together**</li><li>Uses Git to work, which is usually already installed on all systems</li><li>Reliably produces reproducible Purescript dependencies</li><li>Reduces verbosity somewhat by omitting the `purescript-` prefix on PureScript packages</li></ul>
| Cons | <ul><li>**Figuring out which version of a package works with another version of a package is needlessly time-consuming**</li><li>Uses node to work, which may not be installed on all systems</li><li>Doesn't always produce reproducible dependencies due to its caching feature.</li></ul> | <ul><li>If developing a library, one cannot publish docs to Pursuit without Bower. (If developing an end-user app, this doesn't matter.)</li><li>Uses more storage space due to duplicating code when one has multiple projects across their system.</li><li>Not the "official" package manager (but who really determines what is 'official' anyway?)</li><li>If the standard package set does not have some package in it, one must maintain their own copy.^^ (However, [Spachetti](https://github.com/justinwoo/spacchetti) makes it easier to deal with this. [Read its guide](https://spacchetti.readthedocs.io/en/latest/))</li></ul>

^^ This is explained later in this folder ("Create Local Custom Package Set.md")

### Why Spacchetti?

#### Psc-Package Terms

A **package** in this context is 4 things:
1. a Git repo
2. a tag in that repo
3. a set of its dependencies (which are also packages).
4. a name to refer to the combination of the above three things

Thus, a package is a unique named `repo-tag-dependencies` combination (e.g. `prelude` could indicate the [Prelude repo at the 'v0.4.1' tag](https://github.com/purescript/purescript-prelude/tree/v4.1.0)).

A **package set** consists of a set of packages. It's a JSON file that maps a package name to its corresponding repo-tag-dependencies combination.

#### The Cause of the Pain Point

When using Bower, you have no idea whether a package (code that was released at some tag) will compile with some other package. AFAIK, Phil Freeman (creator of PureScript) and others created `psc-package` to fix this problem. Currently, Justin Woo maintains it.

Justin has defined an "official" / "standard" package set [here](https://github.com/purescript/package-sets/blob/master/packages.json) that `psc-package` uses to download and compile one's dependencies. Why? So that he can prove via CI that all the packages in the set work/compile together without issue. This addresses the pain point from Bower. Moreover, it also stops each developer who uses `psc-package` from wasting time verifying the same package set locally as it can be done only once in Justin's repo.

This "guaranteed to work together" feature comes with implications:
- The "official" / "standard" package set must be immutable. Our confidence that packages work together is broken as soon as a new package is added. Adding a package requires reverifying that all the packages work when the package is added.
- Following from this, changing the package set in any way requires Justin to re-verify it via CI and make a new release of the "official" / "standard" package set.

These implications create the following problems:
1. Your workflow is blocked when you need a dependency/library that is not already defined as a package within the "official" / "standard" package set.
  - When this occurs, you or the library/dependency author have to add it to the "official" / "standard" package set yourself, AND THEN wait for Justin to merge that pull request, AND THEN wait for verification to finish (it might fail verification in some cases), AND THEN wait for Justin to make a new relase of the "official" / "standard" package set. That's a lot of waiting.
2. Your workflow is blocked when you need a dependency/library that is in the package set, but which needs to be patched/changed in some way. For example, a library for handling a `MouseEvent`does not include `mouseEvent.offsetX` ([true story](https://pursuit.purescript.org/packages/purescript-web-uievents/1.0.0/docs/Web.UIEvent.MouseEvent#v:clientX))
  - This situation is the same as the above except now you or the author need to submit a PR to the library/dependency to fix the issue, AND THEN wait for the library maintainer to make a new release, AND THEN go through all of the steps above.

Moreover, you likely only need to make some change in only one project. It's not worth it to submit a PR, either to Justin's package set repo or a library's repo, because it's custom to your use cases.

Fortunately, `psc-package` does not know about or even have a notion of the "official" / "standard" package set. A developer can still verify packages in a package set on their own. However, manipulating the packaget set's files is very tedious.

To add a new or patch an existing package, here's the steps one has to take (where items marked with `*` are the tedious parts):
- `*`Create a local copy of the "official" / "standard" package set
- `*`Add a new package to or modify an existing package's repo/tag in the local package set
- `*`Locally verify that the package set compiles together
- `*`Refer to the local package set in one's `psc-package.json` file instead of the "official" / "standard" package set.
- Re-install the packages and continue coding from there.

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
