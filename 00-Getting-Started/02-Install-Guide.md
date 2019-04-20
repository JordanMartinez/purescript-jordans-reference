# Install Guide

## Getting Additional Help

Throughout your learning process, it will be helpful to ask others for help. The two places this is often done is on the ML forum and the Slack group chat. If you encounter problems when installing anything below, ask for help on the Slack group's `#purescript-beginner` channel and you should receive help.

- Register for an account on the Functional Programming Slack group [here](https://fpchat-invite.herokuapp.com/) and add yourself to these two channels:`#purescript-beginner`, `#purescript`. You may also be interested in these channels: `#categoryTheory`, `#haskell`, and `#haskell-beginner` .
- Register for the Purescript ML forum [here](https://discourse.purescript.org/)

## Setting up Purescript for the First Time

### Overview

We'll show how to install the following programs:
- `purescript` - the PureScript language & compiler
- `spago` - a dependency manager and build tool for PureScript
- `dhall-to-json` - a dependency that `spago` uses for outputting well-typed JSON
- `parcel` - a build tool for bundling a PureScript application into a multiple JS backends (node, browser, electron)

### Installation

Justin Woo explains how to set up one's environment for the `0.12.x` release but has not been updated for two things. First, the PureScript release at the time was `0.12.0` but now `0.12.5` is out. Second, the instructions use `pulp` and `psc-package`, a different build tool workflow than the one we'll use here.

If you just want to get things set up ASAP, follow the below summary of his article's instructions (using `spago` instead of the other tools). If you want to understand why you should do these commands, read [his article here](https://qiita.com/kimagure/items/570e6f2bbce5b4724564):
1. Install Node 10 or greater: https://nodejs.org/en/download/
2. Set your npm prefix: `npm set prefix ~/.npm`
    - Note: this prevents having to use `sudo` when using NPM to install things since it's default prefix is in a place that requires admin privileges
3. Set your PATH: `export PATH="$HOME/.npm/bin:$PATH"`

NPM will then be used to install 3 of the above requirements. Run this command:
```bash
npm i -g purescript@0.12.5 spago parcel
```

`dhall-to-json` (we're using version `1.20.1`) requires separate installation. To install `dhall-to-json` for your platform, see their [Getting Started](https://github.com/dhall-lang/dhall-lang/wiki/Getting-started%3A-Generate-JSON-or-YAML#installation).

### Versions Used in this Project

The following commands should now work (the versions beside them are the versions I used when writing this project):
```bash
purs --version        # 0.12.5
spago version         # 0.7.4.0
parcel --version      # 1.12.0

# dhall-to-json does not have a version command
# but we're using `1.20.1` in this project.
```

### Building This Project

Once the above has been verified, run the below script, which will download, install, and build every folder in this project. Open a shell in this project's parent folder and run this command:
```bash
./for-each-folder--install-deps-and-compile.sh
```

Whenever I make a new release with breaking changes, this script will remove any outdated dependencies, reinstall the correct ones, and rebuild all of the folders' code.

### Setting up your editor

The following are instructions for setting up the Atom editor. For Emacs, Vim, or Visual Studio, [consult Justin Woo's post on the matter](https://qiita.com/kimagure/items/570e6f2bbce5b4724564#install-some-editor-plugins) and [the respective page in the documentation repo](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#emacs)

Atom setup instructions:
1. Install Atom: `sudo apt-get install atom`
2. Launch Atom and install the following packages:
    - ide-purescript
    - atom-ide-ui
    - language-purescript
3. Configure `ide-purescript`

The Atom package, `ide-purescript`, is configured to `Bower`, but we'll be using `spago` as our dependency manager for this project. Follow these instructions
1. Open Atom's settings dialog (`CTRL+,`)
2. Click on the `Packages` tab
3. Search for `ide-purescript`
4. Click on the `Settings` button in the entry that appears
5. Check the `Add spago sources` checkbox
6. Change the `build command` to: `spago build -- --json-errors`

### Getting IDE support (autocomplete, documentation-on-hover, etc.) in Atom

While this repository's contents are useful for learning various lessons, IDE support (autocomplete, documentation, etc.) will only work if you open this repository's contents in a specific way when using Atom. Follow the instructions below:
1. Click "File" and click "Open Folder..." (shortcut: `CTRL+O`)
2. In the folder chooser, choose one of this repo's project folders (i.e. a folder with a `spago.dhall` file and `src` folder)
3. Click on "Packages" and click on "PureScript" and then on "Build". The IDE server will start running and rebuild just that project.*
    - Autocomplete, importing, and documentation will now work.

* This is a command you will use frequently, so consider adding a keyboard shortcut for it.
1. Open the Atom settings dialog (`CTRL+,`)
2. Click on the "KeyBindings" tab
3. Click on the "your keymap file" hyperlink that appears before the bindings
4. Follow the instructions for adding your personal shortcut for the `ide-purescript:build` command.

For mine, I did:
```cson
'.platform-linux atom-workspace atom-text-editor:not([mini])':
  'ctrl-shift-b': 'ide-purescript:build'
```

#### Dealing with IDE Server issues in Atom

Sometimes when editing a file, the IDE server will go out-of-sync. For example, you might change the definition of a type and the IDE doesn't realize that occured, so it will tell you that you have used a type incorrectly. In such cases, rebuild the project using Step 3 (or your keyboard shortcut) above and things should correct themselves from there.

In situations where I have used the same names for things, the autocomplete might actually import a function or type with the same name as the one you want but from a different module. So, if you have weird compiler errors, check the imports to insure the IDE server didn't accidentally import something incorrect or from the wrong location.

## Setting up Module Linker

When you're browsing through code on GitHub, the browser extenstion, Module Linker, can greatly help:
https://github.com/fiatjaf/module-linker
