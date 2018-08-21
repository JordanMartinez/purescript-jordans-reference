# Build Tools

For a list of editors one can use, see [this list](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#editors)

For build-related tools, see [this list](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#build-tools-and-package-managers)

## Dependency Manager

### Why doesn't Purescript use `npm`?

The following provides a much shorter explanation of [this article](https://harry.garrood.me/blog/purescript-why-bower/)

Short answer:
- Because NPM doesn't produce a compiler error when multiple versions of the same transitive dependency are used.

Long answer:
- When package `foo` requires `bar v1.0.0` and package `baz` requires `bar v2.0.0`, NPM, will "nest" the packages, so that they will compile
- Should one or both packages export something that exposes `bar` and our code uses it, this will produce a runtime error, either because some API doesn't exist (e.g. one version changed/removed some API) or because a pattern match didn't work (e.g. an `instanceOf` check failed due to seeing different `data Bar` types)
- Bower (the 'official' version) uses "flat" dependencies, so we get the compile error when this situation arises. How? It'll ask you what you want to do to resolve the issues. Rather than decide one over the other, you pull out and rethink through your dependencies.

However, `bower` isn't the only package manager one can use.

### Which dependency manager should I use: Bower or PSC-Package?

One can refer to each with a "crude name" that summarizes them:
- Typical package manager (Bower)
- Glorified `git clone` tool (psc-package)

Those names, plus these flowcharts, will help one get an overview of how they work:

![Bower-flowchart](./bower-flowchart.svg)

![psc-package-flowchart](./psc-package-flowchart.svg)

Now for a side-by-side comparison (an "apples to oranges" comparison)

| | Bower | Psc-Package |
| - | - | - |
| Design Goals | ? | [See this summary](https://github.com/purescript/psc-package#design-goals)
| Official/Unofficial | Official<br>parts of `purs` depend on it | Unofficial
| Trajectory | Moving away | Moving towards
| Pros | <ul><li>Bower caches its dependencies, so you can download a version of a package only once and use it everywhere on your system</li><li>It's the "official" dependency manager for Purescript</li></ul> | <ul><li>**Defines a set of versions of specific packages that are proven via CI to work together**</li><li>Uses Git to work, which is usually already installed on all systems</li><li>Reliably produces reproducible Purescript dependencies</li><li>Reduces verbosity somewhat by omitting the `purescript-` prefix on PureScript packages</li></ul>
| Cons | <ul><li>**Figuring out which version of a package works with another version of a package is needlessly time-consuming**</li><li>Uses node to work, which may not be installed on all systems</li><li>Doesn't always produce reproducible dependencies due to its caching feature.</li></ul> | <ul><li>Uses more memory due to duplicating code when one has multiple projects across their system.</li><li>Not the "official" package manager (but who really determines what is 'official' anyway?)</li><li>If the standard package set does not have some package in it, one must maintain their own copy. (However, [Spachetti](https://github.com/justinwoo/spacchetti) makes it easier to deal with this. [Read its guide](https://spacchetti.readthedocs.io/en/latest/))</li></ul>

## Documenting CLI Options

It's easier to read through the CLI's documentation by reading them in a mind-map format rather than a man-page-like doc.

Download [Freeplane](https://www.freeplane.org/) to read through the documenation in a mind-map format

![build-tools](./Purescript-Build-Tools.mm)

Otherwise, read through the SVG file:

![build-tools-cli-options](./Build-Tools-CLI-Options.svg)

## A new project from start to finish:

The below example assumes that one is installing packages only from the default package set maintained by Justin Woo [here](https://github.com/purescript/package-sets), and not creating their own custom package set.
```bash
#### Create the project: one of two ways: ####

# 1) (not recommended) Via pulp to get the default package set based on
# the system's installed PureScript compiler version (purs).
pulp --psc-package init projectName

# 2) (recommended) Via psc-package to get a more recent package set version
psc-package init --set psc-0.12.0-20180819 --source https://github.com/purescript/package-sets.git
# The resulting psc-package.json file will have `untitled` in its
# 'name' field. Open the file and change that.
nano psc-package.json

#### Install dependencies: one of two ways: ####

# To see which packages are already installed...
psc-package dependencies

# To see which packages are available in your package set...
psc-package available

# 1) Via psc-package install
psc-package install package # remember to omit the 'purescript-' prefix
# Note: only one package can be installed at a time using this approach
psc-package install onlyOnePackage
psc-package install onlyOnePackage
psc-package install onlyOnePackage

# 2) Via manual file modification and the below command:
# Open `psc-package.json`, add dependencies in `deps`, save file. Then run
psc-package install

#### Writing code ####

# Open the REPL to play with a few ideas or run simple tests
psc-package repl        # via psc-package
pulp --psc-package repl # via pulp

# Automatically re-build project whenever a source file is changed/saved
pulp --watch --before 'clear' --psc-package build

# Automatically re-test project whenever a source/test file is changed/saved
pulp --watch --before 'clear' --psc-package test

# Build a developer version
pulp --psc-package browserify --to dist/fileName.js # if program
pulp --psc-package browserify --no-main-check --to dist/fileName.js # if library

# Run the program
pulp --psc-package run -- arg1PassedToProgram arg2PassedToProgram

#### Publishing the package for the first time ####

# Build the docs
pulp --psc-package docs -- --format html
# Then read over them to insure there aren't any formatting issues or typos

# Making a production build via Browserify
# If building a program...
pulp --psc-package browserify --optimise --to dist/fileName.js
# If building a library
pulp --psc-package browserify --no-main-check --optimise --to dist/fileName.js

# Set the initial version
pulp version v0.1.0

# Publish the version
pulp --psc-package publish

#### Publishing a new version ####

# Build and check the docs
pulp --psc-package docs -- --format html

# Make a production build again
# If building a program...
pulp --psc-package browserify --optimise --to dist/fileName.js
# If building a library
pulp --psc-package browserify --no-main-check --optimise --to dist/fileName.js

# bump project version
pulp version major
pulp version minor
pulp version patch
# or specify a version
pulp version v1.5.0

# publish it
pulp --psc-package publish
```

## Other Helpful Links

- [NPM SemVer calculator](https://semver.npmjs.com/)
