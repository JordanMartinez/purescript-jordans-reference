# Install Guide

### Getting Additional Help

Throughout your learning process, it will be helpful to ask others for help. The two places this is often done is on the ML forum and the Slack group chat. If you encounter problems when installing anything below, ask for help on the Slack group's `#purescript-beginner` channel and you should receive help.

- Register for an account on the Functional Programming Slack group [here](https://fpchat-invite.herokuapp.com/) and add yourself to these two channels:`#purescript-beginner`, `#purescript`. You may also be interested in these channels: `#categoryTheory`, `#haskell`, and `#haskell-beginner` .
- Register for the Purescript ML forum [here](https://discourse.purescript.org/)

## PureScript's Open Collective

If you ever want to support PureScript, consider making a pledge on its [Open Collective](https://opencollective.com/purescript) page.

## Setting up Purescript for the First Time

### Installation

Justin Woo explains how to set up one's environment for the `0.12.x` release but has not been updated for two things. First, the PureScript release at the time was `0.12.0` but now `0.12.1` is out. Second, he did not include instructions for setting up [`spacchetti`](https://github.com/justinwoo/spacchetti) and its counterpart, `dhall`. Spacchetti is a project Justin later wrote to speed up tedious tasks that often arise when using `psc-package`.

If you just want to get things set up ASAP, follow the below summary of his article's instructions + the Spacchetti stuff. If you want to understand why you should do these commands, read [his article here](https://qiita.com/kimagure/items/570e6f2bbce5b4724564):
1. Install Node 8 or greater: https://nodejs.org/en/download/
2. Set your npm prefix: `npm set prefix ~/.npm`
3. Set your PATH: `export PATH="$HOME/.npm/bin:$PATH"`

NPM will then be used to install 4 packages
- `purescript` - the PureScript binary
- `pulp` - a build tool for PureScript
- `psc-package` - a dependency manager for PureScript
- `spacchetti` - already explained above

To install them, run this command:
```bash
npm i -g purescript@0.12.1 pulp psc-package-bin-simple spacchetti-cli-bin-simple
```
The following commands should now work (the versions beside them are the versions I used when writing this project):
```bash
purs --version        # 0.12.1
pulp --version        # 12.3.0
psc-package --version # 0.3.2
spacchetti version    # 0.5.0.0
```

In addition to the above packages, you also need to install `dhall-to-json`. [Dhall](https://github.com/dhall-lang/dhall-lang):
> Dhall is a programmable configuration language that is not Turing-complete
>
> You can think of Dhall as: JSON + functions + types + imports

Good news! You don't need to understand Dhall to use it (I've literally written the instructions / examples to copy/paste).

To install `dhall-to-json` for your platform, see [this page](https://github.com/dhall-lang/dhall-lang/wiki/Getting-started%3A-Generate-JSON-or-YAML)

See the `Build Tools/Tool Comparisons.md` file's "Why Spacchetti"'s section for more info about why `Spacchetti` even exists.

### Setting up your editor

The following are instructions for setting up the Atom editor. For Emacs, Vim, or Visual Studio, [consult Justin Woo's post on the matter](https://qiita.com/kimagure/items/570e6f2bbce5b4724564#install-some-editor-plugins) and [the respective page in the documentation repo](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#emacs)

Atom setup instructions:
1. Install Atom: `sudo apt-get install atom`
2. Launch Atom and install the following packages:
    - ide-purescript
    - atom-ide-ui
    - language-purescript
3. Configure `ide-purescript`

The Atom package, `ide-purescript`, is configured to `Bower`, but we'll be using `psc-package` as our dependency manager for this project. Follow these instructions
1. Open Atom's settings dialog (`CTRL+,`)
2. Click on the `Packages` tab
3. Search for `ide-purescript`
4. Click on the `Settings` button in the entry that appears
5. Check the `Add psc-package sources` checkbox
6. Change the `build command` to: `pulp --psc-package build -- --json-errors`

## Setting up Module Linker

When you're browsing through code on GitHub, the browser extenstion, Module Linker, can greatly help:
https://github.com/fiatjaf/module-linker
