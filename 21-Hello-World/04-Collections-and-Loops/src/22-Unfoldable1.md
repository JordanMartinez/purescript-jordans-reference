# Unfoldable1

This is the same as `Unfoldable` except the returned `t` value must always have at least 1 `a` value. As a result, it's actually harder to find a data type that can **only** implement `Unfoldable1` but can't implement `Unfoldable`.

## Definition

### Code Definition

```haskell
class Unfoldable1 t where
  unfoldr1 :: forall a b. (b -> Tuple a (Maybe b)) -> b -> t a
```

The only difference between `Unfoldable` and `Unfoldable1` is the type signature for `f`. In both cases, the `b` value is inside of a `Maybe`:
```haskell
-- Unfoldable
f :: forall a b. b -> Maybe (Tuple a b)

-- Unfoldable1
f :: forall a b. b -> Tuple a (Maybe b)
```

## Laws

None

## Derived Functions

### Parallels to `Unfoldable`

| Concept | Unfoldable<br>(`t` can be empty) | Unfoldable1<br>(`t` can't be empty) |
| - | - | - |
| Produce a `t` value | `none` | [`singleton`](https://pursuit.purescript.org/packages/purescript-unfoldable/docs/Data.Unfoldable1#v:singleton) |
| Add an `a` `n`-many times to a `t` container | `replicate` | [`replicate1`](https://pursuit.purescript.org/packages/purescript-unfoldable/docs/Data.Unfoldable1#v:replicate1) |
| Run an applicative-based computation `n`-many times and store the results in a `t` container | `replicateA` | [`replicate1A`](https://pursuit.purescript.org/packages/purescript-unfoldable/docs/Data.Unfoldable1#v:replicate1A) |
| Convert `Maybe a` to `t a` | `fromMaybe` | possible, but not implemented |

`Unfoldable1` does not have a version of `fromMaybe` included, but I believe it is possible if one places a `Monoid` constraint on `a` and uses `mempty` when receiving a `Nothing` case.

### Specific to `Unfoldable1`

- [`range`](https://pursuit.purescript.org/packages/purescript-unfoldable/4.1.0/docs/Data.Unfoldable1#v:range)
