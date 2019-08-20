# Other Important Info

[Purescript By Example](https://leanpub.com/purescript/read#) is a book that teaches Purescript. Unfortunately, it is now outdated because it covers Purescript `0.11.7`. The `0.12.0` release included a lot of breaking changes that would require significantly updating the book. However, it's still a useful learning resource.

If you decide to read the book, here are things to be aware of:
- be wary of any references to these [deprecated packages](https://github.com/purescript-deprecated)
- **Refer to [`dwhitney`'s fork of the book's code](https://github.com/dwhitney/purescript-book/tree/0.12)**, which is currently being updating to use `0.13.3`.
- Refer to `Hello-World/Effect-and-Aff/Effect-Eff-and-Aff.md` to understand how to translate the no-longer-used `Eff` type to `Effect` type.

## Differences From Haskell

If you're coming to PureScript with a Haskell background, be sure to consult the following resources:
- [Introduction to Purescript for Haskell Developers](http://code.adriansieber.com/adrian/adriansieber-com/src/branch/master/posts/_2018-11-01_introduction_to_purescript_for_haskell_developers/main.pdf) (pdf)
- [The Purescript Documentation Repo's "Differences from Haskell" page](https://github.com/purescript/documentation/blob/master/language/Differences-from-Haskell.md)

## Use GitHub Search to Find Things Search Engines (i.e. Google) Don't

At various times, you may try to use something like Google to find documentation / examples and little will appear in the search results.

A better solution is to use GitHub's search. To learn its syntax, read [searching code](https://help.github.com/en/articles/searching-code).

Then, you use a search query like the following:

| Goal | Search Query | Meaning |
| - | - | - |
| Find examples of projects that use a dependency (e.g. `purescript-prelude`) | [`path:/ in:file purescript-prelude`](https://github.com/search?q=path%3A%2F+in%3Afile+purescript-prelude) | Search a project's top-level files (e.g. `bower.json`/`spago.dhall`/`psc-package.json`) for the text `purescript-prelude`
| Find real-world examples of code that uses libraries (e.g. `aff-bus`) | [`language:purescript path:src/ in:file Bus`](https://github.com/search?q=language%3Apurescript+path%3Asrc%2F+in%3Afile+Bus) | Search a project's `src` directory for files whose content mentions the `Bus` module at some point. (Note: Searching using the full module name (e.g. `Effect.Aff.Bus` doesn't work well)
| Find real-world examples of code that uses testing libraries (e.g. `aff-bus`) | [`language:purescript path:test/ in:file QuickCheck`](https://github.com/search?q=language%3Apurescript+path%3Atest%2F+in%3Afile+QuickCheck) | Search a project's `test` directory for files whose content mentions the `QuickCheck` module at some point. (Note: Searching using the full module name (e.g. `Test.QuickCheck` doesn't work well)

## Documenation

- Anytime you need to look up the documentation for a package, use [Pursuit](http://pursuit.purescript.org/). Be aware that some of the deprecated packages mentioned above are still posted there.
- Read [Pursuit's Search Help page](https://pursuit.purescript.org/help/users#searching)
- Some libraries have not been updated to `0.13.3` and are still on the `0.11.7` release. Some still work; others won't. In this work, we will insure that you do not use any such libraries, but be aware of that if you browse the docs on your own.
- Lastly, some libraries have not uploaded their latest versions' documentation. In these cases, we will forewarn you. Fortunately, `spago docs` will produce a local version of the source code's documentation that looks similar to Pursuit. It does not support all the features of Pursuit, but it's better than nothing. To do that, follow these commands:
    - `spago docs && <your default web browser> generated-docs/html/index.html` where `<your default web browser` is `firefox` or whatever you use.

**Undocumented Pursuit Tip**

To get the latest version of the Pursuit docs of a package's function, package's type, or the package itself, simply remove the version in the url. Pursuit will load the latest version of that package:
https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Eq
