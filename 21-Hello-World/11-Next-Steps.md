# Next Steps

## Style Guide for Libraries

If you ever want to write your own PureScript library, review the following (somewhat outdated) guidelines: [PureScript's Style Guide](https://github.com/purescript/documentation/blob/master/guides/Style-Guide.md)

## Exploring Projects

Rather than combining multiple projects into this folder as was done previously, we link to projects that are standalone. This provides easier navigation through the code and encourages you to checkout the code locally to try it there.

### Simple Projects Following a Domain-Driven-Design

The below programs were written by me when I was first learning how to design programs using modern FP architecture. This approach to writing programs tends to follow a domain-driven design by categorizing code into one of five layers:

| Layer Level | Onion Architecture Term | General idea |
| - | - | - |
| Layer 4 | Core | Strong types with well-defined properties and their pure, total functions that operate on them |
| Layer 3 | Domain | the "business logic" code which uses effects |
| Layer 2 | API | the "production" or "test" monad which "links" these effects/capabilties with their corresponding implementations: a newtyped `ReaderT` and its instances |
| Layer 1 | Infrastructure | the platform-specific framework/libraries we'll use to implement some special effects/capabilities (i.e. `Node.ReadLine`/`Halogen`/`StateT`) |
| Layer 0 | Main<br>(no equivalent onion term) | the program's entry point<br>the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`) |

- [Random Number Game](https://github.com/JordanMartinez/purescript-random-number-game) - a very simple game that runs on the console and in the browser using the same "business logic".
- [Mdbook ToC Generator](https://github.com/JordanMartinez/purescript-mdbook-generator) - Not explained with a "Design Thought Process" file. A script that produces the necessary table of contents file used by `mdbook` to produce the website for this work.

### Other "Example Projects"

- [hdgarrood's 'MultiPac' project](https://github.com/hdgarrood/multipac)
- [thomashoneyman's 'Real World App' (Halogen version)](https://github.com/thomashoneyman/purescript-halogen-realworld)
- [jonasbuntinx' - 'Real World App' (React Version)](https://github.com/jonasbuntinx/purescript-react-realworld)
- [jaspervdj's 'Beeraffe' game](https://github.com/jaspervdj/beeraffe/)
- [AndrewBrownK's 'Minesweeper CLI' game](https://github.com/AndrewBrownK/purescript-minesweeper-cli)
- [`aftok`](https://github.com/aftok/aftok)

### Projects in non-JS backends

- [Lambda Lantern](https://lettier.itch.io/lambda-lantern)
