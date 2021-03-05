# Continuous Integration

## GitHub Actions - `Bower`-based

```yml
name: CI

on:
  push:
    branches: [master]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: purescript-contrib/setup-purescript@main

      - uses: actions/setup-node@v1
        with:
          node-version: "12"

      - name: Install dependencies
        run: |
          npm install -g bower
          npm install
          bower install --production
      - name: Build source
        run: npm run-script build

      - name: Run tests
        run: |
          bower install
          npm run-script test --if-present
```

## GitHub Actions - `Spago`-based

```yml
name: CI

on:
  push:
    branches: [master]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Set up PureScript toolchain
        uses: purescript-contrib/setup-purescript@main

      - name: Cache PureScript dependencies
        uses: actions/cache@v2
        with:
          key: ${{ runner.os }}-spago-${{ hashFiles('**/*.dhall') }}
          path: |
            .spago
            output

      - name: Set up Node toolchain
        uses: actions/setup-node@v1
        with:
          node-version: "12.x"

      - name: Cache NPM dependencies
        uses: actions/cache@v2
        env:
          cache-name: cache-node-modules
        with:
          path: ~/.npm
          key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package.json') }}
          restore-keys: |
            ${{ runner.os }}-build-${{ env.cache-name }}-
            ${{ runner.os }}-build-
            ${{ runner.os }}-

      - name: Install NPM dependencies
        run: npm install

      - name: Build the project
        run: npm run build

      - name: Run tests
        run: npm run test
```
