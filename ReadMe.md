# Purescript-Jordans-Reference

This repo is my way of trying to use the [Feynman Technique](https://medium.com/taking-note/learning-from-the-feynman-technique-5373014ad230) to help me learn Purescript and its ecosystem. It includes a number of links and other resources I've gathered or created. These have been gathered into the following folders

- 11-Syntax - how to use syntax to write code in Purescript (PS versions: `0.12.0`)
- 21-Hello-World - everything you need to know (Monad explanation using pictures included) in how to write your first "Hello World" program (and actually understand what it's doing)
- 31-Design Patterns - commonly-used patterns to solve problems in FP languages
- 41-Ecosystem - a better overview of the libraries in Purescript (categorized by tags)

See [issues marked with the 'Roadmap' label](https://github.com/JordanMartinez/purescript-jordans-reference/issues?q=is%3Aopen+is%3Aissue+label%3ARoadmap) for a deeper understanding of this project's current direction/goals.

## Guidelines for this project

### Contributing

Feel free to open a new issue for:
- clarification on something you don't understand. If I don't know it yet and I'm interested, it'll force me to learn it
- a link to something you'd like me to research more. If I'm interested or see the value, I'll look into it and try to document it or explain the idea in a clear way
- corrections for any mistakes I've made
- improvements to anything I've written thus far

### License

Since the license of this project is still being determined, I will not currently accept pull requests. I do hope to receive PRs in the future after the license has been determined. Feel free to open an issue to start a discussion on this topic.

## Learning Purescript

### Getting Additional Help

- Register for the Purescript ML forum [here](https://purescript-users.ml/)
- Register for an account on the Functional Programming Slack group [here](https://functionalprogramming.slack.com/) and add yourself to all of these channels:`#purescript-beginner`, `#purescript`, `#categoryTheory` (optional), `#haskell` (optional), `#haskell-beginner` (optional).

### Using this project

- Git clone this repo
- Install Purescript `0.12.0` via the below instructions
- Read through the folders in their order (e.g. a depth-first graph search)
- Compile the code where possible, either before or after you experiment

## Setting up Purescript for the first time

### Installation

The [Purescript By Example book](https://leanpub.com/purescript/) demonstrates how to set up one's environment for PureScript `0.11.x`. Since its release, `0.12.0` has been released, which introduced major breaking changes. Fortunately, Justin Woo explains how to set up one's environment for the `0.12.0` release [in his blog post here](https://qiita.com/kimagure/items/570e6f2bbce5b4724564). If you want to understand why you should do these commands, read his article. If you just want to get things set up ASAP, follow the below summary of that article's instructions:
1. Install Node 8 or greater: https://nodejs.org/en/download/
2. Set your npm prefix: `npm set prefix ~/.npm`
3. Set your PATH: `export PATH="$HOME/.npm/bin:$PATH"`
4. Install Purescript, pulp, and psc-package: `npm i -g purescript@0.12.0 pulp psc-package`

The following commands should now work:
```bash
purs --version
pulp --version
psc-pacakge
```
### Setting up your editor

The following are instructions for setting up the Atom editor. For Emacs, Vi, or Visual Studio, [consult Justin Woo's post on the matter](https://qiita.com/kimagure/items/570e6f2bbce5b4724564#install-some-editor-plugins) and [the respective page in the documentation repo](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#emacs)

Atom setup instructions:
1. Install Atom: `sudo apt-get install atom`
2. Launch Atom and install the following packages:
    - ide-purescript
    - atom-ide-ui
    - language-purescript

## Helpful Links

- [Awesome Purescript Index](https://github.com/passy/awesome-purescript)
- [Pursuit - Docs for Purescript packages](http://pursuit.purescript.org/)
- [Deprecatd packages](https://github.com/purescript-deprecated)
- [Purescript Cookbook](http://codingstruggles.com/ps-cookbook/) - aims to demonstrate a few simple concepts
