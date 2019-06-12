# Halogen

Since I'm already somewhat familiar with it, I decided to implement the web-based user interface using Halogen.

Halogen's current stable version is `v4.0.0`. However, they are on the verge of releasing `v5.0.0`. They haven't made a full release yet because the docs are still lacking, not the functionality or stability of the release, which is already being used in production.

With that in mind, one could learn Halogen v4, but I don't see why one would as Halogen v5 is much nicer to work with. In this repository, we'll be using Halogen v5 in our examples.

## Learn Halogen v5 (stable, unreleased)

I've created a learning repository similar to this one that explains Halogen's latest release, `v5.0.0-rc.4`, in [`learn-halogen`](https://github.com/jordanmartinez/learn-halogen).

## Learn Halogen v4 (stable, released, but will be outdated soon)

If one doesn't want to learn Halogen v5, then refer to the work I created below.

### Halogen Guide

Halogen has a lot of generic/polymorphic types. So, read through my "bottom up" approach first, which introduces these types one at a time. Then, read through the "top-down" approach alongside of the flowchart:
- [My "bottom-up" explanation](https://github.com/slamdata/purescript-halogen/tree/1e13c931f242f0ea72a92ed1b560110833ab2f1c/docs/v2). I stopped at a certain point because of the currently not-well-documented API changes they are making in the upcoming `5.0.0` release.
- [Their "top-down" approach](https://github.com/slamdata/purescript-halogen/tree/v4.0.0/docs).
- [The flowchart I made](https://github.com/slamdata/purescript-halogen/issues/528#issuecomment-431885061) that helps one see how the code actually works. While this flowchart is highly accurate, the issue in which it is contained explains more context on the parts where I misunderstood something.
