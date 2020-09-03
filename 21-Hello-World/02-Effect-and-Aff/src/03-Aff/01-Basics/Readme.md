# Aff Basics

This folder shows some of the API of `Aff`. As stated before, all applications (not libraries) must be started in the `Effect` monad (or `Eff` if that's what you're using instead). An `Aff`-based computation can be converted into an `Effect`-based on by using `launchAff`/`launchAff_`.

So far, we've been printing values to the screen via `log`. That function's type signature is `String -> Effect Unit`. Since the "`bind` outputs the same box-like type it receives" restriction exists, we normally would not be able to use/compute in a different monadic context. For the time being, we will work around that problem by using a special function called `specialLog`. We'll explain how that's possible in the next folder, `Lifting Monads`, but for now just read it like you would `log`.

API not covered here (though it shouldn't be that hard to figure out how it works after reading through these examples and watching Nate's video)
- `supervisor`
- `bracket`
- `killFiber`
