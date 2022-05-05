#!/bin/sh

# This script uses `spago` to build/test each folder's contents.
#
# A user should use this script to build and test the example programs
# and tests.  When this script finishes, it will output a concise summary
# of each build/test's success or failure, and finally deliver a prominent
# announcement whether this script was completely successful or had any
# failures.

## Syntax

echo "::group::Basic Syntax"
cd 11-Syntax/01-Basic-Syntax/
pwd
spago build
SYNTAX_BASIC=$?
cd ../../
echo "::endgroup::"

echo "::group::Foreign Function Interface Syntax"
cd 11-Syntax/02-Foreign-Function-Interface/
pwd
spago build
SYNTAX_FFI=$?
cd ../../
echo "::endgroup::"

echo "::group::Type Level Programming Syntax"
cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
spago build
SYNTAX_TLP=$?
cd ../../
echo "::endgroup::"

echo "::group::Module Syntax"
cd 11-Syntax/04-Module-Syntax/
pwd
spago build
SYNTAX_MODULE=$?
cd ../../
echo "::endgroup::"

echo "::group::Prelude Syntax"
cd 11-Syntax/05-Prelude-Syntax/
pwd
spago build
SYNTAX_PRELUDE=$?
cd ../../
echo "::endgroup::"

echo "::group::Rebindable Do/Ado Syntax"
cd 11-Syntax/06-Modifying-Do-Ado-Syntax-Sugar/
pwd
spago build
SYNTAX_DO_ADO_NOTATION=$?
cd ../../
echo "::endgroup::"

## Hello World

echo "::group::Hello World - Effect and Aff"
cd 21-Hello-World/02-Effect-and-Aff/
pwd
spago build
HELLO_EFFECT_AND_AFF=$?
cd ../../
echo "::endgroup::"

echo "::group::Hello World - Debugging"
cd 21-Hello-World/03-Debugging/
pwd
spago build
HELLO_DEBUGGING=$?
cd ../../
echo "::endgroup::"

echo "::group::Hello World - Collections and Loops"
cd 21-Hello-World/04-Collections-and-Loops
pwd
spago build
HELLO_COLLECTIONS_LOOPS=$?
cd ../../
echo "::endgroup::"

echo "::group::Hello World - Application Structure"
cd 21-Hello-World/05-Application-Structure/
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
echo "::endgroup::"

echo "::group::Hello World - Type Level Programming"
cd 21-Hello-World/06-Type-Level-Programming/
pwd
spago build
HELLO_TLP=$?
cd ../../
echo "::endgroup::"

echo "::group::Hello World - Testing"
cd 21-Hello-World/07-Testing/
pwd
# This folder includes tests that are designed to fail. So, rather than
# determining whether they succeeded, we just determine whether this
# folder builds correctly.
#
# No need to specify a path to 'test' because it's already included by default
spago build
HELLO_TESTING=$?
cd ../../
echo "::endgroup::"

echo "::group::Hello World - Benchmarking"
cd 21-Hello-World/08-Benchmarking/
pwd
spago build
HELLO_BENCHMARK=$?
cd ../../
echo "::endgroup::"

echo ""
echo "Finished. Summarizing Results:"

echo "$SYNTAX_BASIC - Syntax - Basic"
echo "$SYNTAX_FFI - Syntax - FFI"
echo "$SYNTAX_TLP - Syntax - TLP"
echo "$SYNTAX_MODULE - Syntax - Module"
echo "$SYNTAX_PRELUDE - Syntax - Prelude"
echo "$SYNTAX_DO_ADO_NOTATION - Syntax - Do/Ado Notation"
echo "$HELLO_EFFECT_AND_AFF - Hello World - Effects"
echo "$HELLO_DEBUGGING - Hello World - Debugging"
echo "$HELLO_COLLECTIONS_LOOPS - Hello World - Collections and Loops"
echo "$HELLO_APP_STRUCT_BUILT_OK - Hello World - Application Structure - Builds correctly"
echo "$HELLO_EXAMPLE_HELLO_WORLD_READERT - Hello World - Application Structure - Hello World - ReaderT"
echo "$HELLO_EXAMPLE_HELLO_WORLD_FREE - Hello World - Application Structure - Hello World - Free"
echo "$HELLO_EXAMPLE_HELLO_WORLD_RUN - Hello World - Application Structure - Hello World - Run"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_READERT - Hello World - Application Structure - Number Comparison - ReaderT"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_FREE - Hello World - Application Structure - Number Comparison - Free"
echo "$HELLO_EXAMPLE_NUMBER_COMPARISON_RUN - Hello World - Application Structure - Number Comparison - Run"
echo "$HELLO_TLP - Hello World - Type-Level Programming"
echo "$HELLO_TESTING - Hello World - Testing"
echo "$HELLO_BENCHMARK - Hello World - Benchmarking"

if [ $SYNTAX_BASIC = 0 ] &&
   [ $SYNTAX_FFI = 0 ] &&
   [ $SYNTAX_TLP = 0 ] &&
   [ $SYNTAX_MODULE = 0 ] &&
   [ $SYNTAX_PRELUDE = 0 ] &&
   [ $SYNTAX_DO_ADO_NOTATION = 0 ] &&
   [ $HELLO_EFFECT_AND_AFF = 0 ] &&
   [ $HELLO_DEBUGGING = 0 ] &&
   [ $HELLO_COLLECTIONS_LOOPS = 0 ] &&
   [ $HELLO_APP_STRUCT_BUILT_OK = 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_READERT = 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_FREE = 0 ] &&
   [ $HELLO_EXAMPLE_HELLO_WORLD_RUN = 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_READERT = 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_FREE = 0 ] &&
   [ $HELLO_EXAMPLE_NUMBER_COMPARISON_RUN = 0 ] &&
   [ $HELLO_TLP = 0 ] &&
   [ $HELLO_TESTING = 0 ] &&
   [ $HELLO_BENCHMARK = 0 ]
then
  echo "***** PASS: All Build Tasks and Tests Succeeded *****"
else
  echo "***** FAIL: At Least One Build Task or Test Failed *****"
  exit 1
fi
