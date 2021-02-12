# Why Learn PureScript?

All languages make tradeoffs in various areas and on various spectrums:
- learning curve
- abstractions
- syntax
- errors
- type systems
- etc.

The question is "Which combination of tradeoffs provides the most benefits in prioritized areas?" "Good" languages happen to select specific tradeoffs that make the language well-suited for specific problems. For example, Python is well-suited for creating dirty one-time-run scripts to do tedious work on a computer. While Python can be used to create a financial or medical applications that need to extremely fast and secure, it would be better to use a different language that is better suited for such a task, such as Rust.

PureScript has chosen tradeoffs that its developers think are the best for creating simple to complex front-end applications that "just work;" that are easy to refactor, debug, and test; and help make developers more productive rather than less.

It can be said that other front-end languages buy "popularity" at the cost of "power and productivity."
PureScript buys "power and productivity" at the cost of "popularity."

To fully answer "Why learn PureScript?" we must answer three other questions:
- Why one should use Javascript to build programs...
- ...but not write Javascript to build it...
- ...and write Purescript instead of alternatives

Then I'll answer a few possible questions the below audiences may have in the FAQ section:
- A developer who is already competent/productive in Javascript or a compile-to-Javascript language (e.g. Coffeescript, Typescript, etc.)
- A developer who is only starting to learn web technologies, but has heard that Javascript is horrible and is investigating other compile-to-Javascript languages.
- A business person who knows very little about programming or programming languages but who wants to know more about what options are available and what their pros/cons are.

## Why one should use Javascript to build programs...

- The web browser is the new ["dumb terminal"](https://www.youtube.com/embed/YI34UIMgkxs?start=1762&end=1828) / platform-independent OS:
    - [What can web do today?](https://whatwebcando.today/)
- [Why Founders Should Start With a Website, Not a Mobile App](https://www.atrium.co/blog/founders-should-build-website-not-mobile-app/)
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

- [TypeScript vs PureScript: Not All Compilers Are Created Equal](https://blog.logrocket.com/typescript-vs-purescript-not-all-compilers-are-created-equal-c16dadaa7d3e)
- [JavaScript, TypeScript, and PureScript](https://www.youtube.com/watch?v=JTEfpNtEoSA) or "Why TypeScript only 'pretends' to have types."
- [Various examples comparing PureScript and TypeScript](https://discourse.purescript.org/t/type-system-showdown-purescript-and-typescript/2084)

#### PureScript vs Elm

Since Elm is founded on the similar philosophical foundations as PureScript, one can use Elm and gain many of the same benefits as PureScript due to its type safety. However, there is a ceiling on the abstractions one can express in Elm. PureScript's ceiling is much higher than Elm's because it has type classes.

Elm
- ... sacrifices the following features ...
    - type classes, which
        - reduce boilerplate code since the compiler can write code for you
        - enable one to define and uphold constraints about their program (e.g. this sequence of commands must be executed in the correct order)
- ... to gain the following ...
    - clear actionable error messages because there are less ambiguous cases to deal with in the type system

Elm and PureScript can both be used to build a complex website. However, one will need to write more lines of code in Elm than they would in PureScript.

#### PureScript vs OCaml / Reason

This section has not yet been written.

#### PureScript vs GHCJS

Haskell, which heavily influenced PureScript, has an option for compiling Haskell to JavaScript via GHCJS. However, that comes with its own tradeoffs. PureScript was developed partly because those tradeoffs were too costly.

See [PS or ghcjs for Frontend with Haskell backend](https://discourse.purescript.org/t/ps-or-ghcjs-for-frontend-with-haskell-backend/666/2) for my summary of the main issues at play here.

### The Strengths of PureScript

Above, I stated that PureScript makes specific tradeoffs. I'd like to cover what some of those tradeoffs are and why they are good. (These ideas will be further explained in the "FP Philosophical Foundations" folder that appears later in this repository.)

#### Strongly Adheres to the Functional Programming Paradigm

- [A Secret Weapon for Startups -- Functional Programming?](https://www.ramanan.com/personal-blog/2019/2/25/functional-programming-and-venture-capital)
- Paradigm shifts, such as the one demonstrated by this video using C++, are what enable programs with less problems: [Logging a function's name each time it is called: migrating an "object-oriented paradigm" solution to an "functional paradigm" solution](https://www.youtube.com/embed/i9CU4CuHADQ?start=540). As will be explained later, this is what is known as the "Writer Monad."
- [Object-oriented "design patterns" in FP languages](http://blog.ezyang.com/2010/05/design-patterns-in-haskel/) are often just functions in disguise. Rather than learning the 20 different design patterns, one can learn how functions work and can be used to create really beautiful concepts and solutions.
- [Functional Architecture: The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0). To summarize this video, FP languages force you to structure your code in a way that makes it:
    - easy to test in an unbiased way (Can I prove that the logic/algorithm that solves the business problem is correct and works according to the specification despite any programmer's laziness or lack of foresight in thinking of a possible scenario where the code could fail?)
    - easy to add/change/remove a "backend" to account for trends, new insights, or faster code (Without introducing a new bug or deleting a current feature, can I switch from Company A's database to Company B's database without rewriting more than 30 lines of code?)
    - unconcerning to allow a new developer to work on the code, knowing that he/she cannot screw up anything major (Can the Lead/Senior Developer take the weekend off and return, knowing that it's extraordinarily difficult for developers with little experience to break something?)

#### Powerful Static Type System

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

#### Immutable Persistent Data Structures by Default

In PureScript, immutable data structures are the default rather than being "opt-in." In most other languages, mutable data structures are the default with immutable ones being "opt-in."

Immutable data structures are
- easier to reason about because the value never changes
- are always thread-safe, preventing many typical issues with concurrency
- can be as performant as mutable data structures in most cases

#### Multiple Backends with Easy Foreign Function Interface

Most languages have their own backend.
- Javascript is compiled and run via a Javascript engine.
- Java compiles to bytecode that can be run on a Java Virtual Machine.
- Python gets compiled into bytecode that is then interpreted.

PureScript does not have a backend. Rather, it's source code can be compiled to other languages. While JavaScript is the focus, [PureScript compiles to other languages besides JavaScript](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md). Thus, writing one library in PureScript can work in multiple languages, and one can choose the backend (or a combination of them) that best solves their problem.

Caveat: PureScript's support for non-Javascript backends is still a work-in-progress. In future releases, they will be getting first-class support.

This backend-independent nature of PureScript makes "Foreign Function Interface" very clean. At various times, Language X needs to use code from another language, Language Y. For code written in one language to use code written in another language, there needs to be a "Foreign Function Interface" or FFI.

Many languages' FFI can be difficult to work with. Language X made various language tradeoff decisions that are different than Language Y. Getting two languages to work together is difficult to say the least. However, PureScript's FFI is very easy because PureScript already compiles to that language.

If you are compiling PureScript to Javascript, you can still write JavaScript as FFI for PureScript. This makes it possible to wrap Javascript libraries on which you heavily depend. It also enables one to easily migrate from some other language or framework (e.g. TypeScript, Angular, etc.) to PureScript in a modular, piece-by-piece fashion

## FAQ: Answering Miscellaneous Questions People May Have

This explanation depends on your particular background. As stated above, I'm focusing on these audiences:
- A developer who is already competent/productive in Javascript or a compile-to-Javascript language (e.g. Coffeescript, Typescript, etc.)
- A developer who is only starting to learn web technologies, but has heard that Javascript is horrible and is investigating other compile-to-Javascript languages.
- A business person who knows very little about programming or programming languages but who wants to know more about what options are available and what their pros/cons are.

These are the kinds of questions the above people might be asking:
- Cost-Benefit Issue: Is the price of the steep learning curve worth the benefits of using PureScript in code?
- Job Prospects Issue: If I learn PureScript, can I get a good developer job?
- When-to-Learn Issue: Should I learn PureScript now or wait until sometime later?
- Time-to-Productivity Issue: How long will it take me before I can write idiomatic code and be productive in PureScript?
- Opportunity Cost Issue: If I choose to learn PureScript, will I later regret not having spent that same time learning a different compile-to-Javascript language (e.g. TypeScript, CoffeeScript, etc.) or a "compile to WebAssembly"-capable language (e.g. Rust) instead?
- Ecosystem Issue: How mature is the Ecosystem? Will I need to initially spend time writing/improving/documenting libraries for this language or can I immediately use libraries that are stable and mature?
- Foreign Function Interface Issue: How hard it is to use another language's libraries via bindings?
- Program Tools Experience: How easy/pleasant is it to use the language's build tools (e.g. compiler, linter/type checker, dependency manager, etc.) and text editor tools (e.g. ease of setup, refactoring support, pop-up documentation, etc.)?
- Community Friendliness Issue: How friendly, helpful, responsive, inspiring, determined, and collaborative are the people who use and contribute to this language and its ecosystem?
- Code Migration Issue: What problems do developer teams typically encounter when migrating from Language X to PureScript and how hard are these to overcome?

Let's answer these one at a time. **Each answer is my opinion and could be backed up with better arguments and explanations in some areas.**.

### Is the price of the steep learning curve worth the benefits of using PureScript in code?

Yes. Most mainstream languages force you to depend on the IDE, linters, and other tools outside of the language to help you write correct code. Such languages often lack the features within the language itself to help you express certain ideas and constraints within your program. PureScript's powerful language features allow you to express what other languages cannot.

Even if one ultimately decides not to use PureScript, the language itself can be a helpful environment for training your mind to think more precisely about how to write code.

### If I learn PureScript, can I get a good developer job?

- See the community-curated list of [companies who use PureScript in production right now](https://github.com/ajnsit/purescript-companies).
- See [Do you have a PureScript app in production?](https://discourse.purescript.org/t/do-you-have-a-purescript-app-in-production/20)
- Check for PureScript jobs listed on [Functional Jobs](https://functionaljobs.com/jobs/search/?q=PureScript)

### Should I learn PureScript now or wait until sometime later?

You might want to learn it **now** for these reasons:
- PureScript is actually quite mature and close to a `1.0`. Many are already using it in production code.
- PureScript is syntactically and conceptually very similar to Haskell. If you learn PureScript, you've basically learned Haskell, too. I believe that PureScript provides a better environment for learning Functional Paradigm concepts than Haskell since it's easier to install, build, and experiment with.
    - No need to use any language extensions (e.g. `OverloadedStrings`)
    - Better record syntax
    - More granular type class hierarchy
- This project covers enough items that you should be able to learn PureScript relatively quickly. Still, while this project's code compiles and runs, its accuracy has not been verified by an "expert in the language" per say.

You might want to learn it **later** for these reasons:
- PureScript's documentation could be improved in a number of ways:
    - Documentation for libraries are good in some areas and lacking in others.

### How long will it take me before I can write idiomatic code and be productive in PureScript?

The average time for learning FP languages in general is usually 6 months due to the below reasons. This repository hopes to speed that process up, but, as always, people learn at different paces:
- Many tutorials/guides assume their readers already know foundational principles. New learners who read them often do not know, nor are even aware of, those foundational principles.
    - This project's `Hello World/FP Philosophical Foundations` folder exists to counter this issue
- No one really explains what the "big picture" that FP programming is all about. Thus, it's hard to see how some concept fits in the larger scheme of things, much less why that concept is so fundamental to everything.
    - See this project's `Hello World/FP Philosophical Foundations/07-FP--The-Big-Picture.md` file
- People (wrongly) believe that they must know a very abstract mathematics called "Category Theory" in order to use/write PureScript or another FP language. Due to its very abstract nature, Category Theory can be difficult to grasp and scares people off.
    - This "myth" is false. Most FP developers do not understand Category Theory and yet they already have an intuition for some of its ideas.
- The syntax for FP languages are paradigmatically different than the syntax with which most developers are familiar (C/Java/Python). It takes a while to get used to a "different" syntax family before it feels normal. Until it feels normal, reading through code examples will be harder.
    - This project's `Syntax` folder exists to counter the above issue.
- Related to the above, FP languages often use symbol-based aliases to refer to functions that are well-known to FP Programmers instead of those functions' literal names (e.g. `<$>` instead of `map`, `<$` instead of `voidRight`, `$>` instead of `voidLeft`). It's more concise and similarities between these symbol-based aliases add meaning to them, such as their "direction." Since new learners do not already know that to which function a symbol refers, it can be hard to know what that function even does.
    - [A Pursuit search that wraps the symbol in parenthensis (e.g. `(<$>)`)](https://pursuit.purescript.org/search?q=%28%3C%24%3E%29) fixes this problem
    - This project's `Ecosystem/Type Classes/ReadMe.md#Functions` section explains how to read the `Ecosystem/Type Classes/Type-Class-Functions.xlsx` file, which provides a table that indicates what those symbol-based fuction names are and from where they come.
- Due to their powerful type systems, FP languages trade errors that occur when running the program (runtime errors) with errors that occur when attempting to build the program via the compiler (compile-time errors). To understand how to debug these compile-time "your program would not work if it was built" errors, one must have a strong understanding of how the compiler and its type system works.
    - This project's `Syntax` folder (and more specifically, the `Syntax/Type-Level Programming Syntax` folder) explain enough to help one understand why some (but not all) problems arise.
    - The [Error Documentation](https://github.com/purescript/documentation/tree/master/errors) sometimes explains what the error is and how to fix it ([example](https://github.com/purescript/documentation/blob/master/errors/NoInstanceFound.md)) and other times is simply left unexplained ([example](https://github.com/purescript/documentation/blob/master/errors/AmbiguousTypeVariables.md)).
    - The `purescript-beginner` Slack channel is active and often helps people troubleshoot the error messages.
- Related to the above point, the powerful type system enables one to model some abstract ideas in a very precise way using well-defined types or things called type classes. When these features start to stack, a new learner can become overwhelmed.
    - If one reads this work in order, they are unlikely to be overwhelmed.
    - Most of the "cool type things" one can do are helpful but not always necessary. Consider [the Haskell Pyramid](https://patrickmn.com/software/the-haskell-pyramid/). "Monads" are an important and fundamental FP concept, but new learners do not need to learn what they are or how to use them right away.
- Many people try to re-explain something that another has already explained well and they write a poor re-explanation. It's hard to determine which explanations are accurate and correct and which are vague and mistaken until after you have already read it and/or know better.
    - I've been you. This work is my attempt to sift through the noise and present things in the best and simplest way possible. In various cases, I summarize and/or link to other posts that I believe to be credible that also explain a concept clearly. My sources include `Haskell Weekly`, the Functional Programming Slack channels of `#purescript` and `#purescript-beginners`, a number of books I've read on FP programming, a number of papers I've read on FP programming, and various videos I've watched regarding FP programming.
- There are few sites or locations that "centralize" a lot of high-quality FP guides/explanations. Thus, it's hard for new learners to find them.
    - This project exists partly because of this issue and hopes to resolve some of these problems.
    - For other "centralized" locations, see `Hello World/ReadMe.md#other-learning-resources`.
- Many ideas are explained in papers that are not written for new learners but for academics. Understanding these papers' contents sometimes requires an understanding of high-level math, notation for specific concepts, etc., making the entry barrier higher
    - In various situations, I link to such papers and only in one situation do I walk a read through such a paper. In other words, this problem is still at large.

### If I choose to learn PureScript, will I later regret not having spent that same time learning a different compile-to-Javascript language (e.g. TypeScript, CoffeeScript, etc.) or a "compile to WebAssembly"-capable language (e.g. Rust) instead?

You might regret it if you are not being honest or thoughtful about the purpose you are trying to achieve. Not being aware of your expectations, nor having realistic ones, will almost always end in having those expectatiosn broken, leaving you angry, disappointed, or frustrated.

Some facts:
- WebAssembly holds promise, but it is still being developed.
- Languages that are popular or backed by companies with many resources are not necessarily the best languages to use for your particular purposes
- While PureScript offers more guarantees than most other languages, it unfortunately might not be the best language to use/learn if
    - you need mature libraries for a particular need that hasn't yet been written in PureScript. This is one benefit of TypeScript/Javascript.
    - you find that Elm's tradeoffs are "good enough" for your purposes.
- A few people who are using PureScript now have said this about TypeScript: "You might as well be writing Javascript"

### How mature is the Ecosystem? Will I need to initially spend time writing/improving/documenting libraries for this language or can I immediately use libraries that are stable and mature?

It's primarily good for front-end work and not so much (yet) for back-end work. When it is lacking, one will likely need to use FFI to utilize JS libraries. See [awesome-purescript](https://github.com/passy/awesome-purescript); the documentation site, [Pursuit](http://pursuit.purescript.org/); and also this project's `Ecosystem` folder (still a WIP).

Also, attempting to port over Haskell libraries to this language are harder at times and have unexpected performance. Why? Because Haskell is a lazily-evaluated language, but PureScript is a strictly-evaluated language.

### How hard it is to use another language's libraries via bindings?

Writing bindings is simple. See the `Syntax/Foreign Function Interface` folder for examples of how simple bindings are and things related to this.

However, using FFI via bindings can introduce runtime errors. Whenever one uses a library via FFI, you don't know whether a function will throw an exception or not. This can produce unexpected runtime errors even though you've written your code in a type-safe language. On stable mature well-tested libraries, this shouldn't be a big problem.

Lastly, writing bindings is tedious. PureScript uses algebraic data types (ADTs), but most libraries will define one function that can take multiple sets of arguments. For example, one might call the function, `foo`, with any of these sets of arguments:
- `foo("apple")` (the first String argument, `apple`, is required)
- `foo("apple", ["banana", "orange"])` (the Array of Strings argument is optional)
- `foo("apple", ["banana", "orange"], true)` (the boolean flag is optional, too)
- `foo("apple", {first:"banana", second:"orange"}, true)` (the array can be passed in as a record/map/dictionary/object, too)
- `foo("apple", {first:"banana", second:"orange", optional: true}, true)` (the second argument can have optional fields in addition to its required ones)

In reality, `foo` is at least 5 different functions that are all using the same name. Thus, writing bindings for `foo` is tedious to do in a language like PureScript due to PureScript's type-safe nature. However, there is a [library for handling](https://github.com/jvliwanag/purescript-untagged-union) these kind of situations.

Others have also worked on writing code-generators that, for example, can look at the code of a library written in TypeScript and generate the corresponding PureScript bindings for that code. Such a tool is still a work-in-progress.

### How easy/pleasant is it to use the language's build tools (e.g. compiler, linter/type checker, dependency manager, etc.) and text editor tools (e.g. ease of setup, refactoring support, pop-up documentation, etc.)?

The build tools are pretty good. One will typically use a `spago`-based workflow. These are explained in `Build Tools/Tool Comparisons/Dependency Managers.md`.

See the `Build Tools/` folder for more up-to-date information. Likewise, see [Editor and Tool Support](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md) for other editor-related configurations.

### How friendly, helpful, responsive, inspiring, determined, and collaborative are the people who use and contribute to this language and its ecosystem?

People usually get help from some of the core contributors or other well-informed people via the `#purescript` and `#purescript-beginners`. No question is too stupid. For longer threads, some post on the [PureScript Discorse Forum](https://discourse.purescript.org).

The language's development is currently slow because each core contributor have full-time jobs and contribute in their spare time, not because they don't want to.

### What problems do developer teams typically encounter when migrating from Language X to PureScript and how hard are these to overcome?

- See Phil Freeman's own blog post on the matter: [PureScript and Haskell at Lumi](https://medium.com/fuzzy-sharp/purescript-and-haskell-at-lumi-7e8e2b16fb13)
- Thomas Honeyman's [How to Replace React Components with PureScript's React libraries](https://thomashoneyman.com/articles/replace-react-components-with-purescript/)
- [(Video) JavaScript to PureScript - a Migration Story](https://www.youtube.com/watch?v=bt130Z7UNPE) & [Slides](https://github.com/lambdaconf/lambdaconf-2018/blob/master/LC18-slides/Curran-angular-purescript-halogen.pdf)
- [(Video) Adopting Pure FP Incrementally - Engineering at Lumi](https://www.youtube.com/watch?v=SiGXTcFEvHo)
- Likewise, see [Introducing Haskell to a Company](https://alasconnect.github.io/blog/posts/2018-10-02-introducing-haskell-to-a-company.html), which can equally apply to Purescript
- See [Robert Kluin - Introducing A Functional Language At Work - λC 2018](https://www.youtube.com/watch?v=3USNLflRRUA)/[slides](https://github.com/lambdaconf/lambdaconf-2018/blob/master/LC18-slides/A%20Developer%E2%80%99s%20Guide%20to%20Introducing%20A%20Functional%20Language%20At%20Work.pdf) for a cautionary tale of "what can go wrong and why" when he attempted to introduce Scala at work.
