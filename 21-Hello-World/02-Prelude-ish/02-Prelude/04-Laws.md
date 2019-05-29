# Laws

This is a cheatsheet for various terms used to describe laws. Not all of these will appear in Prelude and some may be explained in a type class' definition. Still, it helps to be aware of them:

| Law | Definition | Example | Explanation of example |
| - | - | - | - |
| reflexive | x function x == true | `x <= y` | `a <= a` is true for any number `a` you pick |
| irreflexive | x function x == false | `x < y` | `a < a` is false for any number `a` you pick |
| coreflexive | if (x function y) then (x == y) | `(x <= 15) && (x == y)` | given `(a <= 15) && (a == b)` , then `a == b`<br>(the converse is not true, though!) |
| symmetric | if (x function y) then (y function x) | `x == y` | given `a == b`, then `b == a` |
| antisymmetric | if (x function y && y function x) then (x == y) | `x <= y` |  given `a <= b && b <= a`, then `a == b` |
| asymmetric | if (x function y) then (y function x == false) | `x < y` | given `a < b`, then `!(b < a)`<br>(asymmetric = anti-symmetric + irreflexive) |
| transitive | if (x function y && y function z) then (x function z) | `x == y`, `x <= y` | given `a == b && b == c`, then `a == c` <br> given `a <= b && b <= c`, then `a <= c` |
