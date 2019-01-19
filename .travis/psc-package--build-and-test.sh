#!/bin/bash

# This file uses psc-package and pulp to build/test each folder's contents
# The exit code from the build/test command is stored via "$?"
# At the end of this file, all exit codes are displayed and this shell
# exits with 0 if everything worked correctly. Otherwise, it exits with 1.
#
# Run this from the root of this project. In other words
#   `chmod +x .travis/psc-package--build-and-test.sh`
#   `./.travis/psc-package--build-and-test.sh`

## Syntax

cd 11-Syntax/01-Basic-Syntax/
pwd
pulp --psc-package build
SYNTAX_BASIC=$?
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
pulp --psc-package build
SYNTAX_FFI=$?
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
pulp --psc-package build
SYNTAX_TLP=$?
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
pulp --psc-package build
SYNTAX_MODULE=$?
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
pulp --psc-package build
SYNTAX_PRELUDE=$?
cd ../../

## Hello World

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
pulp --psc-package build
HELLO_EFFECTS=$?
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
pulp --psc-package build
HELLO_DEBUGGING=$?
cd ../../

cd 21-Hello-World/05-Testing/
pwd
# This fold includes tests that are designed to fail. So, rather than
# determining whether they succeeded, we just determine whether this
# folder builds correctly.
pulp --psc-package build --src-path "test"
HELLO_TESTING=$?
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
pulp --psc-package build --src-path "benchmark"
HELLO_BENCHMARK=$?
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
pulp --psc-package build
HELLO_TLP=$?
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
pulp --psc-package build
HELLO_APP_STRUCT=$?
cd ../../

cd 21-Hello-World/09-Projects/
pwd
# Build but do not run benchmark tests
pulp --psc-package build --src-path "benchmark" --include "src:test"
HELLO_PROJECTS_BUILT_OK=$?

# Run the "Simplest Program" examples
pulp --psc-package run -m Projects.SimplestProgram.ReaderT
HELLO_SIMPLEST_PROGRAM_READERT=$?
pulp --psc-package run -m Projects.SimplestProgram.Free
HELLO_SIMPLEST_PROGRAM_FREE=$?
pulp --psc-package run -m Projects.SimplestProgram.Run
HELLO_SIMPLEST_PROGRAM_RUN=$?

# Node-based tests
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad
HELLO_RANDOM_TEST_READERT_DIFFERENT=$?
pulp --psc-package test -m Test.Games.RandomNumber.ReaderT.Standard.SameMonad
HELLO_RANDOM_TEST_READERT_SAME=$?
pulp --psc-package test -m Test.Games.RandomNumber.Run.Standard.Infrastructure
HELLO_RANDOM_TEST_RUN_STANDARD=$?
pulp --psc-package test -m Test.Games.RandomNumber.Run.Layered.Infrastructure
HELLO_RANDOM_TEST_RUN_LAYERED=$?
cd ../../

echo ""
echo "Finished. Summarizing Results:"

echo "$SYNTAX_BASIC - Syntax - Basic"
echo "$SYNTAX_FFI - Syntax - FFI"
echo "$SYNTAX_TLP - Syntax - TLP"
echo "$SYNTAX_MODULE - Syntax - Module"
echo "$SYNTAX_PRELUDE - Syntax - Prelude"
echo "$HELLO_EFFECTS - Hello World - Effects"
echo "$HELLO_DEBUGGING - Hello World - Debugging"
echo "$HELLO_TESTING - Hello World - Testing"
echo "$HELLO_BENCHMARK - Hello World - Benchmarking"
echo "$HELLO_TLP - Hello World - Type-Level Programming"
echo "$HELLO_APP_STRUCT - Hello World - Application Structure"
echo "$HELLO_PROJECTS_BUILT_OK - Hello World - Projects - All - Builds Correctly"
echo "$HELLO_SIMPLEST_PROGRAM_READERT - Hello World - Simplest Program - ReaderT"
echo "$HELLO_SIMPLEST_PROGRAM_FREE - Hello World - Simplest Program - Free"
echo "$HELLO_SIMPLEST_PROGRAM_RUN - Hello World - Simplest Program - Run"
echo "$HELLO_RANDOM_TEST_READERT_DIFFERENT - Hello World - Projects - RandomNumber - ReaderT Test (Different)"
echo "$HELLO_RANDOM_TEST_READERT_SAME - Hello World - Projects - RandomNumber - ReaderT Test (Same)"
echo "$HELLO_RANDOM_TEST_RUN_STANDARD - Hello World - Projects - RandomNumber - Run Test (Standard)"
echo "$HELLO_RANDOM_TEST_RUN_LAYERED - Hello World - Projects - RandomNumber - Run Test (Layered)"

if [ $SYNTAX_BASIC == 0 ] &&
   [ $SYNTAX_FFI == 0 ] &&
   [ $SYNTAX_TLP == 0 ] &&
   [ $SYNTAX_MODULE == 0 ] &&
   [ $SYNTAX_PRELUDE == 0 ] &&
   [ $HELLO_EFFECTS == 0 ] &&
   [ $HELLO_DEBUGGING == 0 ] &&
   [ $HELLO_TESTING == 0 ] &&
   [ $HELLO_BENCHMARK == 0 ] &&
   [ $HELLO_TLP == 0 ] &&
   [ $HELLO_APP_STRUCT == 0 ] &&
   [ $HELLO_RANDOM_BUILT_OK == 0 ] &&
   [ $HELLO_SIMPLEST_PROGRAM_READERT == 0 ] &&
   [ $HELLO_SIMPLEST_PROGRAM_FREE == 0 ] &&
   [ $HELLO_SIMPLEST_PROGRAM_RUN == 0 ] &&
   [ $HELLO_RANDOM_TEST_READERT_DIFFERENT == 0 ] &&
   [ $HELLO_RANDOM_TEST_READERT_SAME == 0 ] &&
   [ $HELLO_RANDOM_TEST_RUN_STANDARD == 0 ] &&
   [ $HELLO_RANDOM_TEST_RUN_LAYERED == 0 ]
then
  echo "Build Succeeded"
  exit 0;
else
  echo "Build Failed"
  exit 1;
fi
