# PureScript Type Checker

**Disclaimer: all of the content written here is my interpretation of various papers, articles and other such sources. All of this might be wrong in whole or in part.**

This folder's content is currently a work-in-progress! The breaking changes policy does not apply to this folder's contents.

This work is my attempt at explaining PureScript's type system from the bottom up by
- providing an explanation of the academic theory of type systems by
    - building an intuition for a basic static type system
    - identifying a problem within that system
    - solving that problem with a solution
    - looping until a powerful modern type system emerges.
- and then showing how/where PureScript's type checker follows and diverges from theory.

This work uses LaTeX to render various expressions, equations, and visuals. Unfortunately, GitHub does not render LaTeX, so this document will need to be read via a different markdown renderer.

## Understanding LaTeX

If you are unfamiliar with LaTeX, see the below links for help.

- [Using Latex in Markdown](https://ashki23.github.io/markdown-latex.html#latex)
- [List of LaTeX Symbols](https://latex.wikia.org/wiki/List_of_LaTeX_symbols)

## Sources Used

While I will not cite from them directly because this is not an academic paper, this work was written based on my understanding of the following sources:
- [Haskell Type System (YouTube playlist)](https://www.youtube.com/watch?v=nAlyU4OPa40&list=PLLMfIaSUuqCPpR8N5uXlp0s4Byts2v51R) - a beginner-friendly explanation that does a lot of what I'm trying to do here
- [The Hindley-Milner Type Inference Algorithm](https://steshaw.org/hm/hindley-milner.pdf) - an explanation behind some of the origins of lambda calculus and issues encountered that led to typed lambda calculus and an overview of unification and Algorithm W.
- [Generalizing the Hindley-Milner Type Inference Algorithm](https://www.cs.uu.nl/research/techreps/repo/CS-2002/2002-031.pdf) - shows that delaying constraint solving until later enables order-independent constraint solving that type checks more programs and produces better errors.
