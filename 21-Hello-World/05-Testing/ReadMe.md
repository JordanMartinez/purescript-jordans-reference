# Testing

## Test Conventions

Normally, the code you test is found in the `src` folder and its corresponding test file is in the `test` folder with the following naming scheme for modules:
```purescript
-- in 'src/MyModule.purs' file
module MyModule where
-- imports and source code

-- in 'test/MyModule.purs' file
module Test.MyModule where
-- imports and test code

-- in 'src/MyModule/SubModule.purs' file
module MyModule.SubModule where
-- imports and source code

-- in 'test/MyModule/SubModule.purs' file
module Test.MyModule.SubModule where
-- imports and test code
```

## Breaking Conventions

This folder will place both source and test code in the `test` folder to prevent you from going back and forth between the source file and its corresponding test file.

## Libraries Used

This folder will cover testing using three libraries. Nested bullet points indicate other libraries into which one should investigate:
- [Spec](https://pursuit.purescript.org/packages/purescript-spec/3.1.0) - Unit Testing / Test Suites (works but doesn't seem to be active anymore... See [this issue](https://github.com/owickstrom/purescript-spec/issues/53#issuecomment-332284168))
    - [spec-discovery](https://pursuit.purescript.org/packages/purescript-spec-discovery/2.0.0)
    - [spec-xunit](https://github.com/owickstrom/purescript-spec-reporter-xunit/tree/master/docs)
    - [spec-mocha](https://pursuit.purescript.org/packages/purescript-spec-mocha/3.0.0)
    - [spec-quickcheck](https://pursuit.purescript.org/packages/purescript-spec-quickcheck/3.0.0)
- [Quick Check](https://pursuit.purescript.org/packages/purescript-quickcheck/5.0.0) - Property Testing
- [Quick Check Laws](https://pursuit.purescript.org/packages/purescript-quickcheck-laws/4.0.0) - Property Testing for the core type classes via type-level programming

## Running the Tests

See each folder for instructions
