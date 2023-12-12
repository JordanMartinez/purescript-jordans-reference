# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). This file is updated via [purs-changelog](https://github.com/JordanMartinez/purescript-up-changelog)

## ps-0.15.x-v0.33.0

Breaking changes:

* Split example CI files into own files; add spago next/legacy (#616 by @JordanMartinez)

  Previously, the `Continuous-Integration.md` file stored
  sample CI files for GitHub Actions in a code block.

  These weren't easy to copy-and-paste, so I've moved them
  into their own files with a Readme file explaining them.

  I also distinguish between Spago Legacy (Haskell-version)
  from Spago Next (PureScript version)

* Update PureScript to v0.15.13 (#619 by @JordanMartinez)

* Update Spago to 0.21.0 (#619 by @JordanMartinez)

New features:

* Link to `falsify` and other property-testing-related links (#619 by @JordanMartinez)

* Link to `fp-ts`' migration guide from PS to TS (#619 by @JordanMartinez)

* Link to Free Boolean Cube (#619 by @JordanMartinez)

* Add link to GADTs: Defeating Return Type Polymorphism (#619 by @JordanMartinez)

* Adds a table clarifying the difference `spago` Haskell and PureScript codebases (#619 by @JordanMartinez)

* Add an initial explanation for Visible Type Applications (VTAs) (#619 by @JordanMartinez)

  This change affects the following folders:
  - Basic Syntax
  - Type-Level Syntax
  - Hello World/Type-Level Programming

  Reading through each is needed to get the full picture of VTAs.

* Link to 'PureScript for Elm Developers' (#618 by @laurentpayot)

Bugfixes:

* Fix erroneous Effect example (#619 by @JordanMartinez)

* Fix instantiation of `StateT`'s `MonadState` example (#619 by @JordanMartinez)

* Miscellaneous tweaks to build tool history (#619 by @JordanMartinez)

* Fix Pursuit operator search (#615 by @MarkFarmiloe)

* Fix Function Monad typo (#613 by @kettron)

* Fix 'for ... break if' typo (#605 by @sorenhoyer)

Internal:

* Begin using [purs-changelog](https://github.com/purescript-contrib/purescript-up-changelog) to manage changelog entries. (#616 by @JordanMartinez)

  Previous changelogs were moved into the `old-changelogs` directory.
  The previous generated changelogs weren't as useful/readable as just
  keeping a manual log. I also think this will be easier to track what
  changed as I can add/edit an entry as I make the change itself.

## Previous Releases

For all releases prior to ps-0.15.x-v0.32.0, see [old-changelogs](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/old-changelogs)
