# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created. These have been gathered into the following folders

- 00-Getting-Started - how to install Purscript, set up an editor (using Atom), and get familiar with the REPL.
- 01-Build-Tools - how to use the tools in the ecosystem to manage dependencies, compile source code, and build projects
- 11-Syntax - how to use syntax to write code in Purescript (PS versions: `0.12.0`)
- 21-Hello-World - everything you need to know (Monad explanation using pictures included) in how to write your first "Hello World" program (and actually understand what it's doing)
- 31-Design Patterns - commonly-used patterns to solve problems in FP languages
- 41-Ecosystem - a better overview of the libraries in Purescript (categorized by tags)

See [issues marked with the 'Roadmap' label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3ARoadmap) for a deeper understanding of this project's current direction/goals.

## License

Unless stated otherwise in a specific folder or file, this project is licensed under the `Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license`: [(Human-readable version)](https://creativecommons.org/licenses/by-nc-sa/4.0/), [(Actual License)](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- Clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- A link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- Corrections for any mistakes I've made
- Improvements to anything I've written thus far

**I have written an ISSUE_TEMPLATE file. When you open a new issue, there will be content there that tells you how to write a good, clear issue. Please, follow those instructions!**

### Learning Purescript Using This Project


- Read through these links about learning:
    - [How to teach yourself to learn](https://jvns.ca/blog/2018/09/01/learning-skills-you-can-practice/)
    - Asking good questions: [short read](https://jvns.ca/blog/good-questions/) and [long read](http://www.catb.org/~esr/faqs/smart-questions.html)
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

### File or Folder Name Meanings

If a file or folder name has `x` in the numerical part of its name (e.g. `0x-File-or-Folder-Name`, `9x-File-or-Folder-Name`), it means I am still deciding where it should appear in the numerical order (and it is likely still a work in progress).

Lastly, when referring to folders/files, we'll omit the numerical ordering (since the final order is still being determined). So, rather than `00-Getting-Started`, you'll see `Getting Started` folder. Rather than `00-Getting-Started/01-Install-Guide.md`, you'll see `Getting-Started/Install-Guide.md`
