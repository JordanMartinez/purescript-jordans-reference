# DebugWarning

`Debug.Trace` uses Custom Type Errors to warn the developer when it is being used.

Let's examine it further since it provides an example for us to follow should we wish to do something similar in the future. The source code is [here](https://github.com/garyb/purescript-debug/blob/v4.0.0/src/Debug/Trace.purs#L8-L8), but we'll provide type signatures for the parts we need below and explain their usage:
```purescript
-- | Nullary type class used to raise a custom warning for the debug functions.
class DebugWarning

instance warn :: Warn (Text "Debug.Trace usage") => DebugWarning

foreign import trace :: forall a b. DebugWarning => a -> (Unit -> b) -> b

-- same idea as 'trace' for all the other functions
```

In short, rather than writing `function :: Warn (Text "Debug.Trace usage") => [function's type signature]` on every function, they use an empty type class whose sole instance adds this for every usage of that type class.
