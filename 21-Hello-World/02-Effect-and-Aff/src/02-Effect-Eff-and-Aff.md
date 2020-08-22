# Effect, Eff, and Aff

## Some History

Before the `0.12.0` release, the `Effect` monad used to be called `Eff`.

In short, the decision was made to drop `Eff`'s "extensible effects". Presumably, to prevent code breakage, `Eff` and package location in imports was unchanged. Rather, it can now be found in the [purescript-eff](https://pursuit.purescript.org/packages/purescript-eff/3.2.1) package. Its replacement was called `Effect`.

(You can read more about the decision making process [here](https://purescript-resources.readthedocs.io/en/latest/eff-to-effect.html). If one is curious about `Eff`, read through [the related section](https://book.purescript.org/chapter8.html#the-effect-monad-1) in the "Purescript by Example" book as it won't be covered here.)

## Aff

The `Aff` monad was introduced and in use before this decision was made. Thus, history explains the naming behind `Aff`: if `Eff` was for synchronous **eff**ects, then `Aff` is for **a**sychronous e**ff**ects.

`Aff` will be covered in more depth in the upcoming files.
