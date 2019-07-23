# Aff Basics

This folder shows some of the API of `Aff`. Normally, we've been printing values to the screen via `log`. That function's type signature is `String -> Effect Unit`. Since "monads don't compose," we can't normally use that function if we are running code in an `Aff` monadic context. For the time being, we will work around that problem by using a special function called `specialLog`. We'll explain how that's possible in the next folder, `Lifting Monads`, but for now just read it like you would `log`.
