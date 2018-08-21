# Build Tools

This folder accomplishes the following:

- [x] Explain the various tools used throughout the ecosystem and their usages/differences:
    - [x] Document the differences between `Bower` and `psc-package` dependency managers
    - [ ] Document the difference between `pulp` and `purs-loader` build tools
- [x] Document the CLI options for the most popular tools (e.g. purs, pulp, psc-package, etc.)
- [x] Document a typical workflow from project start to finish (creation, fast-feedback development, initial publishing, 'bump' publishing)

## Overview of Tools

| Name | Type/Usage | Comments | URL |
| - | - | - | - |
| purs | PureScript Compiler | Used to be called `psc` | -- |
| psvm-js | PureScript Version Manager | -- | https://github.com/ThomasCrevoisier/psvm-js
| bower | Dependency Manager | -- | https://bower.io/ |
| psc-package | Dependency Manager | -- | https://github.com/purescript/psc-package |
| pulp | Build Tool | | Front-end to `purs`. Builds & publishes projects | https://github.com/purescript-contrib/pulp |
| pscid | `pulp --watch build` on steroids | Seems to be a more recent version of `psc-pane` and uses `psa` | https://github.com/kRITZCREEK/pscid
| psa | Pretty, flexible error/warning frontend for `purs` | -- | https://github.com/natefaubion/purescript-psa

The following seem to be deprecated or no longer used:

| Name | Type/Usage | Comments | URL |
| - | - | - | - |
| psc-pane | Simplistic auto-reloading REPL-based IDE | No longer used? Last updated 1 year ago... | https://github.com/anttih/psc-pane
| gulp-purescript | Gulp-based Build Tool | No longer used? Last updated 1 year ago... | https://github.com/purescript-contrib/gulp-purescript |
| Purify | -- | Deprecated in light of psc-package | -- |

From here, one should read through the rest of this folder's Markdown files in numerical order.
