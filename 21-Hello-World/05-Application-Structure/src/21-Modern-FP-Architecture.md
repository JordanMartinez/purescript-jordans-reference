# Modern FP Architecture

## Properties of "Effects"

Now that we have seen the various ways to model "effects," let's talk about the properties of effects and the tradeoffs one makes when committing to either of these approaches.

Read through the first section of [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html).

We will explain and illustrate what is meant by each property

### Extensible

While the above effects (e.g. `MonadState`) are pretty obvious, we might one day wish to define a new effect for handling authentication, `MonadAuthenticate`. If a function that uses state-manipulation effects via `MonadState` now needs to add the "authenticate" effect, it should be easy to add that and not require us to refactor a whole lot of code.

In other words, going from this function ...
```haskell
f :: forall m.
     MonadState m =>
     InitialState -> m OutputtedState
```
... to this function...
```haskell
f' :: forall m.
      MonadState m =>
      MonadAuthenticate m =>
      InitialState ->
      m OutputtedState
```
... should be easy/quick.

### Composable

Composable means using two or more effects in the same function should be lawful.

For example
- `set`ting some state to `5` and later `get`ting that state should return `5`, not `8`, no matter what other effects or computations we run in-between those two calls (e.g. printing some value to the console).
- `catch`ing an error cannot occur unless an error was `throw`n prior to it.
- `ask`ing for a configuration value should return the same value each time no matter what happens before/after that call.

### Efficient

This can be understood a few different ways:
- During runtime: the program runs fast (time-efficient) or uses as little memory as possible (space-efficient)
- During compile-time: the compiler runs fast (time-efficient) or uses as little memory as possible (space-efficient)

I believe the author is referring to the first idea (runtime).

### Terse

We shouldn't have to write boilerplate-y code

For example, we shouldn't have to write
- many lines of code to do one thing
- many types to do one thing

### Inferrable

Related to `Terse`, we shouldn't have to annotate code (e.g. wrapping `value` with its type annotation: `(value :: { name :: String, age :: Int })` )


## Key Articles

Now might be a good time to re-read these articles:
- [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html)
- [Three Layer Haskell Cake](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html)
- [the `ReaderT` Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)
- [the Capability Design Pattern](https://www.tweag.io/posts/2018-10-04-capability.html)
- [A Modern Architecture for FP: Part 1](http://degoes.net/articles/modern-fp)
- [A Modern Architecture for FP: Part 2](http://degoes.net/articles/modern-fp-part-2)
- [Freer Monads, More Better Programs](reasonablypolymorphic.com/blog/freer-monads/index.html)
- [Freer doesn't come for free](https://medium.com/barely-functional/freer-doesnt-come-for-free-c9fade793501)

## Evaluating MTL and Free

Alexis King recently recorded a very clear explanation of some of the tradeoffs of effect systems. While her video is in Haskell, the implications are worth thinking about in PureScript:
- [Alexis King - “Effects for Less” @ ZuriHac 2020](https://www.youtube.com/watch?v=0jI-AlWEwYI)

Let's now use the above post's criteria for each approach. The following is my guess at where things stand^^:

| | Extensible? | Composable? | Efficient? | Terse? | Inferrable?
| - | - | - | - | - | - |
| MTL | Yes via the Capability Design Pattern | Yes via newtyped monadic functions? | ? | ~`n^2` instances for `Monad[Word]`<br>boilerplate capability type classes | ? |
| Free/Run | Yes via open rows and `VariantF` | Yes via embedded domain-specific languages | ? | boilerplate smart constructors | ? |

^^ Note: The `MTL vs Free` debate is pretty heated in FP communities.

In the `Hello World/Games` folder, we'll implement the same programs for each concept mentioned above as more concrete examples.

## Reducing Boilerplate via Atom's Snippets Feature

If you are using Atom as your editor, you can use snippets to help reduce the boilerplate required to write these things.

1. Open the preferences tab (`CTRL+,`)
2. Click on the "Open the Config Folder" button
3. Open the `snippets.cson` file
4. Copy and paste the below content into the file

```cson
'.source.purescript':
  'Run Type':
    'prefix': 'runType'
    'body': """
      data ${1:Type_Name} a
        = -- create data constructors via a different snippet

      derive instance Functor ${1:Type_Name}

      _${2:symbol} = Proxy :: Proxy "${2:symbol}"

      type ${3:ALL_CAPS_TYPE_NAME} r = (${2:symbol} :: FProxy $1 | r)
    """

  'Run Smart Constructor':
    'prefix': 'runSmartConstructor'
    'body': """
      ${1:DataConstructor} ${2:Args}

      ${3:smartConstructorName} :: forall r. ${4:args} Run (${5:Type_Alias} + r) ${6:Return_Type}
      ${3:smartConstructorName} ${7:valueArgs} = lift _${8:symbol} $ ${1:Data_Constructor} ${7:valueArgs} ${9:identityOrUnit}
    """

  'ReaderT Design Pattern (AppM)':
    'prefix': 'appM_via_ReaderT'
    'body': """
      newtype AppM a = AppM (ReaderT Env Aff a)

      runAppM :: Env -> AppM ~> Aff
      runAppM env (AppM m) = runReaderT m env

      instance TypeEquals e Env => MonadAsk e AppM where
        ask = AppM $ asks from

      derive newtype instance Functor AppM
      derive newtype instance Apply AppM
      derive newtype instance Applicative AppM
      derive newtype instance Bind AppM
      derive newtype instance Monad AppM
      derive newtype instance MonadEffect AppM
      derive newtype instance MonadAff AppM
      """

  'ReaderT Design Pattern (TestM)':
    'prefix': 'testM_via_ReaderT'
    'body': """
      newtype TestM a = TestM (ReaderT Env Identity a)

      runTestM :: Env -> TestM a -> a
      runTestM env (TestM program) =
        let (Identity a) = runReaderT program env
        in a

      instance TypeEquals e Env => MonadAsk e TestM where
        ask = TestM $ asks from

      derive newtype instance Functor TestM
      derive newtype instance Apply TestM
      derive newtype instance Applicative TestM
      derive newtype instance Bind TestM
      derive newtype instance Monad TestM
      """
```
