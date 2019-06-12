#!/bin/bash

# This file uses `spago` to build/test each folder's contents
# The exit code from the build/test command is stored via "$?"
# At the end of this file, all exit codes are displayed and this shell
# exits with 0 if everything worked correctly. Otherwise, it exits with 1.
#
# Run this from the root of this project. In other words
#   `chmod +x .travis/spago--build-and-test.sh`
#   `./.travis/spago--build-and-test.sh`

## Syntax

cd 11-Syntax/01-Basic-Syntax/
pwd
spago build
SYNTAX_BASIC=$?
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
spago build
SYNTAX_FFI=$?
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
spago build
SYNTAX_TLP=$?
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
spago build
SYNTAX_MODULE=$?
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
spago build
SYNTAX_PRELUDE=$?
cd ../../

## Hello World

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
spago build
HELLO_EFFECTS=$?
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
spago build
HELLO_DEBUGGING=$?
cd ../../

cd 21-Hello-World/05-Testing/
pwd
# This folder includes tests that are designed to fail. So, rather than
# determining whether they succeeded, we just determine whether this
# folder builds correctly.
#
# No need to specify a path to 'test' because it's already included by default
spago build
HELLO_TESTING=$?
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
spago build --path "benchmark/**/*.purs"
HELLO_BENCHMARK=$?
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
spago build
HELLO_TLP=$?
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
spago build
HELLO_APP_STRUCT_BUILT_OK=$?

# Run the example programs
## Hello World
spago run -m Examples.HelloWorld.ReaderT
HELLO_EXAMPLE_HELLO_WORLD_READERT=$?
spago run -m Examples.HelloWorld.Free
HELLO_EXAMPLE_HELLO_WORLD_FREE=$?
spago run -m Examples.HelloWorld.Run
HELLO_EXAMPLE_HELLO_WORLD_RUN=$?

## Number Comparison
spago run -m Examples.NumberComparison.ReaderT
HELLO_EXAMPLE_NUMBER_COMPARISON_READERT=$?
spago run -m Examples.NumberComparison.Free
HELLO_EXAMPLE_NUMBER_COMPARISON_FREE=$?
spago run -m Examples.NumberComparison.Run
HELLO_EXAMPLE_NUMBER_COMPARISON_RUN=$?

cd ../../

cd 22-Projects/
pwd
# Build but do not run benchmark tests
spago build -p "benchmark/**/*.purs"
PROJECTS_BUILT_OK=$?

# Node-based tests
spago test -m Test.RandomNumber.ReaderT.Standard.DifferentMonad
RANDOM_TEST_READERT_DIFFERENT=$?
spago test -m Test.RandomNumber.ReaderT.Standard.SameMonad
RANDOM_TEST_READERT_SAME=$?

spago test -m Test.ToC.MainLogic.QuickCheckTest
TOC_TEST_MAIN_LOGIC_BOTH=$?
spago test -m Test.ToC.ParserLogic.QuickCheckTest
TOC_TEST_PARSER_LOGIC_BOTH=$?
cd ../

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
echo "$HELLO_APP_STRUCT_BUILT_OK - Hello World - Application Structure - Builds correctly"
echo "$HELLO_EXAMPLE_HELLO_WORLD_READERT - Hello World - Application Structure - Hello World - ReaderT"
echo "$HELLO_EXAMPLE_HELLO_WORLD_FREE - Hello World - Application Structure - Hello World - Free"
echo "$HELLO_EXAMPLE_HELLO_WORLD_RUN - Hello World - Application Structure - Hello World - Run"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_READERT - Hello World - Application Structure - Number Comparison - ReaderT"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_FREE - Hello World - Application Structure - Number Comparison - Free"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_RUN - Hello World - Application Structure - Number Comparison - Run"
echo "$PROJECTS_BUILT_OK - Projects - All - Builds Correctly"
echo "$RANDOM_TEST_READERT_DIFFERENT - Projects - RandomNumber - ReaderT Test (Different)"
echo "$RANDOM_TEST_READERT_SAME - Projects - RandomNumber - ReaderT Test (Same)"
echo "$TOC_TEST_MAIN_LOGIC_BOTH - Projects - ToC - Main - Both"
echo "$TOC_TEST_PARSER_LOGIC_BOTH - Projects - ToC - Parser - Both"

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
   [ $HELLO_APP_STRUCT_BUILT_OK == 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_READERT == 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_FREE == 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_RUN == 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_READERT == 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_FREE == 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_RUN == 0 ] &&
   [ $PROJECTS_BUILT_OK == 0 ] &&
   [ $RANDOM_TEST_READERT_DIFFERENT == 0 ] &&
   [ $RANDOM_TEST_READERT_SAME == 0 ] &&
   [ $TOC_TEST_MAIN_LOGIC_BOTH == 0 ] &&
   [ $TOC_TEST_PARSER_LOGIC_BOTH == 0 ]
then
  echo "Build Succeeded"
  exit 0;
else
  echo "Build Failed"
  exit 1;
fi
