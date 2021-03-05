# Internal Modules

Modules that end with `Internal` are modules that one shouldn't use in most cases. They tend to provide access to the "guts" of things without the same guarantees or safety as non-`Internal`modules. However, they can be necessary when one module needs access to something (e.g. for performance reasons) that must exist in another module.

See these links for more info:
- [SO answer](https://stackoverflow.com/a/9191622)
- [SO answer](https://stackoverflow.com/a/9198453)
- [PR concerning the `NonEmptyString` constructor being exposed](https://github.com/purescript/purescript-strings/pull/130)
- [Reddit thread](https://www.reddit.com/r/haskell/comments/b4n87p/what_to_make_internal/)
