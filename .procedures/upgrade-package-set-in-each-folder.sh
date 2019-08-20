#!/bin/sh

# This file will update each folder's package set to the latest released one
# It should be run at the root directory of this learning repository.

echo "... Syntax ...."

cd 11-Syntax/01-Basic-Syntax/
pwd
spago upgrade-set
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
spago upgrade-set
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
spago upgrade-set
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
spago upgrade-set
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
spago upgrade-set
cd ../../

cd 11-Syntax/06-Modifying-Do-Ado-Syntax-Sugar/
pwd
spago upgrade-set
cd ../../

echo "... Hello World ...."

cd 21-Hello-World/03-Effect-and-Aff/
pwd
spago upgrade-set
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
spago upgrade-set
cd ../../

cd 21-Hello-World/05-Application-Structure/
pwd
spago upgrade-set
cd ../../

cd 21-Hello-World/06-Type-Level-Programming/
pwd
spago upgrade-set
cd ../../

cd 21-Hello-World/07-Testing/
pwd
spago upgrade-set
cd ../../

cd 21-Hello-World/08-Benchmarking/
pwd
spago upgrade-set
cd ../../

echo "... Projects ...."

cd 22-Projects/
pwd
spago upgrade-set
cd ../

echo "... Finished ...."
