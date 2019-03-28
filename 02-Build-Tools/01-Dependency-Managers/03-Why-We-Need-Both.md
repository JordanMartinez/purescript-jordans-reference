# Why We Need Both

Think about what happens when a PureScript release is made that includes breaking changes.

Updating each library in the ecosystem to account for those breaking changes is similar to putting a plant inside a vase with colored water. The colored water will first enter its roots, then go up its branches, and finally appear in every leaf ([Kids' experiment explained with photos](http://www.teaching-tiny-tots.com/toddler-science-celery-experiment.html))

In our above analogy, the `purescript-prelude` library and other libraries with no dependencies are the "roots" of the ecosystem. As they get updated, the libraries that depend on them (i.e. the "branches") can now be updated. A "leaf" corresponds to a library which has no dependents.

A package set is immutable. Thus, one cannot add to the packaget set a package that has been updated to the new release unless all of the packages in the package set can also be updated.

During that transitionary time, `spago` cannot help. Rather, we must depend on `Bower` to slowly update each library to its new version that depends on transitive libraries that have been updated to new versions.

Again, `spago` is more suited for application developers and `bower` is more suited for library developers.
