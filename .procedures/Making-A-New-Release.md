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
