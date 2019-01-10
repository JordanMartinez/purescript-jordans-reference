#!/bin/sh

# This file uses psc-package and pulp to build/test each folder's contents

## Syntax

cd 11-Syntax/01-Basic-Syntax/
pwd
pulp --psc-package build
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
pulp --psc-package build
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
pulp --psc-package build
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
pulp --psc-package build
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
pulp --psc-package build
cd ../../

## Hello World

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
pulp --psc-package build
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
pulp --psc-package build
cd ../../

cd 21-Hello-World/05-Testing/
pwd
# Test Spec folder
pulp --psc-package test -m Test.Spec.Examples.SelfContained.ConsoleReporter
# Test QuickCheck foler
pulp --psc-package test -m Test.QuickCheckSyntax
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
pulp --psc-package build --src-path "benchmark"
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
pulp --psc-package build
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
pulp --psc-package build
cd ../../

cd 21-Hello-World/09-Projects/
pwd
# Build but do not run benchmark tests
pulp --psc-package build --src-path "benchmark" --include "src:test"

# Node-based tests
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
pulp --psc-package test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
cd ../../

echo "... Finished ...."
