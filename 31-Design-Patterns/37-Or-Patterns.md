# Or Patterns

PureScript does not (yet?) support the concept of "or patterns" in its pattern matching. For example, we write this...
```purs
foo = case _ of
  "a" -> 1
  "b" -> 1
  "x" -> 2
  "y" -> 2
  _ -> 3
```

rather than this hypothetical syntax where the branch is only written once:
```purs
foo = case _ of
  "a" | "b" -> 1
  "x" | "y" -> 2
  _ -> 3
```

## First-Class Pattern Guards

However, one could get around this problem via using [First-Class Pattern Guards](https://kenta.blogspot.com/2022/04/xcruhlyr-first-class-pattern-guards-in.html), which is basically Call-Passing Style (CPS).
