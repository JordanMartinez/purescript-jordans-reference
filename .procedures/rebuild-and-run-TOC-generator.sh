#!/bin/bash

# Run this from the root directory of the repository:
# ./.procedures/rebuild-and-run-TOC-generator.sh

# Change into projects directory
cd 22-Projects/

# Build the program
spago bundle --main Projects.ToC.Main --to dist/table-of-contents/ghtoc.js

# Change directory to be at the root directory again.
cd ../

# Then re-generate the ToC file
echo "Now running program"
node 22-Projects/dist/table-of-contents/ghtoc.js -r "." -o "./table-of-contents.md" --log-level "info"
echo "Finished creating the ToC file.
