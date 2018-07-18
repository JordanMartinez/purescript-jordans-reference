## Which dependency manager should you use: Bower or PSC-Package?

TODO

## Using Semantic Versioning 2.0

- [NPM SemVer calculator](https://semver.npmjs.com/)

## [Bower.json Spec](https://github.com/bower/spec/blob/master/json.md#bowerjson-specification)

## Build commands

[See Pulp's ReadMe](https://github.com/purescript-contrib/pulp)

- Create a new project:
    - Bower - `pulp init projectName`
    - PSC Package `pulp init --psc-package projectName`
- Launch the REPL: `pulp repl`
- Build project:
    - When developing: `pulp --watch build --to fileName.js` (add `--psc-package` after `pulp` to use that DM
    - When producing: `pulp build --to fileName.js`
- Run project: `pulp run -- command-line-arg1 command-line-argN`
- Test project: `pulp test` or `pulp --watch test`
- Build docs:
    - Exclude Dependencies: `pulp docs`
    - Include Dependencies: `pulp docs [--with-dependencies]`
    - Change outputted format: `pulp docs -- --format html`
- Bundle project:
    - When developing: `pulp --watch browserify --to fileName.js`
    - When producing: `pulp browserify --optimize --to fileName.js`

### A new project (using Bower): from start to finish:
````bash
# create project
pulp init projectName

# after setting up its dependencies
npm install
bower install

# now start developing

# TODO: immediate feedback (not sure if this is correct yet...)
pulp --watch build --to development/fileName.js

# add a new dependency
bower install --save [dependency]

# update all dependencies
bower update

# build project
pulp browserify --optimize --to production/fileName.js

# bump project version
pulp version [major | minor | patch]

# publish it to Github, register it on Bower's registry, upload docs to Pursuit
pulp publish
````