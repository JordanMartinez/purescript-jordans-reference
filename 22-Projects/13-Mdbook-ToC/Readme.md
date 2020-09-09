# Build commands

```bash
spago bundle-app --main ToC.ReaderT.Main --to dist/mdbook-toc.js
```

```bash
node 22-Projects/13-Mdbook-ToC/dist/mdbook-toc.js -r "." -o "./SUMMARY.md" -s "./mdbook/Summary-header.md" -m "./mdbook/code" -p "../.."
```
