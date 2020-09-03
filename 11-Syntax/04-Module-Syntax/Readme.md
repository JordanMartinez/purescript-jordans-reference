# Module Syntax

Self-explanatory

Due to the compiler being efficient and not wanting to import unused values/functions/etc., compiling this folder will emit a lot of warnings. If the warnings look like either of these two messages, they can be ignored:

First
```
Warning [current] of [total]:

  in module Syntax.Module.FullExample
  at src/11-Full-Module-Syntax.purs line 58, column 1 - line 58, column 37

    The import of module Module.SubModule.SubSubModule is redundant


  See https://github.com/purescript/documentation/blob/master/errors/UnusedImport.md for more information,
  or to contribute content related to this warning.
```
Second
```
Warning [current] of [total]:

  in module Syntax.Module.Importing
  at src/03-Basic-Importing.purs line 29, column 1 - line 29, column 58

    There is an existing import of ModuleDataType, consider merging the import lists


  See https://github.com/purescript/documentation/blob/master/errors/DuplicateSelectiveImport.md for more information,
  or to contribute content related to this warning.
```

## File Location Conventions

```purescript
-- a module named...
module Module1 where
-- imports and source code

-- ... should be located in the file...
-- src/Module1.purs

-- whereas

-- a submodule named...
module Module.SubModule.SubSubModule where
-- imports and source code

-- ... should be located in the file...
-- src/Module/SubModule/SubSubModule.purs
```

## Real World Naming Conventions

See [the Style Guide's section on Module Names](https://github.com/purescript/documentation/blob/master/guides/Style-Guide.md#modules)
