# Old Changelog

This changelog records all the PRs prior to and include tag `ps-0.13.x-v0.18.2` that had the "release-pr" label.

## ps-0.13.x-v0.18.2

- Fixes #378
- Fixes #377
- Fixes #376
- Fixes #375
- Fixes #366

Things without an issue:
- cleans up / corrects some of what I summarized on contravariance and functors
- Adds the yEd file used to create the type classes hierarchy SVG file

## ps-0.13.x-v0.18.1

Updates the project to use the PureScript `0.13.3` release. Also adds a few other links and cleans up a few things.

Upgrade Spago to 0.9.0.0

### Items with an issue

- Fixes #373
- Fixes #372
- Fixes #371
- Fixes #369

### Items without an issue

- Updated documentation syntax to explain that markdown tables are not rendered properly.
- Updated 'for each folder, compile and install dependencies' script (some things weren't getting deleted; old non-existent tests were still being run and resulted in errors
- Upgrade repo to latest package set

## ps-0.13.x-v0.17.1

Fixes #363

Another breaking change I forgot to include in #361 was removing the `Node.ReadLine` files in the `Projects/src/Libraries` folder. These files have been deleted (since they now exist in the `Hello World/Effect and Aff` folder) and instead have been replaced with a simpler example of how to use Node.ReadLine with Aff.

Other changes (no issue)

- Updates the overview of `Node.ReadLine` in `Hello World/Effect and Aff` folder to show that one can use Effect but this produces the Pyramid of Doom and thus why using Aff solves this.
- Add section showing the difference between not using ExceptT and using ExceptT
- Indicate purpose of `purescript-aff-promies` library

## ps-0.13.x-v0.17.0

### Summary of Major Changes

There were a few goals for this PR. Most of them were driven by #356. So, here's the major changes:
- In Prelude-ish, the 'Appendably' type classes were split into two parts: Semigroup and Monoid and a link to Harry's Numeric Hierarchy tutorial. The first part appears before the Monad type class hierarchy so that I can use `@cvlad`'s summary table and link to an explanation on the famous Monad quote.
- 'Hello World and Effects' was renamed to 'Effect and Aff' and now includes a summary of `Aff` and how to use its basic API. Rather than waiting to cover 'Aff' until the `Projects` folder, I thought it would be better to cover it alongside of `Effect`. This also means I cover `MonadEffect` here rather than in the `Debugging` folder. While covering `Aff`, I used `Node.ReadLine` as an example of how to covert `Effect` computations that require callbacks into `Aff` ones. Now, the reader can create console-based programs using the API covered.
- The example of a computation that uses local mutable state had usage of `traceM` removed. Now, I simply notify the reader that we'll show how to print values later in the Debugging folder. Thus, the Debugging folder now includes the local mutable state file with `traceM` included and a warning about abusing it.
- The `Application Structure` folder was repositioned to come much earlier in the 'Hello World' root folder. It now appears after the `Debugging` folder. Since one only needs to understand type level programming when it covers `Run`, I decided to put the Type Level Programming folder after the Application Structure folder and then have the reader read the TLP folder before they read through App Structure's "From Free to Run" folder's contents. By covering monad transformers earlier, I can now easily cover `MonadGen` and the `Gen` monad in the Testing folder, which leaves the Benchmarking folder at the end.
- The `Application Structure` folder now includes new content that appears before I explain how we get the `StateT`/`MonadState` entities. It first provides a "badly structured" program written in PureScript and points out why it's bad. Then, it explains how a function can be a monad and compares one function, `(a -> b)`, to its counterpart, `(a -> monad b)`, using the monad, `Box`. The table of monad transformers has been updated to better distinguish monad transformers that are based on data types (e.g. `MaybeT`, `ListT`, and `WriterT`) and those that are based on functions (e.g. `ReaderT`, `StateT`, `ContT`). Lastly, I give a "before MaybeT" code and "after MaybeT code" to show why one would use MaybeT and how that changes the readability of the code.
- Fixes #82: the `Testing` folder now includes an overview of the `Gen` monad and its types and how it generates random values
- The `Testing` folder now includes a link to an explanation on `Coarbitrary` and also shows how to properly generate random `String` values.
- Various files have been repositioned or renamed
- Various headers have been renamed or removed

### Bugs Fixed
- Fixes #357

### Other Changes

- the project has been updated to the `0.13.2` PureScript release
- cover the differences/tradeoffs between global and local type class instances (FP Philo/Type Classes.md)

- Fixes #302
- Fixes #353
- Fixes #354 (See the new `Syntax/Modifying Do Ado Syntax Sugar/` folder)
- Fixes #355
- Fixes #358
- Fixes #359
- Fixes #360

## ps-0.12.x-v0.16.1

Fixes #349 - I don't think I need to write code examples for purescript-spec as their docs are already up-to-date but just aren't the correct ones referenced in their guide. See this issue for the URL to the correct docs.
Fixes #348
Fixes #347
Fixes #346
Fixes #345

Also documents a few more syntax related things due to the 0.13.0 release

## ps-0.13.x-v0.16.0

Fixes #343

So, Halogen v5 changed their API. A 'request' styled query now returns a Maybe a rather than just an a. I found that I could use AVars to "block" the business logic "thread" until the UI "thread" did what it was supposed to do. However, this seemed to be an example of an anti-pattern. So, I've decided to show a simple example of that antipattern using the ReaderT approach and then just move all the other code (including tests) outside of the src directory and into a deadcode directory. This prevents the code from being included in the compilation (which causes it to fail) but allows others to look at the code I wrote previously, how it worked, and why it failed.

I've done those changes and will be finishing up this PR most likely today if not tomorrow.

## ps-0.12.x-v0.15.1

### New Content

Fixes #339

### Updates/Fixes

Fixes #337
Fixes #333

## ps-0.12.x-v0.15.0

### New Content

Fixes #314
Fixes #271
Fixes #201

### Corrections

Fixes #312

### Changes to Project

Fixes #311
Fixes #330
Fixes #329

## ps-0.12.x-v0.14.2

Fixes #326
Fixes #325
Fixes #324
Fixes #323
Fixes #216
Fixes #192
Fixes #167
Fixes #275

## ps-0.12.x-v0.14.1

- Fixes #319
- Fixes a minor user regression introduced by #315. When the user uses --help in the ToC program, the help text would take forever to print. This bug was fixed in f-o-a-m/purescript-optparse#10 and a new release was made that included the fix: v2.0.0.

## ps-0.12.x-v0.14.0

### Breaking Changes

Fixes #315

Note: a performance-related issue (as described in f-o-a-m/purescript-optparse#6) makes the `--help` flag take forever to print out with this many arguments. Hopefully that will get fixed sooner rather than later. However, the program itself is still usable and the command-line args are still largely the same as before.

## ps-0.12.x-v0.13.0

### Breaking Changes

- Fixes #310
- Fixes #307
- Fixes #316
- Addresses part of #280 and #279
- The Projects folder will now only implement programs in the standard ReaderT and Run approaches. The layered approaches will only be done in the Random Number Game one because it's simpler.
- The 'Projects' prefix on module paths in the Projects folder were changed to their corresponding project name (Games -> RandomNumber; Projects.ToC -> ToC)

### New Content

- Fixes #309: `Hello World/Application Structure/Modern FP Architecture.md`

### Fixes

- Addresses #304 - as a temporary solution, I can do a dry run (no url checking done) via a `--skip-url-verification` flag and use a tag rather than a branch.

### Other Comments

NPM reports a "high severity" problem with `Yargs`, which only appears in the Projects folder. The `for-each-compile...` shell script that helps one update to the next release still installs this. See #315 for more info.

The ToC file now correctly links to this release's tag, so any breaking changes made on the `development` won't break links in the ToC file.

## ps-0.12.x-v0.12.1

Minor release that just adds a few more links before I start working on #307

Also updgrades to Spago 0.7.4.0

### New Content

- Fixes #306 - Design Patterns/Recursion Schemes.md
- Fixes #305 - Design Patterns/Phantom Types/What are Phantom Types.md
- Fixes #297 - Getting Started/Other Important Info.md
- Fixes #265 - Syntax/Basic Syntax/Records/Basic Syntax.purs

### Meta
- Use correct Spago command to print version in CI.

## ps-0.12.x-v0.12.0

This is a bigger release with a number of breaking changes.

As of this release, we're now using Spago for our build tool and package manager, mainly because it eases the maintenance I would otherwise have to do.

### Migrating

For things to work properly, there are 4 things you will need to do:
- install `spago`, `dhall-to-json`, and `parcel` via [these installation instructions](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/00-Getting-Started/02-Install-Guide.md#installation)
- update the `ide-purescript` Atom package to the latest one to expose the additional spago option
- configure `ide-purescript` to build projects via spago by following the instructions listed in the second 'numbered list' [here](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/00-Getting-Started/02-Install-Guide.md#setting-up-your-editor)
- run the `for-each-folder--install-deps-and-compile.sh`, which will delete the old `psc-package` and `pulp` contents and build using `spago`

#303 needed to be added after this PR to account for the newer `spago` update.

### Breaking Changes

- Fixes #264
- Fixes #255 - this was made into a top-level folder
- Fixes #254
- Fixes #252
- Fixes #251
- Fixes #250
- Fixes #249
- Fixes #248
- Fixes #175
- Resolves #194
- The pre-requisites / library overviews I do in the `Projects` folder were moved into their own folder called `Libraries`. These do not have a number ordering them as it allows me to add content in any order as I continue building new PS projects. `Projects/Libraries/`
- I broke the `CLI Options` mindmap up into separate SVG files, so that one can see all the CLI options for each program individually rather than a massive SVG file that tried to combine them into one image.
- Moved the explanation on type class dictionaries into Syntax folder that explains how they work: `Syntax/Basic Syntax/Type Classes and Newtypes/Dictionaries: How Typeclasses Work.purs`
- Cleaned up brief overview of monad transformers and Free: `Hello World/Application Structure/ReadMe.md`

### New Content

- Fixes #288: linked to Scott's "Power of Composition" video in multiple places
    - `Getting Started/Why Learn PS.md`
    - `FP Philosophical Foundations/Composition Everywhere.md`
- In multiple places, linked to Nate's video on what problem type classes solve: code reuse:
    - `Getting Started/Why Learn PS.md`
    - `FP Philosophical Foundations/Type Classes.md`
- linked to Nate's video that explains what `Free` and `Cofree` are by using trees: `Hello World/Application Structure/Free/ReadMe.md`
- Fixes #295: `Getting Started/Why Learn PS.md`
- Fixes #294: `Hello World/Application Structure/Free/ReadMe.md`
- Fixes #293: `Design Patterns/Recursion Schemes.md`
- Fixes #292: `Getting Started/Why Learn PS.md`
- Fixes #253: `Syntax/Basic Syntax/TypeClasses and Newtypes/Type Class Relationships.purs`
- Addresses some parts of #147: "The Power of Composition" video explains monads in the correct way (composing two functions together that have 2 possible outputs). I also linked to the video in that issue, which highlights how we get the type signature for `bind`: the composition of two kleisli arrows.
- Documented a Spago workflow and how it works with parcel
- Added a visual that explains more of the laws behind Algebraic Data Types: `FP Philosophical Foundations/Composition Everywhere.md`
- Added a visual that explains the idea of immutable persistent data structures better: `FP Philosophical Foundations/Data Types.md`
- Added an overview of the control flow of some useful monads (Maybe, Either, List): `Hello World/Prelude-ish/Control Flow/Useful Monads.md`
- Linked to Traversable type classes' `for` function as a temporary explanation that helps one understand it better: `Hello World/Prelude-ish/Foldable-Traversable/Traversable.md`

### Bugs Fixed

- The following bugs were fixed. It seems my TOC program's parser had a bug in it and I seemed to have missed it beforehand or had a specific structure that did not trigger the bug. I'm not too surprised by that because I didn't have any tests written for it since I was trying to push something out before refining it further. In the process, I also discovered a bug in `purescript-tree` (see bottom part of this PR for more context).

### Other changes related to this project on a "meta" level:

- This repo sometimes used the folder names "images" and "resources" to refer to a folder that stored images or .graphml files to produce diagrams. I decided to rename all of those folders to `assets` instead and adhere to that naming convention.

## ps-0.12.x-v0.11.4

A minor release that adds a number of links before I introduce breaking changes

New Content

- Fixes #289
- Fixes #285
- Fixes #276
- Fixes #274
- Fixes #273
- Fixes #272
- Fixes #267
- Fixes #266
- Fixes #149

Other changes

I documented my current workflow for making releases.

## ps-0.12.x-v0.11.3

#283: all across the project
#269: all across the project
Fix minor bug: `yargs` does not get installed when the CI or update script installs the Projects folder

## ps-0.12.x-v0.11.2

### New Content

- Closes #222: `Projects/src/11-ToC`
- Closes #259: `Getting Started/Install Guide.md`
- Closes #242: `Syntax/Basic Syntax/src/TypeClasses and Newtypes/Single Parameter.purs`

### Bug Fixes

- creating vs updating record syntax: `Syntax/Basic Syntax/src/Data and Functions/Records/Basic Syntax.purs`

### Changes / Updates

- Clarify how `newtype`s are different from `type`s and why they are useful: `Syntax/Basic Syntax/src/TypeClasses and Newtypes/Newtypes.purs`
- Warn that type class' functions/values' documentation are not included in the `purs docs` command due to a bug
- Show that type aliases can take a type parameter
- Be more explicit in explaining do notation

## ps-0.12.x-v0.11.1

### New Content

#222 - Related to this issue, but the repo now includes a table of contents for this repo. This file will likely change in the release, so do not count this file as 'safe' from breaking changes.
Resolves #262 - `Hello World/ReadMe.md`
Resolves #261 - `Hello World/ReadMe.md`
Resolves #258 - `Hello World/Application Structure/src/Modern FP Architecture.md` / `Hello World/Application Structure/src/Free/From Free to Run.md`
Resolves #256 - `Hello World/FP PHilosophical Foundations/Data Types.md`
Resolves #240 - `Getting Started/ReadMe.md`
Resolves #239 - `Getting Started/ReadMe.md` - I decided to drop the backends and instead link to the documentation repo.
Resolves #238 - `Projects/ReadMe.md`
Resolves #236 - `Ecosystem/Type Classes/External Explanations.md`
Resolves #234 - `Hello World/Application Structure/src/MTL/The ReaderT Capability Design Pattern.md`
Resolves #243 / #247 - `Build Tools/Tool Comparisons/Dependency Managers.md`

### Changes

Resolves #257 - Replaced previous video with this one: `Syntax/Type Level Programming/src/Basic Syntax/Defining Functions/ReadMe.md`

## ps-0.12.x-v0.11.0

### Breaking Changes

- Fixes #218
- Fixes #231

## ps-0.12.x-v0.10.3

### Minor Breaking Changes

- Fixes #220. I doubt anyone is linking to this anyway as this has been old for a while. Also section headers don't count as major breaking changes.

### New

- Resolves #211 - This was better explained in `Getting Started/ReadMe.md` and in `Hello World/Philosophical Foundations of FP/Why is Learning FP So Hard.dm`
- Resolves #206: `Syntax/Basic Syntax/src/Type Classes and Newtypes/Functional Dependencies.purs`
- Resolves #212: `Hello World/Debugging/src/General Debugging.md`
- Resolves #219: `Hello World/ReadMe.md`
- Resolves #189: `Design Patterns/Recursion Schemes.md`
- Resolves #188: `Ecosystem/Performance-Related/ReadMe.md`
- Resolves #217: `Ecosystem/Type Classes/ReadMe.md`

## ps-0.12.x-v0.10.2

### New Content

- Adds more content related to #175: `Getting Started/ReadMe.md`
- Fixes #197: `Getting Started/ReadMe.md`
- Added module naming conventions (relates to #173)
- Added visual diagram showing the difference between pure/impure functions: `Hello World/FP Philosophical Fundations/Pure vs Impure Functions.md`
- Added visual diagram showing the application structure (big idea) of an FP program: `Hello World/FP Philosophical FOundations/FP - The Big Picture.md`
- Clarified the name of a concept, `referential transparency`: `Hello World/FP Philosophical Fundations/Pure vs Impure Functions.md`
- Link to another 'PS migration story': `Getting Started/ReadMe.md`
- Link to article supporting building a website before building an app: `Getting Started/ReadMe.md`

### Bugs fixed

- #205: `Hello World/Projects/benchmark/Random Number/`

### Changes

- List `spacchetti` and `dhall-to-json` as an optional installation that isn't used until later (`Hello World/Benchmarking`): `Getting Started/Install Guide.md`
- Inform reader of `for-each-folder--install-deps-and-compile.sh` file and its purpose for updating to next release: `Getting Started/Install Guide.md`
- Fixes #208: `Getting Started/Other Important Info.md`

### Project Changes

- #46: `ReadMe.md`
- Clarify that `spacchetti` needs to be installed for the `for-each-folder--install-deps-and-compile.sh` file

## ps-0.12.x-v0.10.1

Minor release that just adds a number of links I've been meaning to add for a while

### New Content

#195 - `Design Patterns/Simulating Constraint Kinds.md`
#193 - `Ecosystem/Type Classes/ReadMe.md`
#187 - `Hello World/Prelude-ish/Prelude/Objecty - Show and Equal to Bounded.md`
#186 - `Syntax/Basic Syntax/src/Data and Functions/Some Keywords and their Syntax/Keywords - Where and Let In.purs`
#185 - `Ecosystem/Type Classes/External Explanations.md`
#182 - `Ecosystem/Type Classes/Utility-Functions.md`
#177 - `Hello World/Testing/test/ReadMe.md`
#176 - `Design Patterns/Optics.md`
#173 - `Hello World/Conclusion.md`
#172 - `Build Tools/Continuous Integration.md`
#171 - `Hello World/Debugging/src/Console-Based Debugging.md`
#170 - `Design Patterns/A Better TODO.md`
#168 - `Design Patterns/Partial Functions/Via Default Values.md`

## ps-0.12.x-v0.10.0

Please use the `for-each-folder--install-deps-and-compile.sh` file to easily update your version of this learning repo for this new release.

### Changes related to #133

- Introduce the Application Structure folder with a much better overview of what we're doing in this folder and why we do things that way: `Hello World/Application Structure/ReadMe.md`
- Moved explanation of "effects" into own separate file before explaining MTL or Free. As a result, the `MTL` folder was bumped from `01` to `02`. Likewise, Free was bumped from `02` to `03`: `Hello World/Application Structure/src/Monads and Effects.md`
- Refered to another post for criteria when evaluating various ways of modeling effects: `Hello World/Application Structure/src/Monads and Effects.md`

#### MTL Changes

- Reworked the explanation for `StateT` to show more clearly why we got to the definition we use for `MonadState` and not something else: `Hello World/Application Structure/src/MTL/Implementing a MonadTransformer/*`
- Provided much better explanation/summary for Monad Transformers, how they work, their basic concept, and the naming conventions used in their names: `Hello World/Application Structure/src/MTL/Implementing a MonadTransformer/Monad Transformers Summarized.md`
- Changed explanation that `Monad[Word]T` is the "sole" implementation for `MonadWord` to "default" implementation.
- Explained some of the drawbacks of using an Monad Transformer stack and recommended the ReaderT design pattern instead: `Hello World/Application Structure/src/MTL/Drawbacks of MTL.md` and `Hello World/Application Structure/src/MTL/The ReaderT Capability Design Pattern.md`

#### Free Changes

- Converted the example `Box` "free" monad of kind, `Type`, to `Identity`: `Hello World/Application Structure/src/Free/What is the Free Monad/*`
- When explaining the "Data Types a la Carte" paper, I removed all instances/references to `Variant`/`VariantF` and instead put those in a new folder ("From Free to Run") that follows the "Why Use the Free Monad" folder. This reduces the number of concepts that are learned and hopefully makes it easier to understand.
- I made the "Writing the Show Function" file optional reading. Since I couldn't figure out how to make the code compile and yet still understand how Free works, I didn't think this problem was worth resolving: `Hello World/Application Structure/src/Free/Why Use the Free Monad/Optional Read - Writing the Show Function.md`
- Added working code that solves the same Expression Problem as the above paper (only for the evaluate function) using `Free`: `Hello World/Application Structure/src/Free/Why Use the Free Monad/From Expression to Free/*`
- Emphasized that the "state monad is not a free monad" problem is what leads us to defining custom languages that model effects: `Hello World/Application Structure/src/Free/Why Use the Free Monad/Defining Moduler Monads.md`
- Explained the concept of "layered compilers" separately from the "modular monads" idea: `Hello World/Application Structure/src/Free/Why Use the Free Monad/Layered Compilers.md`

### Games Top-Level Folder

- Renamed the folder from `Games` to `Projects` in case there are non-game programs I wish to later create
- Distinguished between "standard" and "layered compiler" approach to structuring the "Random Number Game"'s code: `Hello World/Projects/ReadMe.md`
- Overviewed `Node.ReadLine` and `Halogen` separately before using them in any projects: `Hello World/Projects/Node-and-Halogen/*`
- Explain the thought process behind designing and testing our random number game while removing any "onion architecture" notions that were incorrect: `Hello World/Projects/src/Random Number/Design Thought Process.md` and ``Hello World/Projects/test/Random Number/Test Thought Process.md`
- Implemented the random number game's production and test code for most of the approaches: `Hello World/Projects/src/Random Number/*` and `Hello World/Projects/test/Random Number/*`
- Updated run/test instructions for each approach: `Hello World/Projects/src/Random Number/ReadMe.md`
- Removed the `Onion-Architecture.svg` from being rendered in a Markdown file. This still exists in the repo, but might be removed in a future release.
- Included a **naive** benchmark and its results as a photo showing how the different approaches compare in terms of performance: `Hello World/Projects/benchmark/*` / `Hello World/Projects/benchmark-results/*`

### Other New Content

- Explained how to use 'eta expansion' to solve some compiler problems (i.e. purescript/purescript#950): `Syntax/Basic Syntax/src/Data and Functions/Abbreviated Function Body.purs`
- Explain that CT-based type classes have Duals and what that means: `Hello World/FP Philosophical Foundations/Type Classes.md`
- #165 - Delegated explanation of `Semigroup`...`Field` (the numeric type classes) to hdgarrood's much better/clearer explanation: `Hello World/Prelude-ish/Prelude/Appendable - Semigroup to Monoid.md`
- Include `MonadGen` in the list of other monad transformers not overviewed in MTL folder: `Hello World/Application Structure/src/MTL/Other Monad Transformers.md`
- Forewarn reader about the potential "notification spam" this repo may produce: `ReadMe.md`
- #200: `ReadMe.md`

### Other Breaking Changes

- #166 - Deleted Location-TBD.md file
- Reordered sections in Type Classes file
- In `Hello World/Prelude-ish/Prelude/Control Flow/` I changed the numerical order, so that something that started at `02` now starts at `01`.
- In `Hello World/Debugging/ReadMe.md`, I updated the content to reflect that folder's purpose
- #155 & #181

### Other Fixes/Corrections

- Rename "InterfaceLikeType" type name to "DataType" since type classes act more like interfaces: `Syntax/Basic Syntax/src/Data and Functions/Keyword Data.purs`
- Fix example of what multiple `forall` expressions in the same type signature mean: `Syntax/Basic Syntax/src/Data and Functions/Keyword Forall.purs`
- Provide better example that shows why Purescript does not currently support "backtracking" when unifying types/kinds: `Syntax/Type-Level Programming Syntax/src/Basic Syntax/Defining Functions/ReadMe.md`
- Provide better explanation for how FP programmers simulate loops via recursive functions: `Hello World/FP Philosophical Foundations/Looping via Recursion.md`
- #191 - Fix the explanation of `Prim.TypeError (Beside)` kind: `Hello World/Debugging/src/Custom Type Errors/Functions.purs`
- #180 - Updated the table and included note about the Boolean kind that was recently added to Purescript but not yet released: `Hello World/Type-Level Programming/src/Type-Level Primitives.md`
- Link to more recent Halogen flowchart: `Hello World/Projects/Node and Halogen/Halogen.md`

### Miscellaneous

- Changed some link's text to be more SEO-friendly than 'click here'
- Fix markdown rendering issues
- Upgrade psc-package package sets to `0.12.1`

## ps-0.12.x-v0.9.8

### New Content

- #146: `Ecosystem/Data Structures/All Others.md#Finger Tree`
- #159: `Hello World/Philosophical Foundations/Looping via Recursion.md`

#### Added a `location TBD` file

Just so that these links are included in the repo, even if they aren't organized/categorized yet. Moving these files will not be considered a 'breaking change'.
- #126, #129, #149, #155: `05-Location-TBD.md`

### Fixes

- #161
- #160
- #162
- #163
- Other typos

## ps-0.12.x-v0.9.7

### New Content

- #156: `Getting Started/Other Important Info.md`

In `Hello World/Debugging`:
- #153:
- #150

### Fixes

In `Hello World/Philosophical Foundations/Type Classes`:
- Refined definition of type-classes as 2-3 things (function/value type signatures + laws (+ derived functions))
- Fix terminology: use **have** instead of **is** when saying `a type **has** an instance of some type class` since one type can have multiple instances or none at all.
- Explain that type classes implementations are not hierarchial, but rather must be satisfied ultimately. For example, `List` can implement an instance of `Functor` by using its instance of `Monad`, which requires the type to have an instance of `Functor` via `liftM1`
- Add more explanation behind the "lawless typeclasses" debate

In `Ecosystem`:
- Fix some markdown table rendering issues in `Ecosystem/Data Structures`
- Fixed Profunctor definition (first type is Contravariant, not Covariant)

## ps-0.12.x-v0.9.6

### New Content

#106
#141
#136
#132

### Fixes

- Related to #134: The Benchmarking folder was added to the `for-each-folder--install-deps-and-compile.sh` file using a "spacchetti + dhall"-based approach for adding benchotron.

## ps-0.12.x-v0.9.5

Release specifically for jordanmartinez/purescript-jordans-reference#134; also fixes a minor bug where a dependency was not included due to moving code at one point.

## ps-0.12.x-v0.9.4

### New Content

jordanmartinez/purescript-jordans-reference#125 & jordanmartinez/purescript-jordans-reference#114 - Gave a quick intro to Category Theory and why type classes are used to model them (Hello World/FP Philosophical Foundations/Type Classes.md)

Explained that type can be used to create clearer UML diagrams.

jordanmartinez/purescript-jordans-reference#128
jordanmartinez/purescript-jordans-reference#127
jordanmartinez/purescript-jordans-reference#124
jordanmartinez/purescript-jordans-reference#123
jordanmartinez/purescript-jordans-reference#122
jordanmartinez/purescript-jordans-reference#121
jordanmartinez/purescript-jordans-reference#120
jordanmartinez/purescript-jordans-reference#119
jordanmartinez/purescript-jordans-reference#118
jordanmartinez/purescript-jordans-reference#117
jordanmartinez/purescript-jordans-reference#115
jordanmartinez/purescript-jordans-reference#113

### Fixes

jordanmartinez/purescript-jordans-reference#121

## ps-0.12.x-v0.9.3

### New Content

- jordanmartinez/purescript-jordans-reference#111 - Link to unofficial PDF version of all Bortosz Mileski's blog posts: `Ecosystem/TypeClasses/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#107 - Link to Hard Parts of Open Source: `Getting Started/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#110 - Link to Purescript's Real World App: `Getting Started/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#109 - Link to `pointed-list` as real-world example of Zipper for List: `Design Patterns/Zipper.md`

## ps-0.12.x-v0.9.2

### New Content

- jordanmartinez/purescript-jordans-reference#2 - Link to explanation of Orphan Instances using String-Warning syntax: `Syntax/Basic Syntax/TypeClasses and Newtypes/Single Parameter.purs`
- jordanmartinez/purescript-jordans-reference#101 - Link to and document "Pattern Matching Guard + Case _ of" syntax compiler error: `Syntax/Basic Syntax/Data and Functions/Some Keywords and Their Syntax/Keywords--Case Expression of.purs`
- Provide real-world command for running a benchmark by using pulps `--include` flag: `Hello World/Benchmarking/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#103 - Link to Free Applicatives paper: `Hello World/Application Structure/Free/What is the Free Monad/What is and is not the Free Monad.md`
- jordanmartinez/purescript-jordans-reference#97 - Explain what covariant/contravariant functors are: `Design Patterns/Variance of Functors.md`
- Explain the various Functors: Covariant, Contravariant, Invariant, Bifunctor, and Profunctor: `Ecosystem/Type Classes/Functors.md`
- jordanmartinez/purescript-jordans-reference#9 - Link to higher-kinded data types explanation: `Ecosystem/Data Types/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#99 - Link to Comonad type class explanation: `Ecosystem/Type Classes/External-Explanation.md`


### Fixes/Corrections

- In file: `Hello World/Application Structure/src/MTL/ReadMe.md`
    - Explain "effect" as the "types of computations" one does:
    - Explain "monad transformers" as a monad that "transforms" another monad by augmenting it with additional powers

## ps-0.12.x-v0.9.1

### New Content

- Link to my tutorial on Halogen with a lower learning curve than standard tutorial; also link to my flowchart that shows how the code even works: `Hello World/Games/src/Random Number/Free/Halogen`
- Browser-based infrastructure implementation via Halogen for playing random number game. NOTE: this UI is utterly horrible and simplistic, but.... it works: `Hello World/Games/src/Random Number/Free/Halogen` (Free) and `Hello World/Games/src/Random Number/Run/Halogen` (Run)

### Corrections/Fixes

- This "monad interpretation chain," `Run (api :: API_Lang) ~> Run (aff :: AFF) ~> Aff` does not need the intermediate `Run (aff :: Aff)` monad translation
- `map` can also be described as lifting a function into some context
- use correct type class (Applicative, not Apply) when explaining what Applicative is

## ps-0.12.x-v0.9.0

### Breaking Changes

- Split `00-Comments-and-Documentation.purs` syntax file into two separate files and added an instruction for how to build the docs to see what the end result looks like
- Reorder the two `Hello World` folders: `Application Structure` and `Type-Level Programming`, so that the latter comes before the former since the former uses TLP.
- Deleted unused code from previous work: `Hello World/Games/src/Helper Code/Node/ReadLine/CleanerInterface.purs`
- Moved `Conclusion.md` from `Hello World/Games` into `Hello World` folder.
- Converted `Design Patterns/Generic Algebraic Data Types.purs` to `Design Patterns/GADTs.md` and link to better explanations/papers on the topic
- Converted `Design Patterns/Smart Constructors.purs` to markdown and explain it using two examples
- Reordered / assigned an order to most of the files in the `Design Pattern` folder

### New Content

- Added "OO Design Patterns in FP Languages" article: `Getting Started/ReadMe.md`
- Use meta-language to document what `instance head` and `instance context` means: `Syntax/Basic Syntax/src/TypeClasses and Newtypes/Constraining-Types-Using-Typeclasses.purs`
- Explain unification and "backtracking" more clearly and link to various works related to it: `Syntax/Type-Level Programming Syntax/src/Basic Syntax/Defining Functions/ReadMe.md`
- Add a note about `when`/`unless` being strict and how `purescript-call-by-name` can make it lazy: `Hello World/Prelude-ish/Control-Flow/Applicative.md`
- Better explain the pattern to follow when translating one Run-based language to another Run-based language: `Hello World/Games/src/Random Number/Run/ReadMe.md`
- Add link to YouTube channel: LamdaConf: `Hello World/ReadMe
- Provide additional examples of Phantom Types: `Design Patterns/Phantom Types`
- Summarize the Data Validation via Applicative pattern
- Add a reference to the `Zipper` and link to other explanations on it: `Design Patterns/Zipper.md`
- Add a link to Functional Pearls list: `Design Patterns/ReadMe.md`
- Add a link to "What's new in PDFS since Okasaki?" question/answer: `Ecosystem/Data Types/ReadMe.md`
- Inline Generics-Rep issue explanation into project: `Ecosystem/Type Classes/ReadMe.md`
- Add link to Bortosz Mileski's blogs/videos on category theory: `Ecosystem/Type Classes/ReadMe.md`

### Fixes / Changes

- Moved Row syntax explanation into more appropriate parts in Record folder: `Syntax/Basic Syntax/src/Data and Functions/Records/`
- Fix code in Phantom Types file

## ps-0.12.x-v0.8.3

### New Content

- Link to Hallgren's Fun with Functional Dependencies paper: `Syntax/Type-Level Programming Syntax/src/An Overview of Terms and Concepts.md`
- Under this file: `Syntax/Type-Level Programming Syntax/src/Basic Syntax/Defining Functions.md`

    - Explain that type-level expressions are "computed" by finding a type via unification
    - Loosen type-level function analogy by showing how it can "return" two types instead of one
    - Link to Prolog tutorials
    - Cite Learn Prolog Now so I can adapt their rules for our context
- Explain the limitations/issues of type-level programming: `Hello World/Type-Level Programming/ReadMe.md`
- Under this folder: `Hello World/Type-Level Programming/src/
    - Explain how to read/write type-level functions in practical usage
    - Explain some Row-related tips
    - Provide working examples of Symbol- / Row-based type-level programming
    - Overview the ecosystem of TLP and refer reader to those libraries to learn more

### Corrections

- Explain functional dependencies much better: `Syntax/Basic Syntax/src/TypeClasses and Newtypes/Functional Dependences.purs`
- Add license info to pure/impure functions comparison table: `Hello World/FP Philosophical Foundations/Pure vs Impure Functions.md`
- Fix project's ReadMe to show more of the innards of some of its folders.

## ps-0.12.0-v0.8.2

### New Content

- Start to explain why one should learn Purescript in the first place (`Getting Started/ReadMe.md`)
- jordanmartinez/purescript-jordans-reference#91: Document Row syntax better: `Syntax/Basic Syntax/src/Data and Functions/Records/Basic Syntax.purs`
- Explain types and kinds better by comparing them: `Syntax/Type-Level-Programming-Syntax/src/An Overview of Terms and Concepts.md`
- jordanmartinez/purescript-jordans-reference#82 (partial): Add link to MonadGen in `Hello World/Testing/test/QuickCheck and Laws/MonadGen.md`
- jordanmartinez/purescript-jordans-reference#86: Add link to 7 patterns for property testing: `Hello World/Testing/test/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#38: Add link to the book that explains Lenses using Purescript: `Hello World/Games/Conclusion.md`
- jordanmartinez/purescript-jordans-reference#89: Add link to 'what I wish I knew when learning Haskell': `Hello World/ReadMe.md`
- jordanmartinez/purescript-jordans-reference#85: Add link to "Keep your Types Small" and update code to show how it works: `Design Patterns/Partial Functions/`

### Corrections

- Fix misunderstanding about functional dependencies in type-level functions. Explain them using equations and "solve for X" idea: `Syntax/Type-Level-Programming-Syntax/src/Basic Syntax/Defining Functions`

## ps-0.12.x-v0.8.1

Added a working example for how to write a QuickCheck-based test for the game, which tests the API, Domain, and Core levels of our code, and explained how we got there.

## ps-0.12.x-v0.8.0

### Breaking Changes

- Renamed `Prelude` to `Prelude-ish`
- Moved Mutable State folder into Hello World and Effects folder #79
- Renamed Type Directed Search to more general "General Debugging"

### New Content

#### Major

- Wrote a game according to the Onion Architecture via a `Free`-based implementation and a `Run`-based implementation with the `Run` one showing the advantages it has over the `Free` one.
- Wrote a `Gen` for the Random Number game. Unfortunately, I was not able to use that to create a QuickCheck test to test my game logic. I need monadic effects and I'm not sure yet how to do that. This may be something that was not yet ported over from the Haskell library.
- Improve "meta-language" example of how to write a `Free`-based DSL using data types.

#### Minor

- Document how to export all entities in the current module #80
- Explain how type classes work in practice via "dictionaries": #81
- Write small summary of basic FP data types: Maybe, Either, Tuple, List
- Added explanation of the type class, `Foldable` #75
- Added incomplete "not very helpful" explanation on `Traversable` #75
- Link to video that shows FP-based explanation of Onion Architecture
- Link to article "Introducing Haskell to a Company" #83
- Link to video that covers `Aff` more deeply than I do

### Fixes / Corrections

- Prior usage of "extensible effects" were really "composable effects". Also, I believe my understanding of what "effects" ultimately means is somewhat flawed (as discovered on the Slack channel)
- Prior explanation of "forgetful functors" were wrong (I googled it and, while I don't get what they do entirely, I do understand that my previous explanation was incorrect). I removed this entirely.
- Clarified that `VariantF`-based code for solving the paper's Expression Problem has not been tested (since that's not what we'll be using anyways...)
- Include references to other PS libraries covered in the `Free` folder.
- Clarify that `Free` is slower than `MTL` in Haskell, but not necessarily in Purescript
- Explain the Purescript's Free monad is the fully optimized version based on Oleg's work
- Markdown formatting issues in some tables
- Syntax not highlighted in some code blocks
- Code cleanup in some areas

## ps-0.12.x-v0.7.2

### Release Notes

- While I was writing the first few parts of my explanation of the "Data Types a la Carte", I could not execute the code I wrote. So, some of the code may be incorrect if executed, but is correct in getting the idea across.
- The `show` function from the paper was not implemented in later solutions to the Expression Problem because I couldn't figure it out at first, moved on to other explanations, and then forgot about it.

### New Content

#### Major

- Explain what "free 'type class'" data structures are using List and Monoid
- Explain how the `Free` monad works and how its performance is improved via a summary of the "reflection without remorse" paper
- Explain the "Data Types a la Carte" paper in Purescript
    - Explain what the Expression Problem is and how to solve it via a simple example
    - Solve a harder example from the paper
    - Solve the same problem using Purescript libraries: `purescript-variant` and `purescript-run`

#### Minor

- Added tip for how to get the type of an expression from the compiler
- Added tip for how to get the type of a function from the compiler
- Added link to MonadRec in MTL folder
- Added link to a full stack FP solution via Haskell backend and Purescript frontend

### Other

- Cleaned up the "Design Patterns/Smart Constructors.md" explanation

## ps-0.12.x-v0.7.1

### New Content

- Explain how to combine multiple monad transformers into one final program via `MonadTrans` (though more things could be explained, this finishes #58)
- Add a word of thanks to project for his code (helped me understand how to use a monad transformer stack)

### Fixes

- Correct misunderstanding: a stack of monad transformers is not a stack of `monad1 ~> monad2`
- One would need to write `pulp --psc-package run -m Module.Example.MonadState` to run the examples. I removed the `Example` submodule since it was boilerplate.

## ps-0.12.x-v0.7.0

### Breaking Changes

- Prelude Syntax folder's order was updated to account for new Discard explanation
- Philosophical Foundations for FP file was split into multiple files of a folder with a similar name
- Updated Console-Lessons (now called Debugging) folder's contents order
- In-lined `MonadEffect` explanation into `Using Two Monads at Once` file

#### Relocations

- Renamed `Console-Lessons/Debug-Trace/Monad Natural Transformers` to `Using Two Monads at Once` to remove monad transformer connotation (I want to introduce the concept, but not the name yet)
- "Reading nested binds using Maybe" section moved to Prelude Syntax since that's a better place for it
- Moved Prelude's overview of type classes into Philosophical Foundations folder
- Move brief `Effect, Eff, and Aff` explanation into `Hello World/Hello World and Effects` folder
- Moved `Hello World/Console-based Lessons/Error Handling` to `Design Patterns/Partial Functions`
- Renamed `Console-Lessons` to `Debugging`
- Renamed `Computing With Monads` to `MTL` and moved it into `Hello World/Application Structure` folder
- Moved `Hello World/Console-Lessons/Mutable State` into `Hello World/Application Structure/OO Code in FP Syntax` folder
- Moved remaining `Hello World/Console-Lessons/` (Node ReadLine API and code that were used in console-based lessons) into `Hello World/Games/`

### New Content

- Explain Discard type class and updated syntax examples
- Explain FP concepts: graph reduction, thunking
- Explain why learning FP is so hard
- Added a small explanation on using Type-Directed Search to debug type errors / guide one when having problems

### Fixes

- Correct misunderstanding about omitting the `binding <-` syntax in do notation (relates to Discard)
- Correct Javascript examples of looping

## ps-0.12.x-v0.6.2

Minor release

There will be another major release immediately after this one. This just adds the last stuff I was working on before introducing those changes.

New Content:
- Explain MonadThrow/Error and MonadCont with simple examples
- Add Modue Linker browser extension to getting started file
- Add missing MonadCont link in the table overview various monad transformers

## ps-0.12.x-v0.6.1

- Correct mistake: Identity is a placeholder for a computational monad
- Re-add Reading Do Notation section for StateT
- Correct explanation of MonadWriter's `censor` derived function
- Clarify what the output values are via comments

## ps-0.12.x-v0.6.0

### Breaking Changes

#### Minor

- Link to Pursuit's help page on searching rather than writing my own tips to it (Getting Started / Other Important Info.md)
- Moved and updated Basic Data Types file into Ecosystem (Hello World / Basic Data Types)

### New Content

#### Major

- Explain Monad Transformers (MonadState, MonadTell/Writer, MonadAsk/Reader; others still a WIP) in a very clear and detailed manner (Hello World / 0x-Computing-with-Monads)
- Overviewed a number of data types in the ecosystem and their usage (WIP) (Ecosystem  /Data Types)

#### Minor

- Link to help page for authors when publishing (Build Tools / New Project From Start To Finish.md)
- Linked to Front-End library comparison article (Thermite vs Pux vs Halogen)

### Fixes

- Use faster way to get Benchmarking folder up and running by not using `psc-pacakge verify` for a package set I've already verified (Hello World / Benchmarking / ReadMe.md)
- Fixed a few typos, spelling mistakes, rewrite some things to be clearer

## ps-0.12.x-v0.5.0

### Breaking Changes

- `Syntax/Foreign-Function-Syntax/src/FFI.purs` (and its Javascript counterpart) was renamed to `Same-File-Name.purs` to better adhere to the syntax folder's meta-language principle
- Renamed `Spec` folder to `Unit` folder (future compatibility: in case I want to document `test-unit` later (Hello World/Testing/src/Spec `->` Hello World/Testing/src/Spec)

### New Content

#### Major

- Document how to create your own local custom package set using the default package set as a base (Build-Tools/Create-Local-Custom-Package-Set.md)
- Document the difference between Unit Testing and Property Testing (Hello World/Testing/test/ReadMe)
- Document QuickCheck and QuickCheck-Laws libraries' syntax and usage (Hello World/Testing/test/QuickCheck)
- Compare various Purescript property-based testing libraries (Hello World/Testing/test/Property-Testing-Libraries-Comparison.md)
- Document benchmarking via `benchotron` (Hello World/Benchmarking/)

#### Minor

- Add instructions for configuring Atom's `ide-purescript` package to use psc-package as a dependency manager (Getting-Started/Install-Guide.md)
- Document Pursuit tips and a trick I found for finding all submodules of a module prefix (Build-Tools/Other-Important-Info.md)
- Link to alternate backends and link to the in-development C backend (Syntax/FFI/Readme)
- Include `test-unit` in list of unit testing Purescript libraries (Hello World/Testing/test/Unit/ReadMe)

### Bug / Typo Fixes

- Build-Tools/Tool-Comparisons/Dependency-Managers.md
