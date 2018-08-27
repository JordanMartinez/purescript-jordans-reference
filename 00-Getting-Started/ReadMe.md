# Install Guide

### Getting Additional Help

Throughout your learning process, it will be helpful to ask others for help. The two places this is often done is on the ML forum and the Slack group chat. If you encounter problems when installing anything below, ask for help on the `#purescript-beginner` channel and you should receive help.

- Register for an account on the Functional Programming Slack group [here](https://functionalprogramming.slack.com/) and add yourself to all of these channels:`#purescript-beginner`, `#purescript`, `#categoryTheory` (optional), `#haskell` (optional), `#haskell-beginner` (optional).
- Register for the Purescript ML forum [here](https://discourse.purescript.org/)

## Setting up Purescript for the first time

### Installation

The [Purescript By Example book](https://leanpub.com/purescript/) demonstrates how to set up one's environment for PureScript `0.11.x` (outdated). Since the book's release, PureScript `0.12.0` has been released, which introduced breaking changes. Fortunately, Justin Woo explains how to set up one's environment for the `0.12.0`. If you just want to get things set up ASAP, follow the below summary of his article's instructions. If you want to understand why you should do these commands, read [his article here](https://qiita.com/kimagure/items/570e6f2bbce5b4724564):
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
