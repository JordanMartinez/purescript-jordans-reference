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

cd 11-Syntax/06-Modifying-Do-Ado-Syntax-Sugar/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

## Hello World

echo "... Hello World ...."

# Removes the old folders due to breaking change in ps-0.13.x-v0.19.0
rm -rf 21-Hello-World/03-Effect-and-Aff/
rm -rf 21-Hello-World/04-Debugging/

# Continues on from here as normal
cd 21-Hello-World/02-Effect-and-Aff/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/03-Debugging/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/04-Collections-and-Loops/
pwd
rm -rf output/ .spago/
spago build
cd ../../

cd 21-Hello-World/05-Application-Structure/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/06-Type-Level-Programming/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
cd ../../

cd 21-Hello-World/07-Testing/
pwd
rm -rf output/ .spago/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
spago build
# Test Spec folder
spago test -m Test.Spec.Examples.SelfContained.ConsoleReporter
# Test QuickCheck foler
spago test -m Test.QuickCheckSyntax
cd ../../

cd 21-Hello-World/08-Benchmarking/
pwd
rm -rf output/ .spago/ node_modules/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json

npm install benchmark
spago build
cd ../../

cd 22-Projects/
pwd
rm -rf output/ .spago/ node_modules/
rm -rf .psc-package/ .pulp-cache/ .psc-package.json
npm install benchmark
spago build

# Node-based tests
spago test -m Test.RandomNumber.ReaderT.Standard.DifferentMonad
spago test -m Test.RandomNumber.ReaderT.Standard.SameMonad

spago test -m Test.ToC.MainLogic.QuickCheckTest
spago test -m Test.ToC.ParserLogic.QuickCheckTest
cd ../

echo "... Finished ...."
