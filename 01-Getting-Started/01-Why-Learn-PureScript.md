# Why Learn PureScript?

All languages make tradeoffs in various areas and on various spectrums:
- learning curve
- abstractions
- syntax
- errors
- type systems
- etc.

The question is "Which combination of tradeoffs provides the most benefits in prioritized areas?" "Good" languages happen to select specific tradeoffs that make the language well-suited for specific problems. For example, Python is well-suited for creating dirty one-time-run scripts to do tedious work on a computer. While Python can be used to create financial or medical applications that need to be extremely fast and secure, it would be better to use a different language that is better suited for such a task, such as Rust.

PureScript has chosen tradeoffs that its developers think are the best for creating simple to complex front-end applications that "just work;" that are easy to refactor, debug, and test; and help make developers more productive rather than less.

It can be said that other front-end languages buy "popularity" at the cost of "power and productivity."
PureScript buys "power and productivity" at the cost of "popularity."

To fully answer "Why learn PureScript?" we must answer three other questions:
- Why one should use Javascript to build programs...
- ...but not write Javascript to build it...
- ...and write Purescript instead of alternatives

## Why one should use Javascript to build programs...

- The web browser is the new ["dumb terminal"](https://www.youtube.com/embed/YI34UIMgkxs?start=1762&end=1828) / platform-independent OS:
    - [What can web do today?](https://whatwebcando.today/)
- [Why Founders Should Start With a Website, Not a Mobile App](https://article.voxsnap.com/atrium/founders-should-build-website-not-mobile-app)
- The points mentioned in this article: [Learn Javascript in 2018](https://web.archive.org/web/20181201032915/https://medium.com/zerotomastery/learn-to-code-in-2018-get-hired-and-have-fun-along-the-way-b338247eed6a)

## ...but not write Javascript to build it...

- [JavaScript is a Dysfunctional Programming Language](https://medium.com/javascript-non-grata/javascript-is-a-dysfunctional-programming-language-a1f4866e186f)
- [Top 10 Things Wrong with JavaScript](https://medium.com/javascript-non-grata/the-top-10-things-wrong-with-javascript-58f440d6b3d8)
- [Why JavaScript Sucks](https://whydoesitsuck.com/why-does-javascript-suck/)

Some other ideas that are relevant:
- dynamic typing leads to errors that do not appear until after you have already shipped the code to your customers
- a linter is just a basic static type checker
- it is sometimes easier to write, read, and understand a 'safer language' that compiles to efficient Javascript than to write, read, and understand JavaScript itself (as the above articles show)

## ...and write Purescript instead of alternatives

**TL;DR**

- [The Power of Composition](https://youtu.be/vDe-4o8Uwl8?t=8)
- [Purescript: Tomorrow's Javascript Today](https://www.youtube.com/watch?time_continue=22&v=5AtyWgQ3vv0)
- [Code Reuse in PureScript: Functions, Type Classes, and Interpreters](https://youtu.be/GlUcCPmH8wI?t=24)
- [Phil Freeman's post: 'Why You Should Use PureScript'](https://gist.github.com/paf31/adfd15fbb1ac8b99fc68be2c9aca8427)
- PureScript's "Real World App"s
    - See the [Halogen version of 'Real World App'](https://github.com/thomashoneyman/purescript-halogen-realworld)
    - See the [React version of 'Real World App'](https://github.com/jonasbuntinx/purescript-react-realworld)
- [A Discourse pose describing some of the disadvantages of TypeScript and Elm when compared to PureScript](https://discourse.purescript.org/t/language-highlights/1471)

### Language Comparisons

For a full list of possible alternatives to JavaScript, see [CoffeeScript's wiki's list of 'Languages that compile to JavaScript'](https://github.com/jashkenas/coffeescript/wiki/List-of-languages-that-compile-to-JS)

**Note**: the below comparisons are still a WIP. To fully support this claim, it would help to compare each languages' various "overall rating" on various aspects. Unfortunately, since I'm not familiar with every other language mentioned, it's very difficult for me to do that. If you are familiar with such languages, consider opening an issue on this repo and discussing it with me.

In short, the below comparison will be biased towards PureScript and will not yet fairly represent the corresponding side in some situations. Consider this a starting point for your own research.

#### PureScript vs TypeScript

One of the main issues with JavaScript is a poor type system. Many errors aren't discovered until a person, usually a customer, runs the program. Many of these same errors could be detected and fixed before shipping code if one used a language with a better type system.

TypeScript seems to address this type safety issue. Just consider its name! However, a few people who are using PureScript now have said this about TypeScript: "You might as well be writing Javascript." TypeScript does not provide any real guarantees; it only pretends. PureScript does provide such guarantees.

- [`fp-ts`'s Migration guide from PureScript to TypeScript](https://gcanti.github.io/fp-ts/guides/purescript.html). This is helpful for seeing 1) how much more TypeScript code it takes to implement the same feature in PureScript, and 2) how the resulting syntax IMO is of lesser quality and clarity than the corresponding PureScript code is.
- [TypeScript vs PureScript: Not All Compilers Are Created Equal](https://blog.logrocket.com/typescript-vs-purescript-not-all-compilers-are-created-equal-c16dadaa7d3e)
- [JavaScript, TypeScript, and PureScript](https://www.youtube.com/watch?v=JTEfpNtEoSA) or "Why TypeScript only 'pretends' to have types."
- [Various examples comparing PureScript and TypeScript](https://discourse.purescript.org/t/type-system-showdown-purescript-and-typescript/2084)
- [Experience Report: PureScript+Halogen > TypeScript+React](https://web.archive.org/web/20221026181022/https://twitter.com/christopherdone/status/1572329195858018307)
- [A Guide on Migrating from TypeScript to PureScript](https://github.com/xc-jp/blog-posts/blob/master/_posts/2021-10-07-PureScript-React.md)

#### PureScript vs Elm / Gren

[Elm](https://elm-lang.org/) is a language founded on the similar philosophical foundations as PureScript. [Gren](https://gren-lang.org/) is a fork of Elm by the community. Whichever one is used, one can gain many of the same benefits as PureScript due to its type safety. However, there is a ceiling on the abstractions one can express. PureScript's ceiling is much higher than Elm's because it has type classes.

Elm/Gren
- ... sacrifices the following features ...
    - type classes, which
        - reduce boilerplate code since the compiler can write code for you
        - enable one to define and uphold constraints about their program (e.g. this sequence of commands must be executed in the correct order)
- ... to gain the following ...
    - clear actionable error messages because there are less ambiguous cases to deal with in the type system

Elm, Gren, and PureScript can both be used to build a complex website. However, one will need to write more lines of code in Elm or Gren than they would in PureScript.

#### PureScript vs OCaml / Reason

This section has not yet been written.

#### PureScript vs GHCJS

Haskell, which heavily influenced PureScript, has an option for compiling Haskell to JavaScript via GHCJS. However, that comes with its own tradeoffs. PureScript was developed partly because those tradeoffs were too costly.

See [PS or ghcjs for Frontend with Haskell backend](https://discourse.purescript.org/t/ps-or-ghcjs-for-frontend-with-haskell-backend/666/2) for my summary of the main issues at play here.
