# Type Classes

## Relationships

This SVG file (WIP, but still helpful) shows the relationships between the type classes (inheritance hierarchy, dual relationships, usage frequency, and package location) throughout the ecosystem:

![typeclass-relationships](./Type-Class-Relationships.svg "Type Class Relationships")

## Functions

There is also an Excel file ([Type-Class-Functions.xlsx](./Type-Class-Functions.xlsx)) that documents the functions of said type classes using a chart like so (**Note: the following chart is long-vertically and short-horizontally to reduce horizontal scrolling. In the real chart, this is inverted**):

| | Example1 | Example2
| - | - | - |
| package<br>(the 'purescript-' prefix is omitted, so 'prelude' is really 'purescript-prelude') | prelude | prelude
| Type class name | Functor | Functor
| Function Definition<br>(Either defined in the initial type class (I) or dervied using that function (D)) | I | D
| Alias symbol<br>(If no symbol exists, then there is no alias) | <$> | $>
| Alias infix direction & precedence<br>(`direction` is either left (L) or right (R)<br>`precedence` is 1..9) | L 4 | L 4
| Type Parameter<br>(what the type that follows the type class (e.g. `Functor f`)) | f | f
| Function Name | map | voidLeft
| Constraints<br>(These usually appear in derived functions, but may also appear in initial functions) | | Functor f
| Return type | f b | f b
| Arg 1 | (a -> b) | f a
| Arg 2 | f a | a
| ...   | ... | ... |
| Arg N | ... | ... |

## Laws

TODO
