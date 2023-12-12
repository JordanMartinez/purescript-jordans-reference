# Purescript: Jordan's Reference

This repo is my way of using the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to learn Purescript and its ecosystem.

All code uses PureScript `0.15.13`

To learn PureScript using this project:
1. Git clone this repo
2. [Bookmark and read through this repo online](https://jordanmartinez.github.io/purescript-jordans-reference-site/)
3. Compile the code locally where possible, follow along, and experiment

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- Clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- A link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- Corrections for any mistakes I've made
- Improvements to anything I've written thus far

## Project Labels

The following labels give insight into this project's development:
- [the 'Roadmap' label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3ARoadmap): a deeper understanding of this project's current direction/goals.
- [the 'Meta' label](https://github.com/JordanMartinez/purescript-jordans-reference/labels/Meta): issues related to the project as a whole.
- [the 'Release-PR' label](https://github.com/JordanMartinez/purescript-jordans-reference/pulls?utf8=%E2%9C%93&q=is%3Apr+label%3ARelease-PR+): the changelog of the code
- [the `Bug` label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

**Note: You are advised to watch this repo for releases only. Sometimes, this repo will produce a lot of notifications due to opening/closing issues/PRs and me adding additional thoughts/comments to things. This can star to feel like notification spam.**

## License

Unless stated otherwise in a specific folder or file, this project is licensed under the `Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license`: [(Human-readable version)](https://creativecommons.org/licenses/by-nc-sa/4.0/), [(Actual License)](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a>

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
