# Other Important Info

- [Purescript By Example](https://book.purescript.org/) is the official up-to-date book that teaches Purescript.
- [PureScript Cookbook](https://github.com/JordanMartinez/purescript-cookbook) is an unofficial cookbook that shows "How to do X" in PureScript.

## Functional Programming Jargon

While reading through this repo, the [Functional Programming Jargon](https://github.com/hemanth/functional-programming-jargon) might be a helpful reference whenever you come across a term that isn't covered in this project.

## Differences From Haskell

If you're coming to PureScript with a Haskell background, be sure to consult the following resources:
- [Introduction to Purescript for Haskell Developers](http://code.adriansieber.com/adrian/adriansieber-com/src/branch/master/posts/_2018-11-01_introduction_to_purescript_for_haskell_developers/main_light.pdf) (pdf)
- [The Purescript Documentation Repo's "Differences from Haskell" page](https://github.com/purescript/documentation/blob/master/language/Differences-from-Haskell.md)

## Use GitHub Search to Find Things Search Engines (i.e. Google) Don't

At various times, you may try to use something like Google to find documentation / examples and little will appear in the search results.

A better solution is to use GitHub's search. To learn its syntax, read [searching code](https://help.github.com/en/articles/searching-code).

Then, you use a search query like the following:

| Goal | Search Query | Meaning |
| - | - | - |
| Find examples of projects that use a dependency (e.g. `purescript-prelude`) | [`path:/ in:file purescript-prelude`](https://github.com/search?q=path%3A%2F+in%3Afile+purescript-prelude) | Search a project's top-level files (e.g. `bower.json`/`spago.dhall`/`psc-package.json`) for the text `purescript-prelude`
| Find real-world examples of code that uses libraries (e.g. `aff-bus`) | [`language:purescript path:src/ in:file "Effect.Aff.Bus"`](https://github.com/search?q=language%3Apurescript+path%3Asrc%2F+in%3Afile+Bus) | Search a project's `src` directory for files whose content mentions the `Effect.Aff.Bus` module at some point. (Note: the full module name must be surrounded by quotes)
| Find real-world examples of code that uses testing libraries (e.g. `aff-bus`) | [`language:purescript path:test/ in:file "Test.QuickCheck"`](https://github.com/search?q=language%3Apurescript+path%3Atest%2F+in%3Afile+QuickCheck) | Search a project's `test` directory for files whose content mentions the `Test.QuickCheck` module at some point. (Note: the full module name must be surrounded by quotes)

## Documenation

- Anytime you need to look up the documentation for a package, you have two options:
    - use [Pursuit](http://pursuit.purescript.org/).
        - Pros: One can navigate through a library's version and dependencies
        - Cons: Some of the deprecated packages mentioned above are still posted there. (e.g. `purescript-dom-*` packages, which are deprecated in favor of `purescript-web-*` packages)
    - use [Starsuit](https://spacchetti.github.io/starsuit/index.html)
        - Pros: Only provides documentation for packages in the latest package set
        - Cons: One does not immediately know which version of a library is displayed, nor what its dependencies are.
- Use the [same instructions used by Hoogle](https://github.com/ndmitchell/hoogle/blob/master/README.md#chrome-integration) to add Pursuit as a search engine to your web browser.
- Read [Pursuit's Search Help page](https://pursuit.purescript.org/help/users#searching)
- Some libraries have not been updated to `0.13.8` and are still on the `0.11.7` release. Some still work; others won't. In this work, we will insure that you do not use any such libraries, but be aware of that if you browse the docs on your own.
- Lastly, some libraries have not uploaded their latest versions' documentation. In these cases, we will forewarn you. Fortunately, `spago docs` will produce a local version of the source code's documentation that looks similar to Pursuit. It does not support all the features of Pursuit, but it's better than nothing. To do that, follow these commands:
    - `spago docs --open` will generate the documentation and then use your default web browser to open the file, `generated-docs/html/index.html`.

**Undocumented Pursuit Tip**

To get the latest version of the Pursuit docs of a package's function, package's type, or the package itself, simply remove the version in the url. Pursuit will load the latest version of that package:
https://pursuit.purescript.org/packages/purescript-prelude/docs/Data.Eq
