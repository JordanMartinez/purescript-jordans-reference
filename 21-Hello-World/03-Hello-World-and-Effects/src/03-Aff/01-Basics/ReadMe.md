# Aff Basics

This folder shows some of the API of `Aff`. As stated before, all applications (not libraries) must be started in the `Effect` monad (or `Eff` if that's what you're using instead). Since "monads don't compose," we normally would not be able to use/compute in a different monadic context. However, `Aff` provides a function called `launchAff`/`launchAff_` that allows us to run an `Aff` computation while in an `Effect` monadic context.

Normally, we've been printing values to the screen via `log`. That function's type signature is `String -> Effect Unit`. Since "monads don't compose," we can't normally use that function inside an `Aff` monadic context. For the time being, we will work around that problem by using a special function called `specialLog`. We'll explain how that's possible in the next folder, `Lifting Monads`, but for now just read it like you would `log`.
