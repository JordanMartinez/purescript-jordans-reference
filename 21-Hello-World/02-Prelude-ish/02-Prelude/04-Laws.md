# Laws

This is a cheatsheet for various terms used to describe laws. Not all of these will appear in Prelude and some may be explained in a type class' definition. Still, it helps to be aware of them:

| Law | Definition | Example |
| - | - | - |
| reflexive | x function x == true | 3 == 3
| irreflexive | x function x == false | 3 == 4
| coreflexive | if (x function y) then (x == y) | if (3 <= 3) 3 == 3
| symmetric | if (x function y) then (y function x) | TODO
| antisymmetric | if (x function y && y function x) then (x == y) | given `a <= b && b <= a`, then `a == b`
| asymmetric | if (x function y) then (y function x == false) | given `a < b`, then `!(b < a)`<br>assymetric = anti-symmetric + irreflexive)
| transitive | if (x function y && y function z) then (x function z) | given `a == b && b == c`, then `a == c` <br> given `a <= b && b <= c`, then `a <= c`
