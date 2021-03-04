# From Either to Variant

## Adding More Conditions

Let's forget `Coproduct` for a moment and return back to the `Either` level. When we are writing code, we often need to refactor things. If we are using nested `Either` types everywhere, there are three ways we could change our code:
1. Change the order of the types position: `Either first second` <=> `Either second first`
2. Add/Remove another type: `Either first (Either second third)` <=> `Either first second`
3. Change one type to another: `Either Int Int` <=> `Either Int String`

If we made one of the changes above, we would need to change our function's type signatures slightly just to get the code to compile again. If we must do this after writing 20 functions, that's a lot of wasted development time!

Moreover, `purescript-either` only grants us the ability to define 10 total types in a nested manner. Once we go above that number, we need to write our own convenience functions. If we do this in multiple projects, that's more wasted developer time.

So, what are our options here? We saw previously that we could not define our own special nested `Either` type without knowing at the type-declaration-time what the next few types are. However, we do know at compile-time what those types will be. We also know at compile-time how many types will exist in a nested `Either`-like type. This implies that we might want to stop looking at value-level programming for our solutions and instead look at type-level programming. More specifically, we should look at row kinds.

We can use row kinds specified to type (i.e. `# Type`) to specify n-different types that are known at compile-time. As an example, we can look at `Record`, which is a nested `Tuple` that uses row kinds to work:
```haskell
-- first AND second AND third AND fourth AND last
Tuple first (Tuple second (Tuple third (Tuple fourth last)))
Record (a :: first, b :: second, c :: third, d :: fourth, e :: last)
-- which is more commonly seen using "{}" syntax
       {a :: first, b :: second, c :: third, d :: fourth, e :: last}
```
Is it possible to take this same idea and apply it to `Either`? Yes, which is what `purescript-variant` does:
```haskell
-- first OR second OR third OR fourth OR last
Either first (Either second (Either third (Either fourth last)))
Variant (a :: first, b :: second, c :: third, d :: fourth, e :: last)
-- Unfortunately, there is no equivalent "{}"-like syntax for variants
```
The advantage of using the row kinds via `# Type` is that it makes our nested `Either` type "open" via row polymorphism. Using `Record` as an example, we'll see that each of the three "prototype code" requirements from above can be achieved without refactoring!

Looking at our requirements from before...
1. Change the order of the types position: `Either first second` <=> `Either second first`
2. Add/Remove another type: `Either first (Either second third)` <=> `Either first second`
3. Change one type to another: `Either String Boolean` <=> `Either Int Boolean`

... we can see that `Record` meets our requirements because of row polymorphism:
```haskell
-- the function
getName :: forall allOtherFields. { name :: String | allOtherFields } -> String
getName :: { name: theName } = theName

-- normal version
getName { name: "John", dogName: "Spot" }
-- 1) changed type's order
getName { dogName: "Spot", name: "John" }
-- 2a) added a type
getName { name: "John", dogName: "Spot", age: 20 }
-- 2b) removed a type
getName { name: "John" }
-- 3) changed "dogName" from type `String` to `DogNames`
getName { name: "John", dogName: Spot }
```
All five exampls from above compile. Since `Variant` uses row kinds via `# Type`, too, it also benefits from these advantages.

## Using Variant

Here's the link to the library: [`purescript-variant`](https://pursuit.purescript.org/packages/purescript-variant/5.0.0).

`Record` has support at the syntax-level in Purescript. So, instead of writing `Record (key :: ValueType)`, we can write `{key :: ValueType}`. Unfortunately, `Variant` is not supported at the syntax-level. Thus, we must be explicit and use type-level programming. The following code shows how to write `inject` and `project` via `Variant` and `Symbol`s, type-level `String`s.

**If you haven't already done so, read through the Syntax folder on Type-Level Programming Syntax**

### Injection

```haskell
injectFruit :: forall v. Fruit -> Variant (fieldName :: Fruit | v)
injectFruit fruit = inj (Proxy :: Proxy "fieldName") fruit
```

### Projection

```haskell
projectFruit :: forall v. Variant (fieldName :: Fruit | v) -> Maybe Fruit
projectFruit variant = prj (Proxy :: Proxy "fieldName") variant
```

### Pattern Matching in Variant

The other functions that `Variant` provides can be see via its [docs](https://pursuit.purescript.org/packages/purescript-variant/5.0.0/docs/Data.Variant#v:on). I created the following table after looking at the project's [test's source code](https://github.com/natefaubion/purescript-variant/blob/v5.0.0/test/Variant.purs). Some functions seem to exist to fit different people's syntax preferences:

| Exhaustively pattern matches types by... | Allows "open" `Variant` values? | Corresponding function's syntax
| - | - | - |
| Providing default value for missing cases | Yes | `default defaultValue <combinator chain> variantArg` |
| Matching all cases | No | `match { eachField: (\a -> {- body for each field -}) } variantArg` |
| Matching all cases | No | `case_ <combinator chain> variantArg` |

where a `<combinator chain>` is:
- single element chain: `# combinator`
- multi-element chain: `# combinator1 # combinator2 ... # combinatorN`

| Combinator | Expected arguments
| - | - |
| `on` | `(Proxy :: Proxy "fieldName") (\value -> {- body -})`
| `onMatch` | `{ fieldNameN :: (FieldType -> a) }` |

Besides those above, `Variant` also has `expand` and `contract`. One takes a `Variant` that has more fields than just those specified in some function and "expands" it into its full number of nested types. The other takes a fully-expanded `Variant` and "contracts" it down to a smaller subset of its nested types.

## Updating Our Solution

If we return to our `FruitGrouper` solution from before and use `Variant` instead of `FruitGrouper`, here's what we get.

Here's the list of run commands:
- `showFruitVariant (injFruit Apple)`
    - At step 3 below, only
- `showFruitVariant (injFruit2 Orange)`
    - This function **still** works despite `showFruitVariant` never knowing anything about a `Fruit2` type!
- `showFruit2Variant (injFruit3 Cherry)`
    - This function **still** works despite `showFruit2Variant` never knowing anything about a `Fruit3` type!
- `showFruit3Variant (injFruit2 Orange)`
    - This function **still** works despite `showFruit3Variant` never knowing anything about a `Fruit2` type!

For each of the above run commands, do the following to "simulate" one file existing before another one:

1. Start a REPL
2. Copy and paste each "file" below into the REPL.
3. Run the commands at the end of this snippet

```haskell
-- File1's original code: once compiled, it cannot change
import Data.Maybe
import Data.Variant
import Data.Function
import Data.Symbol

data Fruit
  = Apple
  | Banana

showFruit :: Fruit -> String
showFruit Apple = "apple"
showFruit Banana = "banana"

showFruitVariant :: forall v. Variant (fruit :: Fruit | v) -> Maybe String
showFruitVariant = default Nothing
  # onMatch
    { fruit: \appleBanana -> Just (showFruit appleBanana)
    }

injFruit :: forall v. Fruit -> Variant (fruit :: Fruit | v)
injFruit fruit = inj (Proxy :: Proxy "fruit") fruit

-- File 2. This should work without the previous file being recompiled
data Fruit2 = Orange

showFruit2 :: Fruit2 -> String
showFruit2 Orange = "orange"

showFruit2Variant :: forall v
                     . Variant (fruit2 :: Fruit2 | v)
                    -> Maybe String
showFruit2Variant = default Nothing
  # onMatch
    { fruit2: \orange -> Just (showFruit2 orange)
    }

injFruit2 :: forall v. Fruit2 -> Variant (fruit2 :: Fruit2 | v)
injFruit2 fruit2 = inj (Proxy :: Proxy "fruit2") fruit2

-- File 3. This should work without the previous 2 files being recompiled
data Fruit3 = Cherry

showFruit3 :: Fruit3 -> String
showFruit3 Cherry = "cherry"

showFruit3Variant :: forall v
                     . Variant (fruit3 :: Fruit3 | v)
                    -> Maybe String
showFruit3Variant = default Nothing
  # onMatch
    { fruit3: \cherry -> Just (showFruit3 cherry)
    }

injFruit3 :: forall v
          -> Fruit3
           . Variant (fruit3 :: Fruit3 | v)
injFruit3 fruit3 = inj (Proxy :: Proxy "fruit3") fruit3
```
Now run the following commands in the REPL:


Amazing!
