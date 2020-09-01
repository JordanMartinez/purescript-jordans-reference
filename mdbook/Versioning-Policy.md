# Versioning Policy

The below versioning policy was created to abide by the following principles:

### Principles

- **Indicate PS version:**
    - The release should indicate which major PureScript version is being used for the library. This helps one know whether the work is still up-to-date.
- **Provide "stable" versions...**:
    - Readers of a given version should be able to read and bookmark files without worrying about those files/links breaking due to changes in its name (via renaming/reordering files, headers in files, etc.)
    - Older versions should be available via `git tag`.
- **...without restricting developer creativity**:
    - I should be able to continue writing new content and re-ordering things without concern
- **Load the latest release:**
    - This repo should show the latest release version of this project, not the one on which I'm working. In other words, the default branch should coincide with the last release.
- **Lessen maintenance as much as possible:**
    - There should only be two branches, `latestRelease` and `development` since a branch name like `master` is overloaded with connotations. Those who want to read older versions can checkout a tag.
    - I currently will not hyperlink to other files within this project until either a `1.0.0` release is made or I find a way to automate that.

### Release Syntax and Explanation

`ps-[purescript's major release]-v[Major].[Minor].[Patch]` where
- purescript's major release means
    - Normally, this would be `1.x.x`, but we don't yet have a `1.0` release yet. Thus, it is currently `0.13.x`
    - `x` is a placeholder for the latest minor/patch release.
- major change means
    - a file/folder name has changed, so that bookmarks or links to that file/folder are now broken
    - files/folders have been modified, so that one is recommended to re-read the modified parts
    - a dependency (e.g. PureScript, Spago, etc.) was updated to a breaking change release
- minor change means
    - a file's contents have been modified/updated to such a degree that one is recommended to re-read the modified parts- Read through these links about learning:
    - a file's header name has changed, so that bookmarks or links to that header/section are now broken
    - Spago was updated to a minor release
- patch means
    - additional files/folders have been added without breaking links
    - a file's contents have been modified/updated to a minor degree that one could re-read the modified parts but is not likely to benefit much from it.
    - a file's contents have been slightly updated (typos, markdown rendering issues, etc.)
