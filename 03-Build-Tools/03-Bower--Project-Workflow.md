# Bower: From Start to Finish

**Warning:** This code hasn't been checked. Most of it should be correct, but some parts might be wrong.

## Create the project

One of two ways
```bash
pulp init
```

## Install dependencies

```bash
# Need to install NPM packages and initialize them
npm install npm-package1 npm-package2
npm install
bower install package1 package2 --save
bower install
```

Due to the Bower registry being deprecated, there are some packages that will have to be installed using a longer name format because the library couldn't be uploaded into the Bower registry. While the registry is deprecated, `bower` can still download the files from GitHub if one uses this longer name format. Harry described how one could do that here and also mentions `bower link` as another possible option:

> in `bower.json`, instead of writing...
>> ```json
>> "dependencies":{
>>    "purescript-some-library":"^0.1.0"
>> }
>> ```
>
> ... you can write
>> ```json
>> "dependencies": {
>>    "purescript-some-library":"https://github.com/githubUser/purescript-some-library#my-branch"
>> }
>> ```
>
> you can also use `bower link` which is similar but gives you a bit more flexibility


### Write the Code

```bash
# Open the REPL to play with a few ideas or run simple tests
pulp repl

# Automatically re-build project whenever a source file is changed/saved
pulp --watch --before 'clear' build

# Automatically re-test project whenever a source/test file is changed/saved
pulp --watch --before 'clear' test

# Build a developer version
esbuild --bundle --outfile dist/fileName.js output/Main/index.js # if program

# Run the program and pass args to the underlying program
pulp run -- arg1PassedToProgram arg2PassedToProgram
```
### Publish the Package for the First Time

See this [help page for authors](https://pursuit.purescript.org/help/authors) on Pursuit. Its instructions are more authoritative than what follows.

```bash
# Build the docs
pulp docs -- --format html
# Then read over them to insure there aren't any formatting issues or typos

# Set the initial version
pulp version v0.1.0

# Publish the version
pulp publish
```

### Publish a New Version of an Already-Published Package

```bash
# Build and check the docs
pulp docs -- --format html

# bump project version
pulp version major
pulp version minor
pulp version patch
# or specify a version
pulp version v1.5.0

# publish it
# Note: you may need to run this command twice.
pulp publish
```
