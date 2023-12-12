# Install Guide

## Getting Additional Help

Throughout your learning process, it will be helpful to ask others for help. The two places this is often done is on PureScript's Discourse forum and its Discord server.

- Register for an account on [PureScript's Discord server](https://purescript.org/chat)
    - Note: I'll refer to this as PureScript's chatroom throughout this work.
- Register for the Purescript ML forum [here](https://discourse.purescript.org/)

## Setting up Purescript for the First Time

### Overview

We'll show how to install the following programs:
- [`purescript`](https://github.com/purescript/purescript) - the PureScript language & compiler
- [`spago`](https://github.com/purescript/spago/) - a dependency manager and build tool for PureScript
- [`esbuild`](https://esbuild.github.io/) - a build tool for bundling a PureScript application into a multiple JS backends (node, browser)
- (optional, recommended) [`purescript-psa`](https://www.npmjs.com/package/purescript-psa) - pretty-prints compiler warnings/errors with stats; promotes compiler warnings to errors
- (optional, recommended) [`purs-tidy`](https://www.npmjs.com/package/purs-tidy) - a formatter for PureScript
- (optional, recommended) [`purs-backend-es`](https://github.com/aristanetworks/purescript-backend-optimizer) - a tool for producing optimized JavaScript code from the compiler's output.

Thomas Honeyman, a core contributor to PureScript, usually posts an annual ["Recommended Tooling for PureScript in &lt;year&gt;"](https://discourse.purescript.org/t/recommended-tooling-for-purescript-in-2022/3206). At the time of writing, this one was for 2022.

### Installation

#### Installing NPM

We can install everything using `npm`. However, getting `npm` is it's own problem. We can either install it manually by downloading `node` and installing that. Or we can use `nvm` (Node Version Manager) to install it for us and continue from there.

##### Manual Install

1. Install Node 16 or greater: https://nodejs.org/en/download/
2. Set your npm prefix: `npm set prefix ~/.npm`
    - Note: this prevents having to use `sudo` when using NPM to install things since it's default prefix is in a place that requires admin privileges
3. Set your PATH: `export PATH="$PATH:$HOME/.npm/bin"`

##### NVM Install

1. Install `nvm` using their [installation instructions](https://github.com/nvm-sh/nvm#installation-and-update)
2. [Verify that the installation was successful](https://github.com/nvm-sh/nvm#verify-installation) via `command -v nvm`
3. [Install `node` via `nvm`](https://github.com/nvm-sh/nvm#usage). To get the latest `node` version, use the command, `nvm install node`.

Unlike the manual install, `nvm` properly handles the npm prefix for you. So, you don't need to set it yourself.

#### Installing PureScript and Related Tooling

Once you have installed `npm`, we can use it to install everything in one command:

```sh
npm i -g purescript@0.15.13 spago@0.21.0 esbuild@0.19.8 purs-tidy@0.10.0 purs-backend-es@1.4.2 purescript-psa@0.8.2
```


If you want to produce optimized JavaScript for your production environment (rather than a developer environment), install [`purs-backend-es`](https://github.com/aristanetworks/purescript-backend-optimizer):

```sh
npm i -g purs-backend-es
```

### Versions Used in this Project

The following commands should now work:

```sh
purs --version        # 0.15.13
spago --version       # 0.21.0
esbuild --version     # 0.19.8
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

The following are instructions for setting up the VS Code editor. For other editors, see [the respective page in the documentation repo](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md#emacs)

1. Install VS Code
2. Launch VS Code and install the following packages:
    - ide-purescript
    - language-purescript
3. Configure `ide-purescript`

## Setting up Module Linker

When you're browsing through code on GitHub, the browser extenstion, Module Linker, can greatly help:
https://github.com/fiatjaf/module-linker
