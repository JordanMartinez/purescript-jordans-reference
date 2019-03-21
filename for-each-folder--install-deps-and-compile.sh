#!/bin/sh

# This file will re-install and compile all the code in every folder
# in this project. It assumes that one has already installed
# purescript, spago, and dhall-to-json.
#
# Use it to update your entire project on new releases

# Due to migrating to spago (done in `ps-0.12.x-v0.12.0` release of this repo),
# this command will also clean up any files/directories related to
# `pulp` and `psc-package`:
#    rm -rf .psc-package/ .pulp-cache/ .psc-package.json
#
# The above line will be removed in a later release.

## Syntax

echo "... Syntax ...."

cd 11-Syntax/01-Basic-Syntax/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

## Hello World

echo "... Hello World ...."

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/05-Testing/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
# Test Spec folder
spago test -m Test.Spec.Examples.SelfContained.ConsoleReporter
# Test QuickCheck foler
spago test -m Test.QuickCheckSyntax
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json

npm install benchmark
spago build -p "benchmark/**/*.purs"
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 22-Projects/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
npm install benchmark yargs
spago build -p "benchmark/**/*.purs"

# Node-based tests
spago test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
spago test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
cd ../

echo "... Finished ...."
