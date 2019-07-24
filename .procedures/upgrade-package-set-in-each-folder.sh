#!/bin/sh

# This file will update each folder's package set to the latest released one
# It should be run at the root directory of this learning repository.

echo "... Syntax ...."

cd 11-Syntax/01-Basic-Syntax/
pwd
spago package-set-upgrade
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
spago package-set-upgrade
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
spago package-set-upgrade
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
spago package-set-upgrade
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
spago package-set-upgrade
cd ../../

cd 11-Syntax/06-Modifying-Do-Ado-Syntax-Sugar/
pwd
spago package-set-upgrade
cd ../../

echo "... Hello World ...."

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
spago package-set-upgrade
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
spago package-set-upgrade
cd ../../

cd 21-Hello-World/05-Testing/
pwd
spago package-set-upgrade
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
spago package-set-upgrade
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
spago package-set-upgrade
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
spago package-set-upgrade
cd ../../

echo "... Projects ...."

cd 22-Projects/
pwd
spago package-set-upgrade
cd ../

echo "... Finished ...."
