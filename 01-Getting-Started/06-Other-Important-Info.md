# Other Important Info

- [Functional Programming Made Easier](https://leanpub.com/fp-made-easier) is a more recent work that literally walks you through every possible thought process, mistake, compiler error, and issue you would need to make to learn PureScript and build a web application in one book. I would recommend reading this book over the **PureScript by Example** book below.
- [Purescript By Example](https://book.purescript.org/) is the official up-to-date book that teaches Purescript.
- [PureScript Cookbook](https://github.com/JordanMartinez/purescript-cookbook) is an unofficial cookbook that shows "How to do X" in PureScript.
- ["Not Yet Awesome" PureScript](https://github.com/milesfrain/not-yet-awesome-purescript) is a list of things that are not _yet_ awesome in PureScript
- [Configure Web Browser for Convenient Pursuit Lookup](https://discourse.purescript.org/t/tip-configure-web-browser-for-convenient-pursuit-lookup/1561) shows how to make it easy to search all documentation.
    - Consider using this same approach to setup a search using **Starsuit**, a Pursuit copy that works only packages in the latest package-set (a concept described more in the Build Tools folder of this repo). Use "https://spacchetti.github.io/starsuit/#search:" as your search.
- [PureScript Migration Guides](https://github.com/purescript/documentation/tree/master/migration-guides) when a breaking change is made.

## Functional Programming Jargon

While reading through this repo, the [Functional Programming Jargon](https://github.com/hemanth/functional-programming-jargon) might be a helpful reference whenever you come across a term that isn't covered in this project.

## Writing Algorithms in an FP Language

This repo will not explain how to write algorithms in a performant way using an FP language. Consider reading [Algorithm Design with Haskell](https://www.amazon.com/Algorithm-Design-Haskell-Richard-Bird/dp/1108491618) which does teach algorithms using an FP language.

## Differences From Haskell

If you're coming to PureScript with a Haskell background, be sure to consult the following resources:
- [Introduction to Purescript for Haskell Developers](http://code.adriansieber.com/adrian/adriansieber-com/src/branch/master/posts/_2018-11-01_introduction_to_purescript_for_haskell_developers/main_light.pdf) (pdf)
- [The Purescript Documentation Repo's "Differences from Haskell" page](https://github.com/purescript/documentation/blob/master/language/Differences-from-Haskell.md)

## Differences From Elm

If you're coming to PureScript with an Elm background, [PureScript for Elm developers](https://github.com/laurentpayot/purescript-for-elm-developers#readme) is a gentle introduction to the PureScript concepts.

## Use GitHub Search to Find Things Search Engines (i.e. Google) Don't

At various times, you may try to use something like Google to find documentation / examples and little will appear in the search results.

A better solution is to use GitHub's search. To learn its syntax, read [searching code](https://help.github.com/en/articles/searching-code).

Then, you use a search query like the following:

| Goal | Search Query | Meaning |
| - | - | - |
| Find examples of projects that use a dependency (e.g. `purescript-prelude`) | [`path:/ in:file purescript-prelude`](https://github.com/search?q=path%3A%2F+in%3Afile+purescript-prelude) | Search a project's top-level files (e.g. `bower.json`/`spago.dhall`/`psc-package.json`) for the text `purescript-prelude`
| Find real-world examples of code that uses libraries (e.g. `aff-bus`) | [`language:purescript path:src/ in:file "Effect.Aff.Bus"`](https://github.com/search?q=language%3Apurescript+path%3Asrc%2F+in%3Afile+Bus) | Search a project's `src` directory for files whose content mentions the `Effect.Aff.Bus` module at some point. (Note: the full module name must be surrounded by quotes)
| Find real-world examples of code that uses testing libraries (e.g. `aff-bus`) | [`language:purescript path:test/ in:file "Test.QuickCheck"`](https://github.com/search?q=language%3Apurescript+path%3Atest%2F+in%3Afile+QuickCheck) | Search a project's `test` directory for files whose content mentions the `Test.QuickCheck` module at some point. (Note: the full module name must be surrounded by quotes)

## Documentation

- Anytime you need to look up the documentation for a package, you have two options:
    - use [Pursuit](http://pursuit.purescript.org/).
        - Pros: One can navigate through a library's version and dependencies
        - Cons: Some of the deprecated packages mentioned above are still posted there. (e.g. `purescript-dom-*` packages, which are deprecated in favor of `purescript-web-*` packages)
    - use [Starsuit](https://spacchetti.github.io/starsuit/index.html)
        - Pros: Only provides documentation for packages in the latest package set
        - Cons: One does not immediately know which version of a library is displayed, nor what its dependencies are.
- Read [Pursuit's Search Help page](https://pursuit.purescript.org/help/users#searching)
- Lastly, some libraries have not uploaded their latest versions' documentation. In these cases, we will forewarn you. Fortunately, `spago docs` will produce a local version of the source code's documentation that looks similar to Pursuit. It does not support all the features of Pursuit, but it's better than nothing. To do that, follow these commands:
    - `spago docs --open` will generate the documentation and then use your default web browser to open the file, `generated-docs/html/index.html`.

**Undocumented Pursuit Tip**

To get the latest version of the Pursuit docs of a package's function, package's type, or the package itself, simply remove the version in the url. Pursuit will load the latest version of that package:
https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Eq
