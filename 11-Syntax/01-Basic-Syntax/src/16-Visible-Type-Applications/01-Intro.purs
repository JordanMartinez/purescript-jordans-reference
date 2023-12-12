module Syntax.Basic.VisibleTypeApplications.Intro where
                                                                            {-
Visible Type Applications is a feature that only works completely 
as of PureScript 0.15.13. While it was supported earlier than that,
there were a few bugs that hindered its usage. The content in this file
and those that follow in this folder assume one is using PureScript 0.15.13.

Sometimes, using polymorphic code can be annoying
because the compiler cannot infer what type you want to use.                -}

polymorphicCode :: forall pleaseInferThisType. pleaseInferThisType -> Int
polymorphicCode _someValue = 1
                                                                            {-
problematicUsage :: Int
problematicUsage = polymorphicCode []

The above code is commented out because it will produce a compiler error.
The empty array is inferred by the compiler to have the type,
`forall a. Array a`. Because there are no elements within the
array, the compiler has no idea what the element type is. So, it infers it
to the most generic type it can be: `forall a. a`.

In this situation, we would need to tell the compiler what that type is
by doing one of two things:
- indicating what the input type of `polymorphicCode` is
- indicating what the element type of the empty array is


There's two ways to tell the compiler what the type should be 
when the compiler cannot figure it out.

The first way is to add a type annotation (usually after wrapping 
the expression in parenthesis). This is annoying to do because 
of the added parenthesis, two colons, and in some cases the need to
fully specify all the types of the function or value.                                               -}

usage_inputType :: Int
usage_inputType = (polymorphicCode :: Array String -> Int) []

usage_elemType :: Int
usage_elemType = polymorphicCode ([] :: Array String)
                                                                            {-
The second way is using "visible type applications".

Using `forall someType. someType -> Int` as an example, the 
`forall someType.` part is really a function. We could read the above as
"Given an argument that is a type (e.g. `String`) rather than a value 
(e.g. "foo"), I will return to you a function that takes a value of that type 
and produce a value of type `Int`."

"Visible Type Applications" are called thus because these type arguments
are applied to these kinds of functions, but these applications that were
previously invisible to the user are now made visible. Put differently,
the compiler would automatically apply these type arguments but without the
user's knowledge or input. Now, however, the user can also apply these type arguments.

Visible Type Applications (or VTAs for short) are opt-in syntax. 
They only work if one writes their `forall` part a specific way 
by adding a `@` character in front of the type variable name 
(e.g. `someType` becomes `@someType`).

Rewriting `polymorphicCode` to use this opt-in syntax, we get:                        -}

polymorphicCode2 :: forall @pleaseInferThisType. pleaseInferThisType -> Int
polymorphicCode2 _someValue = 1

-- And now we can use it by applying the type `String` to that type variable.
-- We apply the type by putting a `@` character in front of the type name.
usage2_example :: Int
usage2_example = polymorphicCode2 @String "bar"

-- In our original case of using a higher-kinded type (e.g. `Array Int`),
-- we need to wrap the type in parenthesis.

usage2_inputType :: Int
usage2_inputType = polymorphicCode2 @(Array String) []

-- Since `[]`'s inferred type is `forall a. Array a` rather than `forall @a. Array a`,
-- we cannot use VTAs to determine the element type.
-- This code is commented out because we'll get a compiler error.
--    usage2_elemType :: Int
--    usage2_elemType = polymorphicCode2 ([] @String))

-- Lastly, if we opt-in to this VTA syntax, we must either use it or not use it doesn't mean we have to use VTAs
-- to make the function work. The below code is valid

usage3 :: Int
usage3 = polymorphicCode2 true
