Original credit: @paf31 / @kritzcreek

Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/23.markdown

Changes made:
- use meta-language to explain syntax and give a very simple example

Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
<hr>
Sometimes, when writing code, we sort of know what we should write
but not all of what we should write.

In such cases, we can use a hole and the compiler might be able
to suggest which function / value we should use:

syntax:
`?placeholderName`

Put this in place of the function/value whose type you're unsure of

For example, this code...

```purescript
module Syntax.TypeDirectedSearch where

import Prelude

intToString :: Int -> String
intToString x = ?function x
```

... outputs this compiler error (but a helpful one)...

```
in module Syntax.TypeDirectedSearch
at src/02-Values-and-Functions/31-Type-Directed-Search.purs line 23, column 17 - line 23, column 26

  Hole 'function' has the inferred type

    Int -> String

  You could substitute the hole with one of these values:

    Data.Monoid.mempty                     :: forall m. Monoid m => m
    Data.Show.show                         :: forall a. Show a => a -> String
    Syntax.TypeDirectedSearch.intToString  :: Int -> String

  in the following context:

    x :: Int


in value declaration intToString

See https://github.com/purescript/documentation/blob/master/errors/HoleInferredType.md for more information,
or to contribute content related to this error.
```
