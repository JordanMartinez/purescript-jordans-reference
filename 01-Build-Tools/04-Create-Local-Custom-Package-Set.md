# Create Local Custom Package Set

I'm writing this because I finally came across a situation where I needed a package via `psc-package` and it was not already included in the default package-set.

Thus, here's the steps I took to make it work:
```bash
# Assuming I'm in the top-level folder of the project
# that needs the additional library...

# 1. Create the necessary directory for the new local package set
#      (using the package set name "custom-set")
mkdir -p .psc-package/custom-set/.set

# 2. Change directory into the '.set' directory
cd .psc-package/custom-set/.set

# 3. Download the default package-set (if that's what you need) and output
#      it to 'package.json'
wget -O packages.json https://raw.githubusercontent.com/purescript/package-sets/master/packages.json
```

4. Look up the library you need using Pursuit and determine
    - the version you need
    - which packages it uses as its dependencies
    - the git repo

5. Modify `packages.json` to include the new library using this format:
```json
"libraryName": {
  "dependencies": [
    "dependency1",
    "dependency2",
    "dependency"
  ],
  "repo": "https://github.com/user/libraryName.git",
  "version": "vMajor.Minor.Patch"
}
```
6. Remove any unneeded listings (the less there are, the faster the `psc-package verify` command will go)
7. Save the `packages.json` file
8. Change directory back to the top-level folder: `cd ../../..`
9. Update your psc-package.json file to refer to the local package set. If your file path includes spaces (e.g. ` `), you can escape them using `\u0020` (e.g. `path/to/My File/` = `path/to/My\u0020File/`). Note: the `set` field must be the same name as the `custom-set` part of `.psc-package/custom-set/.set`. Otherwise, this will fail:
```json
{
  "name": "my local custom set",
  "set": "custom-set",
  "source": "file:///home/user/path-to-local-project/.psc-package/custom-set/.set/packages.json",
  "depends": [
    "library1",
    "library2",
    "library3"
  ]
}
```
10. Verify the packages (this will take a few minutes, so do something else while it runs)
```bash
psc-package verify
```
Finished. Now you can use the custom local package set.
