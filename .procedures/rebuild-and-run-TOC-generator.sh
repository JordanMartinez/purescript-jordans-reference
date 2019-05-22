#!/bin/bash

# Run this from the root directory of the repository:
# ./.procedures/rebuild-and-run-TOC-generator.sh nextTag

# Capture the tag that gets passed in as an argument
TAG=$1

# Change into projects directory
cd 22-Projects/

# Build the program
spago bundle-app --main ToC.ReaderT.Main --to dist/table-of-contents/ghtoc.js

# Change directory to be at the root directory again.
cd ../

# Then re-generate the ToC file
echo "Now regenerating the ToC file."
node 22-Projects/dist/table-of-contents/ghtoc.js -r . -o ./table-of-contents.md --github-reference $TAG --skip-url-verification
echo "Finished creating the ToC file."
