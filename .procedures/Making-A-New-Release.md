Steps to follow for making a new release:
1. Open a release PR and explain various changes made
2. Use the GitHub's diff in the PR to look over everything and ensure all work is done
    - If not, push any other changes
3. Re-generate the ToC and push the change (no further work can be done at this point)
4. Wait for CI to pass
5. Merge the PR
6. Fetch the latest changes to include the 'PR merge' commit
7. Create a git tag at the current spot
8. Push the git tag to the repo
9. Draft a new release using the tag and refer to release PR
