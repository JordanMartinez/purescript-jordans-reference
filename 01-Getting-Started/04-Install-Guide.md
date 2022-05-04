# Install Guide

## Getting Additional Help

Throughout your learning process, it will be helpful to ask others for help. The two places this is often done is on PureScript's Discourse forum and its Discord server.

- Register for an account on [PureScript's Discord server](https://purescript.org/chat)
    - Note: I'll refer to this as PureScript's chatroom throughout this work.
- Register for the Purescript ML forum [here](https://discourse.purescript.org/)

## Setting up Purescript for the First Time

### Overview

We'll show how to install the following programs:
- `purescript` - the PureScript language & compiler
- `spago` - a dependency manager and build tool for PureScript
- (optional) a formatter for PureScript
- `parcel` - a build tool for bundling a PureScript application into a multiple JS backends (node, browser, electron)

### Installation

#### Installing NPM

We can install everything using `npm`. However, getting `npm` is it's own problem. We can either install it manually by downloading `node` and installing that. Or we can use `nvm` (Node Version Manager) to install it for us and continue from there.

##### Manual Install

Justin Woo explains how to set up one's environment for the `0.12.x` release but has not been updated for two things. First, the PureScript release at the time was `0.12.0` but now `0.13.8` is out. Second, the instructions use `pulp` and `psc-package`, a different build tool workflow than the one we'll use here.

If you just want to get things set up ASAP, follow the below summary of his article's instructions (using `spago` instead of the other tools). If you want to understand why you should do these commands, read [his article here](https://qiita.com/kimagure/items/570e6f2bbce5b4724564):
1. Install Node 14 or greater: https://nodejs.org/en/download/
2. Set your npm prefix: `npm set prefix ~/.npm`
    - Note: this prevents having to use `sudo` when using NPM to install things since it's default prefix is in a place that requires admin privileges
3. Set your PATH: `export PATH="$HOME/.npm/bin:$PATH"`

##### NVM Install

1. Install `nvm` using their [installation instructions](https://github.com/nvm-sh/nvm#installation-and-update)
2. [Verify that the installation was successful](https://github.com/nvm-sh/nvm#verify-installation) via `command -v nvm`
3. [Install `node` via `nvm`](https://github.com/nvm-sh/nvm#usage). To get the latest `node` version, use the command, `nvm install node`.

Unlike the manual install, `nvm` properly handles the npm prefix for you. So, you don't need to set it yourself.

#### Installing PureScript and Related Tooling

Once you have installed `npm`, we can use it to install everything in one command:

```sh
npm i -g purescript@0.15.0 spago@0.20.9 esbuild@0.14.38
```

If you want to install a PureScript formatter, refer to their instructions. The history behind these tools will be covered in the `Build Tools` folder:

- [purs-tidy](https://github.com/natefaubion/purescript-tidy) - A self-contained formatter written in PureScript
- [pose](https://pose.rowtype.yoga/) - A plugin written in PureScript for the [`Prettier`](https://prettier.io/) formatter

### Versions Used in this Project

The following commands should now work:

```sh
purs --version        # 0.15.0
spago --version       # 0.20.9
esbuild --version     # 0.14.38
```

### Building This Project

Once the above has been verified, you can build this project.

First of all, if you haven't yet cloned this project locally, then do so now:

```sh
git clone https://github.com/JordanMartinez/purescript-jordans-reference
```

Then execute the script below which will install, build, and test every folder in this project:

```sh
source .ci/install-build-test-all.sh
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
6. Change the `build command` to: `spago build -u --json-errors`

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
