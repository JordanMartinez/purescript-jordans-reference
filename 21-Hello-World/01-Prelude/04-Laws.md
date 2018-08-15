# Laws

This is a cheatsheet for various terms used to describe laws. Not all of these will appear in Prelude and some may be explained in a type class' definiton. Still, it helps to be aware of them:

| Law | Definition | Example |
| - | - | - |
| reflexive | x function x == true | 3 == 3
| irreflexive | x function x == false | 3 == 4
| coreflexive | if (x function y) then (x == y) | if (3 <= 3) 3 == 3
| symmetric | if (x function y) then (y function x) | TODO
| antisymmetric | if (x function y && y function x) then (x == y) | a <= b && b <= a THEN a == b
| asymmetric | if (x function y) then (y function x == false) | given `a < b`, then `!(b < a)`; (assymetric = anti-symmetric & irreflexive)
| transitive | if (x function y && y function z) then (x function z) | given `a == b && b == c`, then `a == c` <br> given `a <= b <= c`, then `a <= c`

## Other laws

| Law | Definition | Example |
| - | - | - |
| trichotomous | exactly one of these three are true: <ul><li>x function y</li><li>y function x</li><li>x == y</li></ul> | true: `1 < 3` <br> false: `3 < 1` <br> false: `1 == 3`
| Right Euclidean | if (x function y && x function z) then (y == z) | TODO
| Left Euclidean | if (y function x && z function x) then (y == z) | TODO
| Euclidean | if something is both right and left Euclidean | TODO
