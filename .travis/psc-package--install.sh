#!/bin/sh

# This file will re-install and compile all the code in every folder
# in this project. It assumes that one has already installed
# purescript, pulp, psc-package, and spachetti.
#
# Use it to update your entire project on new releases

cd 11-Syntax/01-Basic-Syntax/
pwd
psc-package install
cd ../../

cd 11-Syntax/02-Foreign-Function-Interface/
pwd
psc-package install
cd ../../

cd 11-Syntax/03-Type-Level-Programming-Syntax/
pwd
psc-package install
cd ../../

cd 11-Syntax/04-Module-Syntax/
pwd
psc-package install
cd ../../

cd 11-Syntax/05-Prelude-Syntax/
pwd
psc-package install
cd ../../

## Hello World

cd 21-Hello-World/03-Hello-World-and-Effects/
pwd
psc-package install
cd ../../

cd 21-Hello-World/04-Debugging/
pwd
psc-package install
cd ../../

cd 21-Hello-World/05-Testing/
pwd
psc-package install
cd ../../

cd 21-Hello-World/06-Benchmarking/
pwd
npm install benchmark
spacchetti insdhall
psc-package install
cd ../../

cd 21-Hello-World/07-Type-Level-Programming/
pwd
psc-package install
cd ../../

cd 21-Hello-World/08-Application-Structure/
pwd
psc-package install
cd ../../

cd 22-Projects/
pwd
npm install benchmark
spacchetti insdhall
psc-package install
cd ../

echo "... Finished ...."
