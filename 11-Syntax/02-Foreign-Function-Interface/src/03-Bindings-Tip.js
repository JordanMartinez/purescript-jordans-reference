/*
When you are writing bindings to JavaScript,
the compiler will not pick up changes you make
to your FFI files unless it rebuilds the entire codebase.

So, it can be helpful to define your actual bindings
in one file and import and re-export them in this file
so that they are usable in PureScript.

Then, you can compile your code once and as long
as the arg number and types in PS don't change,
you can iterate on the FFI implementation
without having to recompile your code.
*/
export { otherBindings } from "../bindings/index.js";
