# About

This directory contains changelog entries for work that has not yet been
released. When a release goes out, these files will be concatenated and
prepended to `CHANGELOG.md` in a new section for that release.

## For Maintainers

See https://github.com/JordanMartinez/purescript-up-changelog for details of this process.

## For Contributors

When making a new PR, do the following steps. Each is described in the sections that follow:
1. Add a new file to this directory where the file name follows the naming convention described below
1. Fill that file with the proper content

To ensure you're doing it correctly, see the [Checklist](#checklist)

### File Naming Convention

The file should be named `{PREFIX}_{SLUG}.md`.

`{PREFIX}` is one of the following:
* `breaking`: for breaking changes
* `feature`: for new features
* `fix`: for bug fixes
* `internal`: for work that will not directly affect users of the project
* `misc`: for anything else that needs to be logged

`{SLUG}` should be a short description of the work you've done. The name has no
impact on the final CHANGELOG.md.

Some example names:
* `fix_issue-9876.md`
* `breaking_deprecate-classes.md`
* `misc_add-forum-to-readme.md`

### File Contents

The contents of the file can be as brief as:

```markdown
* A short message, like the title of your commit
```

Please remember the initial `*`! These files will all be concatenated into
lists.

If you have more to say about your work, indent additional lines like so:

``````markdown
* A short message, like the title of your commit

  Here is a longer explanation of what this is all about. Of course, this file
  is Markdown, so feel free to use *formatting*

  ```
  and code blocks
  ```

  if it makes your work more understandable.
``````

You do not have to edit your changelog file to include a reference to your PR.
The `CHANGELOG.md` updating script will do this automatically and credit you.

### Checklist

Use this checklist to help you remember to do everything described above.

- [ ] A new file has been added to `CHANGELOG.d`
- [ ] The file name starts with one of the `{PREFIX}` values above.
- [ ] The file's content does not reference the PR number that introduces it
- [ ] The file's first line (i.e. title line) starts with `* ` followed by a short description
- If the file contains content after the first line (i.e. body part):
    - [ ] the file has a blank line separating the title line from the body part
    - [ ] each line in the body part is indented by at least two spaces
