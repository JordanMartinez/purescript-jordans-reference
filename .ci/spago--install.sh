#!/bin/sh

# This file will re-install and compile all the code in every folder
# in this project. It assumes that one has already installed
# purescript, spago, and dhall-to-json.
#
# Use it to update your entire project on new releases

cd 11-Syntax/01-Basic-Syntax/
pwd
spago install
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
spago install
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
spago install
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
spago install
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
spago install
cd ../../

cd 11-Syntax/06-Modifying-Do-Ado-Syntax-Sugar/
pwd
spago install
cd ../../

## Hello World

cd 21-Hello-World/02-Effect-and-Aff/
pwd
spago install
cd ../../

cd 21-Hello-World/03-Debugging/
pwd
spago install
cd ../../

cd 21-Hello-World/04-Collections-and-Loops
pwd
spago install
cd ../../

cd 21-Hello-World/05-Application-Structure/
pwd
spago install
cd ../../

cd 21-Hello-World/06-Type-Level-Programming/
pwd
spago install
cd ../../

cd 21-Hello-World/07-Testing/
pwd
spago install
cd ../../

cd 21-Hello-World/08-Benchmarking/
pwd
npm install benchmark
spago install
cd ../../

echo "... Finished ...."
