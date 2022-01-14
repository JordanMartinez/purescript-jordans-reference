# Serialization via Codecs

There are generally two ways to do serialization in FP languages
1. Use type classes (e.g. `purescript-argonaut-*` / `simple-json`)
2. Use handwritten profunctor-based code (e.g. `purescript-codec-*`)
3. Generate codecs (type-class or value-based codecs) via [`tidy-codegen`](http://blog.ezyang.com/2014/05/parsec-try-a-or-b-considered-harmful/)

Of the two approaches, I prefer the second one, largely because of the reasons explained in [Thoughts on Type Class Codecs](http://code.slipthrough.net/2018/03/13/thoughts-on-typeclass-codecs/).
