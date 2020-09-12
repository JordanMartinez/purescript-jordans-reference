Steps to follow for making a new release:
1. Open a release PR as a "Draft PR" and explain various changes made
2. Use the GitHub's diff in the PR to look over everything and ensure all work is done
    - If not, push any other changes
3. Re-generate the ToC and push the change (no further work can be done at this point)
4. Re-generate the CHANGELOG.md file via `./.generateChangelog.sh TOKEN`
4. Convert the "Draft PR" into a real PR
5. Wait for CI to pass
6. Merge the PR
7. Fetch the latest changes to include the 'PR merge' commit
9. Create a git tag at the current spot
9. Push the git tag to the repo
10. Draft a new release using the tag and refer to release PR
11. Run the following script

```bash
cd 22-Projects/13-Mdbook-ToC
spago bundle-app --main ToC.ReaderT.Main --to dist/mdbook-toc.js
cd ../..
node 22-Projects/13-Mdbook-ToC/dist/mdbook-toc.js -r "." -o "../purescript-jordans-reference-site/src/" -s "Summary-header.md"

cd ../purescript-jordans-reference-site
mdbook build
git add *
git commit -m "Update book to <release>"
```
