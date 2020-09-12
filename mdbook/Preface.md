# Preface

## Intended Audience

The intended reader is one who has some background in programming, but no background in the Functional Programming paradigm. A reader should consult the summarized version of the Table of Contents below before determining what and how much to read.

If you want to understand why you should care about PureScript, read through the [Why Learn PureScript](./00-Getting-Started/01-Why-Learn-PureScript.md) page and [Philosophical Foundations](./01-FP-Philosophical-Foundations) section.

If you want to learn PureScript for web development, read the entire work from start to finish.

## Overview and Scope of the Work

All code in this work uses PureScript `0.13.8`

This work was created so a reader can understand PureScript and how to use it properly from a deep foundational understanding. Most other resources will get you started quickly, but then you will get confused at some point along the way. This resources takes longer to get started, but you will either not be confused or be less confused when we get to more advanced topics (e.g. monad transformers, type-level programming, etc.)

This work does not cover how to use PureScript to do web-development. In other words, things lik ethe following:
- how to use a PureScript single-page application (SPA) framework to build a frontend
- how to use a web server framework to build a backend
- how to do bundling and/or code-splitting effectively
- how to use HTML and CSS correctly, etc.

None of the above things need to be known to learn PureScript, but one will need to learn the above things outside of this work before they can build a great application via PureScript.

## How to Read This Work

This work is intended to be read in the following order:
1. Getting Started
1. FP Philosophical Foundations
1. Building Tools
1. Syntax
1. Hello World
1. Projects

The "Design Patterns" section should be read alongside of the "Syntax", "Hello World", and "Projects" folders.

The "Ecosystem" section is a reference guide.

Check the issue tracker for any [unresolved issues via the `bug` label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?q=is%3Aissue+is%3Aopen+label%3Abug).

## Summarized Table of Contents

There are currently 8 parts to this book. I summarize what is in each section below by showing the kinds of questions the section answers:
- **00-Getting-Started**:
    - Why learn/use PureScript?
    - How do I set up an editor (using Atom)?
    - How do I use the REPL?
    - What other things should I know before starting my learning journey?
- **01-Philosophical Foundations**:
    - What are some foundational ideas I need to understand before FP makes more sense?
    - What is the "big idea" behind using FP languages?
    - What are the drawbacks of using FP languages?
- **02-Build-Tools**:
    - Which tools do I use to compile and build my libraries/applications?
    - What are the workflows behind using those tools?
    - What other optional tools help me be more productive?
- **11-Syntax**:
    - How do I learn PureScript's syntax easily?
    - What other compiler features exist syntactically?
    - How do I read/write type-level programming?
    - How does `do notation` and `ado notation` work?
    - How does rebinding `do notation` and rebinding `ado notation` work?
- **21-Hello-World**:
    - How do I write a simple program?
    - How do I debug a program?
    - How do I write a complex program using modern FP architecture?
    - How do I test a program?
    - How do I benchmark a program or function within a prograhttps://github.com/jordanmartinez/purescript-jordans-reference/issuesm?
- **22-Projects**:
    - If you walked me through a complete but simple program from initial design to complete testing, what would that process look like?
        - Random Number Game - a game that runs on the console and in the browser using the same "business logic"
        - Table of Contents Generator - a program that generates a table of contents for a GitHub repository.
- **31-Design Patterns**:
    - What are commonly-used patterns or idioms to solve problems in FP languages?
    - What are other FP principles or concepts not explained in the "Hello World" part of this work?
- **41-Ecosystem**:
    - What are all of the data types that PureScript currently has?
    - What is a broad overview of the libraries in Purescript (categorized by tags)?
    - What are all of the type classes and their relationship to one another?

## Contributing

Feel free to [open a new issue](https://github.com/jordanmartinez/purescript-jordans-reference/issues) for:
- Clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- A link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- Corrections for any mistakes or typos I've made
- Improvements to anything I've written thus far
