# Debugging

This folder helps you debug problems in your code by
- explaining some tips/tricks to use to help debug compiler errors
- forewarning about some potential misunderstandings
- helping you to read some compiler errors

## Running The Lessons

You should **NOT** use the REPL for these lessons.

Rather, you should use spago to run them using this syntax:
```bash
spago run --main Debugging.OverviewAPI
```

When compiling these examples, you will likely see a warning like below:
```
Warning found:
in module Debugging.CustomTypeErrors.TypeClassInstances
at src/03-Custom-Type-Errors/04-Type-Class-Instances.purs line 41, column 1 - line 41, column 23

  A custom warning occurred while solving type class constraints:

    No worries! This warning is supposed to happen!

    [Some warning message here...]


in value declaration warnInstance

See https://github.com/purescript/documentation/blob/master/errors/UserDefinedWarning.md for more information,
or to contribute content related to this warning.
```
This is supposed to happen, so don't be alarmed. When we hit that part of our lessons, we'll tell you how to remove the warnings so you can get rid of the "compiler noise."
