#!/bin/sh

# This file will re-install and compile all the code in every folder
# in this project. It assumes that one has already installed
# purescript, pulp, and psc-package.
#
# Use it to update your entire project on new releases

## Syntax

echo "... Syntax ...."

cd 11-Syntax/01-Basic-Syntax/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/04-Module-Syntax/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

## Hello World

echo "... Hello World ...."

cd 21-Hello-World/03-Hello-World-and-Effects/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/04-Debugging/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/05-Testing/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package test
cd ../../

# Benchmarking is omitted because it requires using a custom package set
# TODO: fix this by using Dhall
#cd 21-Hello-World/06-Benchmarking/
#
#rm -rf .psc-package/ .pulp-cache/  output/
#psc-package install && pulp --psc-package test
#cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/08-Application-Structure/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build
cd ../../

cd 21-Hello-World/09-Games/
rm -rf .psc-package/ .pulp-cache/  output/
psc-package install && pulp --psc-package build && pulp --psc-package test -m Test.Games.RandomNumber.Run.Infrastructure
cd ../../

echo "... Finished ...."
