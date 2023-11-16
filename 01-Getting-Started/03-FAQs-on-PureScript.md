# FAQs on PureScript

I'll answer a few possible questions the below audiences may have:
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

The average time for learning FP languages in general is usually 3-6 months due to the below reasons. This repository hopes to speed that process up, but, as always, people learn at different paces:
- Many tutorials/guides assume their readers already know foundational principles. New learners who read them often do not know, nor are even aware of, those foundational principles.
    - This project's `Hello World/FP Philosophical Foundations` folder exists to counter this issue
- No one really explains what the "big picture" that FP programming is all about. Thus, it's hard to see how some concept fits in the larger scheme of things, much less why that concept is so fundamental to everything.
    - See this project's `Hello World/FP Philosophical Foundations/07-FP--The-Big-Picture.md` file
- People (wrongly) believe that they must know a very abstract mathematics called "Category Theory" in order to use/write PureScript or another FP language. Due to its very abstract nature, Category Theory can be difficult to grasp and scares people off.
    - This "myth" is false. Most FP developers do not understand Category Theory and yet they already have an intuition for some of its ideas.
- The syntax for FP languages are paradigmatically different than the syntax with which most developers are familiar (C/Java/Python). It takes a while to get used to a "different" syntax family before it feels normal. Until it feels normal, reading through code examples will be harder.
    - This project's `Syntax` folder exists to counter the above issue.
- Related to the above, FP languages often use symbol-based aliases to refer to functions that are well-known to FP Programmers instead of those functions' literal names (e.g. `<$>` instead of `map`, `<$` instead of `voidRight`, `$>` instead of `voidLeft`). It's more concise and similarities between these symbol-based aliases add meaning to them, such as their "direction." Since new learners do not already know that to which function a symbol refers, it can be hard to know what that function even does.
    - [A Pursuit search for the symbol (e.g. `<$>`)](https://pursuit.purescript.org/search?q=%3C%24%3E) fixes this problem
    - This project's `Type Classes/ReadMe.md#Functions` section explains how to read the `Type Classes/assets/Type-Class-Functions.xlsx` file, which provides a table that indicates what those symbol-based fuction names are and from where they come.
- Due to their powerful type systems, FP languages trade errors that occur when running the program (runtime errors) with errors that occur when attempting to build the program via the compiler (compile-time errors). To understand how to debug these compile-time "your program would not work if it was built" errors, one must have a strong understanding of how the compiler and its type system works.
    - This project's `Syntax` folder (and more specifically, the `Syntax/Type-Level Programming Syntax` folder) explain enough to help one understand why some (but not all) problems arise.
    - The [Error Documentation](https://github.com/purescript/documentation/tree/master/errors) sometimes explains what the error is and how to fix it ([example](https://github.com/purescript/documentation/blob/master/errors/NoInstanceFound.md)) and other times is simply left unexplained ([example](https://github.com/purescript/documentation/blob/master/errors/AmbiguousTypeVariables.md)).
    - The PureScript Discord server is active and often helps people troubleshoot the error messages.
- Related to the above point, the powerful type system enables one to model some abstract ideas in a very precise way using well-defined types or things called type classes. When these features start to stack, a new learner can become overwhelmed.
    - If one reads this work in order, they are unlikely to be overwhelmed.
    - Most of the "cool type things" one can do are helpful but not always necessary. Consider [the Haskell Pyramid](https://patrickmn.com/software/the-haskell-pyramid/). "Monads" are an important and fundamental FP concept, but new learners do not need to learn what they are or how to use them right away.
- Many people try to re-explain something that another has already explained well and they write a poor re-explanation. It's hard to determine which explanations are accurate and correct and which are vague and mistaken until after you have already read it and/or know better.
    - I've been you. This work is my attempt to sift through the noise and present things in the best and simplest way possible. In various cases, I summarize and/or link to other posts that I believe to be credible that also explain a concept clearly. My sources include `Haskell Weekly`, the PureScript Discord server, a number of books I've read on FP programming, a number of papers I've read on FP programming, and various videos I've watched regarding FP programming.
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

It's primarily good for front-end work and not so much (yet) for back-end work. When it is lacking, one will likely need to use FFI to utilize JS libraries. See [awesome-purescript](https://github.com/passy/awesome-purescript) and the documentation site, [Pursuit](http://pursuit.purescript.org/).

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
