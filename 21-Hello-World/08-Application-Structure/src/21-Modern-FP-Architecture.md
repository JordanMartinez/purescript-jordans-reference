# Modern FP Architecture

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

Let's now examine one post's criteria for each approach. The following is my guess at where things stand^^:

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

      derive instance functor${1:Type_Name} :: Functor ${1:Type_Name}

      _${2:symbol} = SProxy :: SProxy "${2:symbol}"

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

      instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
        ask = AppM $ asks from

      derive newtype instance functorAppM :: Functor AppM
      derive newtype instance applyAppM :: Apply AppM
      derive newtype instance applicativeAppM :: Applicative AppM
      derive newtype instance bindAppM :: Bind AppM
      derive newtype instance monadAppM :: Monad AppM
      derive newtype instance monadEffectAppM :: MonadEffect AppM
      derive newtype instance monadAffAppM :: MonadAff AppM
      """

  'ReaderT Design Pattern (TestM)':
    'prefix': 'testM_via_ReaderT'
    'body': """
      newtype TestM a = TestM (ReaderT Env Identity a)

      runTestM :: Env -> TestM a -> a
      runTestM env (TestM program) =
        let (Identity a) = runReaderT program env
        in a

      instance monadAskTestM :: TypeEquals e Env => MonadAsk e TestM where
        ask = TestM $ asks from

      derive newtype instance functorTestM :: Functor TestM
      derive newtype instance applyTestM :: Apply TestM
      derive newtype instance applicativeTestM :: Applicative TestM
      derive newtype instance bindTestM :: Bind TestM
      derive newtype instance monadTestM :: Monad TestM
      """
```
