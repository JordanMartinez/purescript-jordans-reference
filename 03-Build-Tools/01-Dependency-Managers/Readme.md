# Dependency Managers

There are two solutions to dependency management where each has a different 'target audience' per say:
1. Bower (library developers)
2. Spago (application developers)

The community needs both solutions for reasons that will be explained later.

Each one will be further explained in its own file. However, one can refer to each with a "crude name" that summarizes them:
- Typical package manager (Bower)
- Glorified `git clone` tool (Spago)

## Dependency Managers Compared

This side-by-side comparison should be thought of as an "apples to oranges" comparison.

| | Bower | Spago |
| - | - | - |
| Ideal User | <ul><li>Library Developers</li><li>People exploring the language/ecosystem</li></ol> | <ul><li>Application Developers</li><li>People learning the language via a CI-proven learning material</li></ul> |
| Official/Unofficial | Official<br>(parts of the PureScript compiler depend on it) | Unofficial
| Trajectory | Moving away? | Moving towards?
| Design Goals | ? | [See this summary of a project that later "evolved" into Spago](https://github.com/purescript/psc-package#design-goals)
| Pros | <ul><li>**Bower is required for one to publish a library's docs to [Pursuit](https://pursuit.purescript.org/)**</li><li>Bower caches its dependencies, so you can download a version of a package only once and use it everywhere on your system</li><li>It's the "official" dependency manager for Purescript</li></ul> | <ul><li>**One never experiences the aforementioned "transitive dependency conflicts"**</li><li>Uses Git to work, which is usually already installed on all systems</li><li>Reliably produces reproducible Purescript dependencies</li><li>Reduces verbosity somewhat by omitting the `purescript-` prefix on PureScript packages</li></ul>
| Cons | <ul><li>**When a recent compiler release has been made, one will encounter the 'transitive dependency' issue above quite frequently until all the libraries in the ecosystem are updated to the new release. Figuring out which version of a package works with another wastes a lot of time.**</li><li>Uses node to work, which may not be installed on all systems</li><li>Doesn't always produce reproducible dependencies due to its caching feature.</li></ul> | <ul><li>**One cannot publish a library's docs to Pursuit.**</li><li>Uses more storage space due to duplicating code when one has multiple projects across their system.</li></ul>
