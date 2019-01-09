# Getting Started

This folder will cover the following topics:
- Installing Purescript
- Getting familiar with the REPL
- Other info you should know before working through the other folders in this project

## Why Learn PureScript?

This question can be answered by explaining three things:
- Why one should use Javascript to build programs...
- ...but not write Javascript to build it...
- ...and write Purescript instead of alternatives

### Why one should use Javascript to build programs...

TODO, but the general idea:
- The web browser is the new ["dumb terminal"](https://www.youtube.com/embed/YI34UIMgkxs?start=1762&end=1828) / platform-independent OS:
    - [What can web do today?](https://whatwebcando.today/)
- Progressive web applications are better than native web apps in a few important ways
- WebAssembly
- The points mentioned in this article: [Learn Javascript in 2018](https://hackernoon.com/learn-to-code-in-2018-get-hired-and-have-fun-along-the-way-b338247eed6a)
- [Why Founders Should Start With a Website, Not a Mobile App](https://www.atrium.co/blog/founders-should-build-website-not-mobile-app/)

### ...but not write Javascript to build it...

The benefits of strong types:
- Types == UML diagrams
- The types guide how something should be implemented
- The compiler can infer runtime code
- Certain classes of bugs are eliminated

TODO, but the general idea is:
- dynamic typing -> runtime errors
- a linter is just a basic static type checker
- easier to write, read, and understand a 'safer language' that compiles to efficient Javascript
- alternatives: Typescript, Coffeescript, Elm, etc.
- [OO "design patterns" in FP languages](http://blog.ezyang.com/2010/05/design-patterns-in-haskel/)

### ...and write Purescript instead of alternatives

**TL;DR**

TODO, but the general idea is:
- https://www.youtube.com/watch?time_continue=22&v=5AtyWgQ3vv0
- type-level programming
- compiles to other languages beside Javascript: C, C++, Erlang, and Swift

- The strong, static type system of the language
    - allows you to model a domain at a 1-to-1 ratio (Can I model the domain idea, "'Fido' is a dog who likes bacon and is friends with Mark," as such and not as "'Fido' is a dog. Dog1 likes bacon. Mark is friends with Dog1. Sometimes, 'Dog1' refers to 'Fido' but other times it refers to nothing and produces an error."?)
    - will prevent you from releasing bug-filled code to a customer. (Can I guarantee that the code "just works" or cannot be built at all?)
    - forces you to handle errors correctly the first time rather than permit you to throw them under the rug because you are lazy or foolish (Can I guarantee all possible errors will not create future problems that lead to short-term hard-to-understand code that rarely gets cleaned up and ultimately costs the company more time to fix than if it had just been written correctly the first time?)
    - provides a kind of always-up-to-date/never-out-of-sync documentation (Can I write code and documentation simultaneously rather than writing code and its documentation as two separate tasks where the latter must always be kept in-sync with the former?)
    - makes it easier for a programmer to understand code because it decreases the possibilities of what can occur (Can I make it impossible for this code to do anything else besides what this concept's law allows?)
- The language forces you to structure your code in a way that makes it
    - easy to test in an unbiased way (Can I prove that the logic/algorithm that solves the business problem is correct and works according to the specification despite any programmer's laziness or lack of foresight in thinking of a possible scenario where the code could fail?)
    - easy to add/change/remove a "backend" to account for trends, new insights, or faster code (Without introducing a new bug or deleting a current feature, can I switch from Company A's database to Company B's database without rewriting more than 30 lines of code?)
    - unconcerning to allow a new developer to work on the code, knowing that he/she cannot screw up anything major (Can the Lead/Senior Developer take the weekend off and return, knowing that it's extraordinarily difficult for developers with little experience to break something?)

See the (WIP) [Purescript version of Real World App](https://github.com/thomashoneyman/purescript-halogen-realworld)

<hr>

This part's explanation depends on your particular background. For example, here are a few different kinds of people that might be reading this file:
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

#### Is the price of the steep learning curve worth the benefits of using PureScript in code?

Yes.

PureScript supports a number of features (e.g. powerful type system) that simply do not exist in other compile-to-Javascript languages. These features grant additional power, preciseness, readability.

To fully support this claim, it would help to compare various ecosystem's "features." Unfortunately, since I'm not familiar with every other language mentioned, it's very difficult for me to do that.

In addition, PureScript can compile to other languages besides Javascript. That means you can write the same code to solve your business problem and run it on multiple platforms besides `Node.js` or the Browser, depending on which one is the best fit for your purposes:
- [Pure-C (C)](https://github.com/pure-c/purec)
- [Purescript Native (C++)](https://github.com/andyarvanitis/purescript-native)
    - See [How to create 3D Games with PureScript Native and C++](https://twitter.com/lettier/status/1074863932328853505)
- [Erlang](https://github.com/purerl/purescript)
- [Swift](https://github.com/paulyoung/pureswift)

#### If I learn PureScript, can I get a good developer job?

- A number of jobs listed on [Functional Jobs](https://functionaljobs.com/jobs/search/?q=PureScript) use PureScript in their website-related projects
- A number of companies use it in production: Conde Nast, Awake Security, Lumi, SlamData, CitizenNet, Habito, CollegeVine, etc.
- See [Do you have a PureScript app in production?](https://discourse.purescript.org/t/do-you-have-a-purescript-app-in-production/20)

#### Should I learn PureScript now or wait until sometime later?

You might want to learn it **now** for these reasons:
- PureScript is actually quite mature and close to a `1.0`. Many are already using it in production code.
- PureScript is syntactically and conceptually very similar to Haskell. If you learn PureScript, you've basically learned Haskell, too. I believe that PureScript provides a better environment for learning Functional Paradigm concepts than Haskell since it's easier to install, build, and experiment with.
    - No need to use any language extensions (e.g. `OverloadedStrings`)
    - Better record syntax
    - More granular type class hierarchy
- This project covers enough items that you should be able to learn PureScript relatively quickly. Still, while this project's code compiles and runs, its accuracy has not been verified by an "expert in the language" per say.

You might want to learn it **later** for these reasons:
- PureScript's documentation could be improved in a number of ways:
    - `PureScript By Example` is a book written by the creator of the PureScript language that uses a project-oriented approach to get a new learner up to speed quickly. However, the book's code is outdated and still being updated.
    - Documentation for libraries are good in some areas and lacking in others

#### How long will it take me before I can write idiomatic code and be productive in PureScript?

The average time for learning FP languages in general is usually 6 months due to the following reasons:
- Many tutorials/guides assume their readers already know foundational principles. New learners who read them often do not know, nor are even aware of, those foundational principles.
    - This project's `Hello World/FP Philosophical Foundations` folder exists to counter this issue
- No one really explains what the "big picture" that FP programming is all about. Thus, it's hard to see how some concept fits in the larger scheme of things.
    - See this project's `Hello World/FP Philosophical Foundations/07-FP--The-Big-Picture.md` file
- The syntax for FP languages are paradigmatically different than the syntax with which most developers are familiar (C/Java/Python). It takes a while just to get used to a "different" syntax family before it feels normal. Until it feels normal, reading through code examples will be harder.
    - This project's `Syntax` folder exists to counter the above issue.
- Related to the above, FP languages often use symbol-based aliases to refer to functions that are well-known to FP Programmers instead of those functions' literal names (e.g. `<$>` instead of `map`, `<$` instead of `voidRight`, `$>` instead of `voidLeft`). It's more concise and similarities between these symbol-based aliases add meaning to them, such as their "direction." Since new learners do not already know that to which function a symbol refers, it can be hard to know what that function even does
    - [A Pursuit search that wraps the symbol in parenthensis (e.g. `(<$>)`)](https://pursuit.purescript.org/search?q=%28%3C%24%3E%29) fixes this problem
    - This project's `Ecosystem/Type Classes/ReadMe.md#Functions` section explains how to read the `Ecosystem/Type Classes/Type-Class-Functions.xlsx` file, which provides a table that indicates what those symbol-based fuction names are and from where they come.
- Due to their powerful type systems, FP languages trade errors that occur when running the program (runtime errors) with errors that occur when attempting to build the program via the compiler (compile-time errors). To understand how to debug these compile-time "your program would not work if it was built" errors, one must have a strong undertanding of how the compiler and its type system works.
    - This project's `Syntax` folder (and more specifically, the `Syntax/Type-Level Programming Syntax` folder) explain enough to help one understand why some (but not all) problems arise.
    - The [Error Documentation](https://github.com/purescript/documentation/tree/master/errors) sometimes explains what the error is and how to fix it ([example](https://github.com/purescript/documentation/blob/master/errors/NoInstanceFound.md)) and other times is simply left unexplained ([example](https://github.com/purescript/documentation/blob/master/errors/AmbiguousTypeVariables.md)).
- Related to the above point, the powerful type system enables one to model some abstract ideas in a very precise way using well-defined types or things called type classes. However, those concepts can be recursive (they reference themselves in their definition), use higher-kinded types (these types are, in one way, defined only "partially" to enable code that works for many cases instead of just one), or work as part of a larger system outside of their definition. Thus, it can be very hard for a new learner to understand how to read a type or a type class.
    - This project either explains or links to other explanations on the most common types and type classes that are hard to understand but frequently used: (e.g. Functor, Monad, Monad Transformers, the Free Monad)
    - However, there are some concepts (e.g. Coyoneda, Free Applicatives, Day Convolution, etc.) that are not yet covered here.
- Many people try to re-explain something that another has already explained well and they write a poor re-explanation. It's hard to determine which explanations are accurate and correct and which are vague and mistaken until after you have already read it and/or know better.
    - Ironically, this entire project could be a bad re-explanation! That's why I summarize or link to other posts that I believe to be credible.
    - My sources include `Haskell Weekly`, the FP Slack community's `#purescript`/`#purescript-beginners` channels, a number of books I've read on FP programming, a number of papers I've read on FP programming, and various videos I've watched regarding FP programming. Consider yourself warned.
- There is no centralized location for FP guides/explanations. Thus, it's hard for new learners to find them.
    - This project exists partly because of this issue and hopes to resolve some of these problems.
- Many ideas are explained in papers that are not written for new learners but for academics. Understanding these papers' contents sometimes requires an understanding of high-level math, notation for specific concepts, etc., making the entry barrier higher
    - In various situations, I link to such papers and only in one situation do I walk a read through such a paper. In other words, this problem is still at large.

#### If I choose to learn PureScript, will I later regret not having spent that same time learning a different compile-to-Javascript language (e.g. TypeScript, CoffeeScript, etc.) or a "compile to WebAssembly"-capable language (e.g. Rust) instead?

You might regret it if you are not being honest or thoughtful about the purpose you are trying to achieve. Not being aware of your expectations, nor having realistic ones, will almost always end in having those expectatiosn broken, leaving you angry, disappointed, or frustrated.

Some facts:
- Rust has a learning curve as well (i.e. lifetimes, borrow checker)
- WebAssembly holds promise, but it is still being developed.
- Languages that are popular or backed by companies with many resources are not necessarily the best languages to use for your particular purposes
- PureScript's type system is more powerful than similar languages' type system (if it exists)
- A few people who are using PureScript now have said this about TypeScript: "You might as well be writing Javascript"
- Elm forces you to write code in only one way. If it suits your needs, that's great. If it doesn't, it hurts.
- There's a general saying about FP languages: "Once you go FP, you never go back."

#### How mature is the Ecosystem? Will I need to initially spend time writing/improving/documenting libraries for this language or can I immediately use libraries that are stable and mature?

It's lacking in a few areas but solid in others. See [awesome-purescript](https://github.com/passy/awesome-purescript); the documentation site, [Pursuit](http://pursuit.purescript.org/); and also this project's `Ecosystem` folder (still a WIP).

Also, attempting to port over Haskell libraries to this language are harder at times and have unexpected performance. Why? Because Haskell is a lazily-evaluated language, but PureScript is a strictly-evaluated language.

#### How hard it is to use another language's libraries via bindings?

Creating bindings are easy. However, since the code was not written via PureScript, you don't know whether a function will throw an exception or not. On stable mature well-tested libraries, this shouldn't be a big problem.

See the `Syntax/Foreign Function Interface` folder for examples of how easy bindings are and things related to this.

#### How easy/pleasant is it to use the language's build tools (e.g. compiler, linter/type checker, dependency manager, etc.) and text editor tools (e.g. ease of setup, refactoring support, pop-up documentation, etc.)?

The build tools are pretty good. One will typically use a `Bower`-based workflow or a `psc-package`-based workflow. These are explained in `Build Tools/Tool Comparisons/Dependency Managers.md`.

See the `Build Tools/` folder for more up-to-date information. Likewise, see [Editor and Tool Support](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md) for other editor-related configurations.

#### How friendly, helpful, responsive, inspiring, determined, and collaborative are the people who use and contribute to this language and its ecosystem?

People usually get help from some of the core contributors or other well-informed people via the `#purescript` and `#purescript-beginners`. For longer threads, some post on the [PureScript Discorse Forum](https://discourse.purescript.org)

The language's development is currently slow because each core contributor have full-time jobs and contribute in their spare time, not because they don't want to.

#### What problems do developer teams typically encounter when migrating from Language X to PureScript and how hard are these to overcome?

- See Phil Freeman's own blog post on the matter: [PureScript and Haskell at Lumi](https://medium.com/fuzzy-sharp/purescript-and-haskell-at-lumi-7e8e2b16fb13)
- [(Video) JavaScript to PureScript - a Migration Story](https://www.youtube.com/watch?v=bt130Z7UNPE&list=WL&t=0s&index=23) & [Slides](https://github.com/lambdaconf/lambdaconf-2018/blob/master/LC18-slides/Curran-angular-purescript-halogen.pdf)
- Likewise, see [Introducing Haskell to a Company](https://alasconnect.github.io/blog/posts/2018-10-02-introducing-haskell-to-a-company.html), which can equally apply to Purescript
- See [Robert Kluin - Introducing A Functional Language At Work - λC 2018](https://www.youtube.com/watch?v=3USNLflRRUA)/[slides](https://github.com/lambdaconf/lambdaconf-2018/blob/master/LC18-slides/A%20Developer%E2%80%99s%20Guide%20to%20Introducing%20A%20Functional%20Language%20At%20Work.pdf) for a cautionary tale of "what can go wrong and why" when he attempted to introduce Scala at work.

## Establishing Culture

Some might say that PureScript is dead, bad, stupid, not worth learning,  etc. In response to these things, I'd recommend you watch [The Hard Parts of Open Source](https://www.youtube.com/watch?v=o_4EX4dPppA)
