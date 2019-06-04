Steps to follow for upgrading this project to a new compiler release:
1. Install the new version of PureScript locally: `npm i -g purescript@<version>`
2. Use Atom's Project "Find and Replace All" search to
    - replace all references of prior release version with next one (e.g. `0.12.x` -> `0.12.y`)
        - Use "0\.12\.5(?!-)" regex pattern
    - replace all versions of old package sets with newer ones
        - Run `spago package-set-upgrade` in each folder that uses spago
3. Run `for-each-folder--install-deps-and-compile.sh` locally to ensure code works
4. Push changes
