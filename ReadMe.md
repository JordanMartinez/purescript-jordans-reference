# Purescript-Jordans-Reference

This repo is my way of using the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to learn Purescript and its ecosystem.

All code uses PureScript `0.13.0`

Below is a shorter table of contents. See [Table of Contents.md](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/table-of-contents.md) for a more detailed version.

- 00-Getting-Started
    - Why learn/use PureScript?
    - How to install Purscript & set up an editor (using Atom)
    - An overview of the REPL
    - Other important info.
- 01-Philosophical Foundations - understand the core ideas that guide FP programmers and the "big idea" behind it all
    - Composition
    - Types & Type Classes
    - Pure & Impure Functions
    - Some problems FP programmers face and workarounds for them
- 02-Build-Tools - how to use the tools in the ecosystem to manage dependencies, compile source code, and build projects
    - Overview of the dependency managers
    - Overview of various tools' CLI arguments in a mindmap format
    - Typical project workflows
- 11-Syntax - Purescript's syntax explained using meta-language and verified by the compiler
    - Basic Syntax
    - Foreign Function Interface Syntax
    - Type-Level Programming Syntax
    - Module syntax
- 21-Hello-World - everything you need to know to write, structure, test, and benchmark a Purescript program
    - Prelude + Basic data structures
    - Hello World & Effects
    - Debugging
    - Testing
    - Benchmarking
    - Type-Level Programming
    - Application structure
- 22-Projects - working programs written in an FP style with helpful comments and overviews of the libraries they use
    - Random Number Game - a game that runs on the console and in the browser using the same "business logic"
    - Table of Contents Generator - a program that generates a table of contents for a GitHub repository.
- 31-Design Patterns - (WIP) commonly-used patterns to solve problems in FP languages
- 41-Ecosystem - (WIP) a better overview of the libraries in Purescript (categorized by tags)

The following labels give insight into this project's development:
- [the 'Roadmap' label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3ARoadmap): a deeper understanding of this project's current direction/goals.
- [the 'Meta' label](https://github.com/JordanMartinez/purescript-jordans-reference/labels/Meta): issues related to the project as a whole.
- [the 'Release-PR' label](https://github.com/JordanMartinez/purescript-jordans-reference/pulls?utf8=%E2%9C%93&q=is%3Apr+label%3ARelease-PR+): the changelog of the code

**Note: You are advised to watch this repo for releases only. Sometimes, this repo will produce a lot of notifications due to opening/closing issues/PRs and me adding additional thoughts/comments to things. This can star to feel like notification spam.**

## License

Unless stated otherwise in a specific folder or file, this project is licensed under the `Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license`: [(Human-readable version)](https://creativecommons.org/licenses/by-nc-sa/4.0/), [(Actual License)](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a>

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- Clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- A link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- Corrections for any mistakes I've made
- Improvements to anything I've written thus far

### Learning Purescript Using This Project

- Git clone this repo
- Use these rules to read through the folders' contents in the correct order:
    - **Read a folder's "ReadMe.md" file first (if it exists).** It may provide additional info for how to read a folder's contents.
    - **Read a folder's files or subfolders in numerical order.** For example, read things in the order they appear below:
        - 00-Getting-Started/ReadMe.md
        - 00-Getting-Started/01-Install-Guide.md
        - 00-Getting-Started/... (the rest of the folder's contents)
        - 01-Build-Tools/... (the folder's contents)
        - 11-Syntax/ReadMe.md
        - 11-Syntax/01-Basic-Syntax/src/00-Comments-and-Documentation.purs
        - 11-Syntax/01-Basic-Syntax/src/01-Preliminary-Concepts/01-Value-Function-Data-Syntax.purs
        - 11-Syntax/01-Basic-Syntax/src/01-Preliminary-Concepts/02-Explainng-Kinds.md
        - 11-Syntax/01-Basic-Syntax/src/01-Preliminary-Concepts/03-The-Prim-Module.purs
        - 11-Syntax/01-Basic-Syntax/src/02-Data-and-Functions/... (the rest of the folder's content)
- Compile the code where possible, either before or after you experiment

## Naming Conventions Used In This Repo

### Numbering System

When you see this number system:
```
01-File-Name.md
02-Folder-Name/
03-File-Name2.md
11-File-Name.md
```
You should understand it like so:
```
[major theme/idea][minor concept/point]
```
Each major theme will almost always have 1..9 minor concepts/points. Thus, you will sometimes not see a `10-file-name.md` file:
```
09-first-major-theme--file-9.md
-- 10-file-name is intentionally missing here
11-second-major-theme--file-1.md
```

In situations, where 9 files were not enough, I converted a file into a folder and each file in that folder further explains it.

### An 'x' in a File/Folder Name

If a file or folder name has `x` in the numerical part of its name (e.g. `0x-File-or-Folder-Name`, `9x-File-or-Folder-Name`), it means I am still deciding where it should appear in the numerical order (and it is likely still a work in progress).

### Referring to Files/Folders in this repo

Lastly, when referring to folders/files, we'll omit the numerical ordering (since the final order is still being determined). So, rather than `00-Getting-Started`, you'll see `Getting Started` folder. Rather than `00-Getting-Started/01-Install-Guide.md`, you'll see `Getting-Started/Install-Guide.md`

## Versioning Policy

See this section to help you understand what a new release means

### Principles

- **Provide "stable" versions...**:
    - Readers of a given version should be able to read and bookmark files without worrying about those files/links breaking due to changes in its name (via renaming/reordering files, headers in files, etc.)
    - Older versions should be available via `git tag`.
- **...without restricting developer creativity**:
    - I should be able to continue writing new content and re-ordering things without concern
- **Load the latest release:**
    - This repo should show the latest release version of this project, not the one on which I'm working. In other words, the default branch should coincide with the last release.
- **Lessen maintenance as much as possible:**
    - There should only be two branches, `latestRelease` and `development` since a branch name like `master` is overloaded with connotations. Those who want to read older versions can checkout a tag.
    - I currently will not hyperlink to other files within this project until either a `1.0.0` release is made or I find a way to automate that.
- **Indicate PS version:**
    - As Purescript continues to evolve, the release should use a prefix indicating which major PS version for which this library is up-to-date.

### Release Syntax and Explanation

`ps-[purescript's major release]-v[Major].[Minor].[Patch]` where
- purescript's major release means
    - Normally, this would be `1.x.x`, but we don't yet have a `1.0` release yet. Thus, it is currently `0.12.x`
    - `x` is a placeholder for the latest minor/patch release.
- major change means
    - a file/folder name has changed, so that bookmarks or links to that file/folder are now broken
    - files/folders have been modified, so that one is recommended to re-read the modified parts
- minor change means
    - a file's contents have been modified/updated to such a degree that one is recommended to re-read the modified parts- Read through these links about learning:
    - a file's header name has changed, so that bookmarks or links to that header/section are now broken
- patch means
    - additional files/folders have been added without breaking links
    - a file's contents have been modified/updated to a minor degree that one could re-read the modified parts but is not likely to benefit much from it.
    - a file's contents have been slightly updated (typos, markdown rendering issues, etc.)
