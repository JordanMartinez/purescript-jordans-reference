#!/usr/bin/env bash

# This file assumes the following things are true:
# - `./procedures/mdbook-toc.js` has been built via the `Projects/Mdbook-ToC`
#       project.
# - `../purescript-jordans-reference-site` is a git repo and exists
# - `../purescript-jordans-reference-site/src` folder exists
# - `../purescript-jordans-reference-site/src/Summary-header.md` file exists

# Regenerate `mdbook`'s source content
node .procedures/mdbook-toc.js -r "." -o "../purescript-jordans-reference-site/src" -s "Summary-header.md" -t ".ci,.git,.github,.procedures,.travis,output,book,mdbook,old-changelogs"

cd ../purescript-jordans-reference-site

# Regenerate the book
mdbook build

# Deploy it
git add *
git commit -m "Update book to $1"
git push
