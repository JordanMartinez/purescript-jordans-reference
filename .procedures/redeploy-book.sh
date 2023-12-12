#!/usr/bin/env bash

# This file assumes the following things are true:
# - `./procedures/mdbook-toc.mjs` has been built (see https://github.com/JordanMartinez/purescript-mdbook-generator)
#       project.
# - `../purescript-jordans-reference-site` is a git repo and exists
# - `../purescript-jordans-reference-site/src` folder exists
# - `../purescript-jordans-reference-site/src/Summary-header.md` file exists
# - `mdbook` and `mdbook-mermaid` have been installed and are on your PATH: 
#    - https://github.com/rust-lang/mdBook/tree/master
#    - https://github.com/badboy/mdbook-mermaid

# Regenerate `mdbook`'s source content
node .procedures/mdbook-toc.mjs -r "." -o "../purescript-jordans-reference-site/src" -s "Summary-header.md" -t ".ci,.git,.github,.procedures,.travis,output,book,mdbook,old-changelogs,CHANGELOG.d"

cd ../purescript-jordans-reference-site

# Regenerate the book
mdbook build

# Deploy it
git add *
git commit -m "Update book to $1"
git push
