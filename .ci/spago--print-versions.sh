#!/bin/sh

# Crudely lists the versions of the installed packages.

echo ""
echo "Versions of Installed Packages"
echo "=============================="

echo "Node:"
node --version

echo "NPM:"
npm --version

echo "Purescript:"
purs --version

echo "Spago:"
spago version

echo "=============================="
echo ""
