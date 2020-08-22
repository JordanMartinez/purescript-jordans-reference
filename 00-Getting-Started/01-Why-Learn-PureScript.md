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
- The points mentioned in this article: [Learn Javascript in 2018](https://hackernoon.com/learn-to-code-in-2018-get-hired-and-have-fun-along-the-way-b338247eed6a)

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
- [A Discourse pose describing some of the disadvantages of TypeScript and Elmm when compared to PureScript](https://discourse.purescript.org/t/language-highlights/1471)

For those that say "PureScript is dead, bad, stupid, not worth learning, etc." In response to these things, I'd recommend you watch [The Hard Parts of Open Source](https://www.youtube.com/watch?v=o_4EX4dPppA)

### Language Comparisons

For a full list of possible alternatives to JavaScript, see [CoffeeScript's wiki's list of 'Languages that compile to JavaScript'](https://github.com/jashkenas/coffeescript/wiki/List-of-languages-that-compile-to-JS)

**Note**: the below comparisons are still a WIP. To fully support this claim, it would help to compare each languages' various "overall rating" on various aspects. Unfortunately, since I'm not familiar with every other language mentioned, it's very difficult for me to do that. If you are familiar with such languages, consider opening an issue on this repo and discussing it with me.

In short, the below comparison will be biased towards PureScript and will not yet fairly represent the corresponding side in some situations. Consider this a starting point for your own research.

#### PureScript vs TypeScript

One of the main issues with JavaScript is a poor type system. TypeScript seems to address this issue (just consider its name), but not quite as well as PureScript does.

- [TypeScript vs PureScript: Not All Compilers Are Created Equal](https://blog.logrocket.com/typescript-vs-purescript-not-all-compilers-are-created-equal-c16dadaa7d3e)
- [JavaScript, TypeScript, and PureScript](https://www.youtube.com/watch?v=JTEfpNtEoSA) or "Why TypeScript only 'pretends' to have types."

#### PureScript vs Elm

**TL;DR**: Since Elm is founded on the similar philosophical foundations, one can use Elm and gain benefits similar to using PureScript. Elm sacrifices powerful language features to gain a simpler learning curve. Thus, it's more suited for simple applications. PureScript buys powerful language features at the cost of a harder learning curve. Thus, it's more suited for complex applications.

TODO, but the general idea is:
- Benefits of Elm:
    - Good documentation and error messages, making it easier for JavaScript-background developers to learn
    - Works very well for simple applications without complex business logic
    - Uses a simpler type system than PureScript to insure correctness
- Costs of Elm:
    - Incurs a lot of boilerplate code to do anything
    - Due to its simpler type system, it lacks more powerful abstractions, such as type classes. Thus, ideas that take a few lines of code in PureScript take much longer or cannot be done in Elm.
    - Elm is works very well for simple applications, but incurs a lot of boilerplate code. For some applications, it's all that's needed

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
- The compiler (via its warning and error messages) is your friend, not your enemy. I was not able to find a good concise explanation, but here's a few reasons why. It
    - prevents you from releasing bug-filled code to a customer. (Can I guarantee that the code "just works" or cannot be built at all?)
    - forces you to handle most errors correctly the first time rather than permit you to throw them under the rug because you are lazy or foolish (Can I guarantee all possible errors will not create future problems that lead to short-term hard-to-understand code that rarely gets cleaned up and ultimately costs the company more time to fix than if it had just been written correctly the first time?)
    - helps you figure out which type to use when the types get complicated (explained later in this repository: `Hello World/Debugging/`)
- This video explains how a type system with `type classes` allow one to re-use "dumb old data structures" (i.e. `algebraic data types`) rather than create many new data structures that differ only one slight way: [Type Classes vs the World](https://www.youtube.com/watch?v=hIZxTQP1ifo). To summarize it, `type classes`
    - allow you to write declarative code ("this is what will be true") rather than imperative code ("this is how to make truth true (hopefully, you got it right)")
    - enables the compiler to infer runtime code

#### Immutable Persistent Data Structures by Default

TODO, but the general idea is:
- Immutable data structures are the default and always work as such (unlike some other languages)
- Mutable data structures are opt-in
- Such data structures are easier to use and reason about because they don't change

#### Multiple Backends with Easy Foreign Function Interface

TODO, but the general idea is:
- [PureScript compiles to other languages besides JavaScript](https://github.com/purescript/documentation/blob/master/ecosystem/Alternate-backends.md). Thus, writing one library in PureScript will work in multiple languages, and one can choose the backend that best solves their problem.
- one can easily migrate from some other language or framework (e.g. TypeScript, Angular, etc.) to PureScript in a modular, piece-by-piece fashion

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

Yes, but you won't really see why until you have learned it. PureScript (and FP languages in general) will expand your understanding of what programming can be and do.

As always, some people prefer some languages over others and some languages are better suited for some problems as others. Feel free to disagree with me.

### If I learn PureScript, can I get a good developer job?

- See the community-curated list of [companies who use PureScript in production right now](https://github.com/ajnsit/purescript-companies).
- Check for PureScript jobs listed on [Functional Jobs](https://functionaljobs.com/jobs/search/?q=PureScript)
- See [Do you have a PureScript app in production?](https://discourse.purescript.org/t/do-you-have-a-purescript-app-in-production/20)

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
- No one really explains what the "big picture" that FP programming is all about. Thus, it's hard to see how some concept fits in the larger scheme of things.
    - See this project's `Hello World/FP Philosophical Foundations/07-FP--The-Big-Picture.md` file
- People (wrongly) believe that they must know a very abstract mathematics called "Category Theory" in order to use/write PureScript or another FP language. Due to its very abstract nature, Category Theory can be difficult to grasp and scares people off.
    - This "myth" is false. Similar to a non-techy person being able to use a very powerful computer to check their email without knowing how that computer works (e.g. the entire process from hardware -> boot process -> operating system -> email application), an FP programmer can use concepts that have their foundations in Category Theory without fully understanding those foundations.
    - The other consideration is the opportunity cost of learning Category Theory. A new learner can often get more benefit by spending their time learning something else rather than Category Theory. It might be worth learning later, but it's not necessary, nor always worth the time investment, for making someone a better programmer.
    - In short, one can produce high-quality programs in an FP language for years without fully understanding all of these Category Theory concepts, nor does it always give the best return on your time investment. One might want to wait until getting more familiar with writing FP code before one considers learning it.
- The syntax for FP languages are paradigmatically different than the syntax with which most developers are familiar (C/Java/Python). It takes a while just to get used to a "different" syntax family before it feels normal. Until it feels normal, reading through code examples will be harder.
    - This project's `Syntax` folder exists to counter the above issue.
- Related to the above, FP languages often use symbol-based aliases to refer to functions that are well-known to FP Programmers instead of those functions' literal names (e.g. `<$>` instead of `map`, `<$` instead of `voidRight`, `$>` instead of `voidLeft`). It's more concise and similarities between these symbol-based aliases add meaning to them, such as their "direction." Since new learners do not already know that to which function a symbol refers, it can be hard to know what that function even does.
    - [A Pursuit search that wraps the symbol in parenthensis (e.g. `(<$>)`)](https://pursuit.purescript.org/search?q=%28%3C%24%3E%29) fixes this problem
    - This project's `Ecosystem/Type Classes/ReadMe.md#Functions` section explains how to read the `Ecosystem/Type Classes/Type-Class-Functions.xlsx` file, which provides a table that indicates what those symbol-based fuction names are and from where they come.
- Due to their powerful type systems, FP languages trade errors that occur when running the program (runtime errors) with errors that occur when attempting to build the program via the compiler (compile-time errors). To understand how to debug these compile-time "your program would not work if it was built" errors, one must have a strong understanding of how the compiler and its type system works.
    - This project's `Syntax` folder (and more specifically, the `Syntax/Type-Level Programming Syntax` folder) explain enough to help one understand why some (but not all) problems arise.
    - The [Error Documentation](https://github.com/purescript/documentation/tree/master/errors) sometimes explains what the error is and how to fix it ([example](https://github.com/purescript/documentation/blob/master/errors/NoInstanceFound.md)) and other times is simply left unexplained ([example](https://github.com/purescript/documentation/blob/master/errors/AmbiguousTypeVariables.md)).
- Related to the above point, the powerful type system enables one to model some abstract ideas in a very precise way using well-defined types or things called type classes. However, those concepts can be recursive (they reference themselves in their definition), use higher-kinded types (these types are, in one way, defined only "partially" to enable code that works for many cases instead of just one), or work as part of a larger system outside of their definition. Thus, it can be very hard for a new learner to understand how to read a type or a type class.
    - While many cool things can be done using very complex types, new learners need to know that such types can wait until they get more familiar with the language. As an example, consider [the Haskell Pyramid](https://patrickmn.com/software/the-haskell-pyramid/). "Monads" are an important concept that are a bit harder to grasp. Learners need to be told that they do not need to know these things right away. They should learn them when they are ready and not be feel intimidated about types before then.
    - This project either explains or links to other explanations on the most common types and type classes that are hard to understand but frequently used (e.g. Functor, Monad, Monad Transformers, the Free Monad).
    - However, there are some concepts (e.g. Coyoneda, Free Applicatives, Day Convolution, etc.) that are not yet covered here.
- Many people try to re-explain something that another has already explained well and they write a poor re-explanation. It's hard to determine which explanations are accurate and correct and which are vague and mistaken until after you have already read it and/or know better.
    - Ironically, this entire project could be a bad re-explanation! That's why I summarize or link to other posts that I believe to be credible.
    - My sources include `Haskell Weekly`, the FP Slack community's `#purescript`/`#purescript-beginners` channels, a number of books I've read on FP programming, a number of papers I've read on FP programming, and various videos I've watched regarding FP programming. Consider yourself warned.
- There are few sites or locations that "centralize" a lot of high-quality FP guides/explanations. Thus, it's hard for new learners to find them.
    - This project exists partly because of this issue and hopes to resolve some of these problems.
    - For other "centralized" locations, see `Hello World/ReadMe.md#other-learning-resources`.
- Many ideas are explained in papers that are not written for new learners but for academics. Understanding these papers' contents sometimes requires an understanding of high-level math, notation for specific concepts, etc., making the entry barrier higher
    - In various situations, I link to such papers and only in one situation do I walk a read through such a paper. In other words, this problem is still at large.

### If I choose to learn PureScript, will I later regret not having spent that same time learning a different compile-to-Javascript language (e.g. TypeScript, CoffeeScript, etc.) or a "compile to WebAssembly"-capable language (e.g. Rust) instead?

You might regret it if you are not being honest or thoughtful about the purpose you are trying to achieve. Not being aware of your expectations, nor having realistic ones, will almost always end in having those expectatiosn broken, leaving you angry, disappointed, or frustrated.

Some facts:
- Rust has a learning curve as well (i.e. lifetimes, borrow checker)
- WebAssembly holds promise, but it is still being developed.
- Languages that are popular or backed by companies with many resources are not necessarily the best languages to use for your particular purposes
- PureScript's type system is more powerful than similar languages' type system (if it exists)
- A few people who are using PureScript now have said this about TypeScript: "You might as well be writing Javascript"
- Elm forces you to write code in only one way. If it suits your needs, that's great. If it doesn't, it hurts.
- There's a general saying about FP languages: "Once you go FP, you never go back."

### How mature is the Ecosystem? Will I need to initially spend time writing/improving/documenting libraries for this language or can I immediately use libraries that are stable and mature?

It's primarily good for front-end work and not so much (yet) for back-end work. When it is lacking, one will likely need to use FFI to utilize JS libraries. See [awesome-purescript](https://github.com/passy/awesome-purescript); the documentation site, [Pursuit](http://pursuit.purescript.org/); and also this project's `Ecosystem` folder (still a WIP).

Also, attempting to port over Haskell libraries to this language are harder at times and have unexpected performance. Why? Because Haskell is a lazily-evaluated language, but PureScript is a strictly-evaluated language.

### How hard it is to use another language's libraries via bindings?

Creating bindings are easy. However, since the code was not written via PureScript, you don't know whether a function will throw an exception or not. On stable mature well-tested libraries, this shouldn't be a big problem.

See the `Syntax/Foreign Function Interface` folder for examples of how easy bindings are and things related to this.

### How easy/pleasant is it to use the language's build tools (e.g. compiler, linter/type checker, dependency manager, etc.) and text editor tools (e.g. ease of setup, refactoring support, pop-up documentation, etc.)?

The build tools are pretty good. One will typically use a `pulp + Bower`-based workflow or a `spago`-based workflow. These are explained in `Build Tools/Tool Comparisons/Dependency Managers.md`.

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
