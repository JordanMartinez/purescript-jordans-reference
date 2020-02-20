Steps to follow for upgrading Spago a new release:
1. Use Atom's Project "Find and Replace All" search to replace all references of prior release version with next one (e.g. `spago@0.13.0` -> `spago@0.14.0`)
2. Update the version reference in the `Getting Started/Install Guide.md` file
3. Update the mindmap file in `Build Tools/assets/CLI-Options--Spago.mm` to account for any changes in the CLI
4. Regenerate the SVG file using the mindmap file
3. Commit the changes and push to the `development` branch.
