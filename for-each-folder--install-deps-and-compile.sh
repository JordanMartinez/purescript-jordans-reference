#!/bin/sh

# This file will re-install and compile all the code in every folder
# in this project. It assumes that one has already installed
# purescript, pulp, and psc-package.
#
# Use it to update your entire project on new releases

## Syntax

echo "... Syntax ...."

cd 11-Syntax/01-Basic-Syntax/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

## Hello World

echo "... Hello World ...."

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/05-Testing/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install
# Test Spec folder
pulp --psc-package test -m Test.Spec.Examples.SelfContained.ConsoleReporter
# Test QuickCheck foler
pulp --psc-package test -m Test.QuickCheckSyntax
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
rm -rf .psc-package/ .pulp-cache/  output/  node_modules/
npm install benchmark
spacchetti insdhall
psc-package install && pulp --psc-package build --src-path "benchmark"
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/09-Projects/
pwd
rm -rf .psc-package/ .pulp-cache/  output/
npm install benchmark
spacchetti insdhall
psc-package install && pulp --psc-package build --src-path "benchmark" --include "src:test"

# Node-based tests
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
pulp --psc-package test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
cd ../../

echo "... Finished ...."
