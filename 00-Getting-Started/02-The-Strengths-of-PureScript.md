# The Strengths of PureScript

In this file, I'll cover what some of the tradeoffs PureScript makes are and why they are good. These ideas will be further explained in the "FP Philosophical Foundations" folder that appears later in this repository.

## Strongly Adheres to the Functional Programming Paradigm

- [A Secret Weapon for Startups -- Functional Programming?](https://www.ramanan.com/personal-blog/2019/2/25/functional-programming-and-venture-capital)
- Paradigm shifts, such as the one demonstrated by this video using C++, are what enable programs with less problems: [Logging a function's name each time it is called: migrating an "object-oriented paradigm" solution to an "functional paradigm" solution](https://www.youtube.com/embed/i9CU4CuHADQ?start=540). As will be explained later, this is what is known as the "Writer Monad."
- [Object-oriented "design patterns" in FP languages](http://blog.ezyang.com/2010/05/design-patterns-in-haskel/) are often just functions in disguise. Rather than learning the 20 different design patterns, one can learn how functions work and can be used to create really beautiful concepts and solutions.
- [Functional Architecture: The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0). To summarize this video, FP languages force you to structure your code in a way that makes it:
    - easy to test in an unbiased way (Can I prove that the logic/algorithm that solves the business problem is correct and works according to the specification despite any programmer's laziness or lack of foresight in thinking of a possible scenario where the code could fail?)
    - easy to add/change/remove a "backend" to account for trends, new insights, or faster code (Without introducing a new bug or deleting a current feature, can I switch from Company A's database to Company B's database without rewriting more than 30 lines of code?)
    - unconcerning to allow a new developer to work on the code, knowing that he/she cannot screw up anything major (Can the Lead/Senior Developer take the weekend off and return, knowing that it's extraordinarily difficult for developers with little experience to break something?)

## Powerful Static Type System

- This video explains how a type system with `algebraic data types` comes with a number of benefits (note: it uses a different syntax than PureScript: [Domain Modeling Made Functional](https://www.youtube.com/watch?v=Up7LcbGZFuo). To summarize it, `algebraic data types`
    - allow you to model a domain at a 1-to-1 ratio
    - make impossible states impossible
    - become your always-up-to-date UML diagrams
    - make it easy for new developers to learn how the code is structured
    - guide how business logic should be implemented
- The PureScript compiler infers most of your types for you. For those who are curious and want to understand how that works, see this video: [Type Inference From Scratch](https://www.youtube.com/watch?v=ytPAlhnAKro)
- The compiler (via its warning and error messages) is your friend, not your enemy. It
    - prevents you from releasing bug-filled code to a customer. (Can I guarantee that the code "just works" or cannot be built at all?)
    - forces you to handle most errors correctly the first time rather than permit you to throw them under the rug because you are lazy (Can I guarantee all possible errors will not create future problems that lead to short-term hard-to-understand code that rarely gets cleaned up and ultimately costs the company more time to fix than if it had just been written correctly the first time?)
    - helps you figure out how to implement functions correctly via "Typed Holes" (explained later in the `Syntax` folder)
- This video explains how a type system with `type classes` allow one to re-use "dumb old data structures" (i.e. `algebraic data types`) rather than create many new data structures that differ only one slight way: [Type Classes vs the World](https://www.youtube.com/watch?v=hIZxTQP1ifo). To summarize it, `type classes`
    - allow you to write declarative code ("this is what will be true") rather than imperative code ("this is how to make truth true (hopefully, you got it right)")
    - enables the compiler to infer runtime code

## Immutable Persistent Data Structures by Default

In PureScript, immutable data structures are the default rather than being "opt-in." In most other languages, mutable data structures are the default with immutable ones being "opt-in."

Immutable data structures are
- easier to reason about because the value never changes
- are always thread-safe, preventing many typical issues with concurrency
- can be as performant as mutable data structures in most cases

## Multiple Backends with Easy Foreign Function Interface

Most languages have their own backend.
- Javascript is compiled and run via a Javascript engine.
- Java compiles to bytecode that can be run on a Java Virtual Machine.
- Python gets compiled into bytecode that is then interpreted.

PureScript does not have a backend. Rather, it's source code can be compiled to other languages. While JavaScript is the focus, [PureScript compiles to other languages besides JavaScript](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md). Thus, writing one library in PureScript can work in multiple languages, and one can choose the backend (or a combination of them) that best solves their problem.

Caveat: PureScript's support for non-Javascript backends is still a work-in-progress. In future releases, they will be getting first-class support.

This backend-independent nature of PureScript makes "Foreign Function Interface" very clean. At various times, Language X needs to use code from another language, Language Y. For code written in one language to use code written in another language, there needs to be a "Foreign Function Interface" or FFI.

Many languages' FFI can be difficult to work with. Language X made various language tradeoff decisions that are different than Language Y. Getting two languages to work together is difficult to say the least. However, PureScript's FFI is very easy because PureScript already compiles to that language.

If you are compiling PureScript to Javascript, you can still write JavaScript as FFI for PureScript. This makes it possible to wrap Javascript libraries on which you heavily depend. It also enables one to easily migrate from some other language or framework (e.g. TypeScript, Angular, etc.) to PureScript in a modular, piece-by-piece fashion
