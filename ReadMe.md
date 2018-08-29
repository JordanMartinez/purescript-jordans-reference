# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created. These have been gathered into the following folders

- 00-Getting-Started - how to install Purscript, set up an editor (using Atom), and get familiar with the REPL.
- 01-Build-Tools - how to use the tools in the ecosystem to manage dependencies, compile source code, and build projects
- 11-Syntax - how to use syntax to write code in Purescript (PS versions: `0.12.0`)
- 21-Hello-World - everything you need to know (Monad explanation using pictures included) in how to write your first "Hello World" program (and actually understand what it's doing)
- 31-Design Patterns - commonly-used patterns to solve problems in FP languages
- 41-Ecosystem - a better overview of the libraries in Purescript (categorized by tags)

See [issues marked with the 'Roadmap' label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3ARoadmap) for a deeper understanding of this project's current direction/goals.

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- a link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- corrections for any mistakes I've made
- improvements to anything I've written thus far

### License

Since the license of this project is still being determined, I will not currently accept pull requests. I do hope to receive PRs in the future after the license has been determined. Feel free to open an issue to start a discussion on this topic.

## Learning Purescript Using This Project

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

Lastly, when referring to folders/files, we'll omit the numerical ordering (since the final order is still being determined). So, rather than `00-Getting-Started`, you'll see `Getting Started` folder. Rather than `00-Getting-Started/01-Install-Guide.md`, you'll see `Getting-Started/Install-Guide.md`
