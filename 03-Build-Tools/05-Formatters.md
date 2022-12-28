# Formatters

## History

For the longest time, PureScript did not have a formatter. There are a number of reasons:
1. Since `PureScript` is written in Haskell, people are less likely to contribute since Haskell is still different from PureScript (even if they share similarities).
     1. Ideally, `PureScript` would be written in PureScript. Unfortunately, if `PureScript` was self-hosted, runtime performance of the `purs` binary would suffer greatly otherwise. See [purescript/purescript-in-purescript](https://github.com/purescript/purescript-in-purescript), which was stopped after that realization was made.
     2. Realistically, a formatter could be written in Haskell and reuse the PureScript language's parser. However, then less people would contribute as not everyone is familiar with Haskell
     3. If a formatter was written in PureScript, it would get more contributions. However, it would have to reimplement the PureScript language's parser and stay in sync with any changes made to the language. Moreover, it would likely be slower than writing it in a lower-level language (e.g. Haskell).
1. Writing a formatter is very hard to do. It's typically a feat not done by your beginner or everyday programmer.
1. Once written, maintainers can burn out because many individuals will want configuration added (e.g. "it should indent A in situation Y exactly N spaces but only M spaces in situation Z"). If the configuration is not added, people complain. If it is added, others might later complain about how it has TOO much configuration. Either way, it's typically the maintainer who adds the feature and those who want it don't contribute.

The first formatter written was [`purty`](https://gitlab.com/joneshf/purty). This formatter was written in Haskell. It was the only formatter for a number of years. Some in the community chose to use it while others did not.

Around March/April 2021, `@natefaubion` wrote a PureScript implementation of the PureScript language's parser: [natefaubion/purescript-language-cst-parser](https://github.com/natefaubion/purescript-language-cst-parser).

The second and third formatters, [`purs-tidy`](https://github.com/natefaubion/purescript-tidy) and [`pose`](https://pose.rowtype.yoga/), respectively, were announced around the same time in August 2021. Both projects were under developement without knowing about each other. `purs-tidy` is a standalone formatter whereas `pose` is a plugin for the [`Prettier` formatter](https://prettier.io/). Between these two, we recommend using `purs-tidy`.

## Current Formatters

| Formatter | Language | Author | Initial Announcement |
| - | - | - | - |
| [`purs-tidy`](https://github.com/natefaubion/purescript-tidy) | PureScript | `@natefaubion` | [Announcing `purs-tidy`: a syntax tidy-upper for PureScript](https://discourse.purescript.org/t/announcing-purs-tidy-a-syntax-tidy-upper-for-purescript/2524) |
| [`pose`](https://pose.rowtype.yoga/) | PureScript | `@Zelenaya`/`@i-am-the-slime` | [Tiny announcement: yet another PureScript formatter](https://discourse.purescript.org/t/tiny-announcement-yet-another-purescript-formatter/2525) |
| [`purty`](https://gitlab.com/joneshf/purty) | Haskell | `@joneshf` | [Purty 1.0.0 released](https://discourse.purescript.org/t/purty-1-0-0-released/225) |
