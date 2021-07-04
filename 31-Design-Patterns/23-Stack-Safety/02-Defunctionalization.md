# Defunctionalization

Or converting recursive stack-unsafe code into stack-safe code

See these resources:
- [Don't Think, Just Defunctionalize](https://www.joachim-breitner.de/blog/778-Don%E2%80%99t_think%2C_just_defunctionalize)
- [The reasonable effectivness of the ConT monad](https://blog.poisson.chat/posts/2019-10-26-reasonable-continuations.html)
- [The best refactoring you've never heard of](https://web.archive.org/web/20201107223338/http://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html)

The rest of this page will do two things:
1. Provide a few examples showing the simple but stack-unsafe code and its corresponding stack-safe but complex code.
2. Provide general principles to follow to help you figure out how to write stack-safe code for any given situation.

## Stack-Safety: Opening Example

The below examples move from simple to more complex. Start with the first one to get a general idea, make sure you understand it well, and only then move on to the next example.

### Mapping a list from the last element to the first

Let's say one had to change every element in a `List a` from type `a` to `b`. You're thinking, "That's easy. We'll just use `map`." Correct.

But, let's add a new constraint: you must change the elements in a specific order. The first element you need to change is the last one in the list and the last element you should change is the first element in the list. In other words, a list like `4 : 3 : 2 : 1 : Nil` should have `1` changed first and `4` changed last.

"Phwah!" you say. "I'll just use `reverse <<< map f <<< reverse` and call it a day!" As easy as that is to write, that will iterate through the list 3 times. Not the most performant thing in the world.

So, you might write something like the following stack-unsafe code which iterates through a list twice, once as it descends down the list, and once as it ascends back up the list while constructing the returned value:
```purescript
mapLastElemFirst_unsafe :: forall a b. (a -> b) -> List a -> List b
mapLastElemFirst_unsafe f = case _ of
  Nil -> Nil
  Cons h tail -> do
    let newTail = mapLastElemFirst_unsafe f tail -- stack unsafe!
    Cons (f h) newTail
```

While the above code is short and easy to read, it'll also cause a stack-overflow error if you give it a large enough list.

A stack-safe version of the above code might look like this. Unfortunately, it's not as easy to read if you're not familiar with this style of writing. However, it only iterates through the list twice, similar to the stack-unsafe version, and it will never throw a stack-overflow error:
```purescript
mapLastElemFirst_safe :: forall a b. (a -> b) -> List a -> List b
mapLastElemFirst_safe f ls = go Nil (Left ls)
  where
  -- To keep track of "where" we are in the data structure, we'll
  -- maintain our own stack of what else still needs to be done.
  --
  -- `Left` values represent items in the tree we haven't yet examined
  -- and/or changed.
  -- `Right` values represent either the final list or the current state
  -- of the final list as we are constructing it.
  go :: List a
     -> Either (List a) (List b)
     -> List b
  go stack = case _ of
    Left (Cons h tail) ->
      -- we've hit the next element in the list
      -- remember, we can't modify the value of type `a`
      -- represented by `h` by calling `f h` because
      -- this might not be the last element.
      go (h : stack) (Left tail)

    Left Nil ->
      -- we've hit the end of the list
      -- we can now start consuming the stack we've created
      go stack $ Right Nil

    Right val ->
      -- `val` is either the final list or a portion of that final list
      -- because we're still constructing it.
      case stack of
        -- `a` is the element next closest to the end of the original list.
        -- We've already changed all elements after it
        -- so we can now map it's type from `a` to `b`.
        Cons a rest -> do
          let b = f a
          go rest $ Right (b : val)

        -- the stack is now empty; there's no more elements to map.
        -- So, we return the final value
        Nil -> val
```

To see the unsafe version fail and the safe version succeed with the same large input, see the [Writing Stack-Safe Code - Part 1](https://try.purescript.org/?gist=ae3abb190145838cffbe4a256ac0d123).

### Zipping two lists together with one in reverse

While the previous example is not the most realistic thing ever, it does set us up for the next twist. Let's say you need to zip two lists together where one has values in the opposite order (e.g. `4 : 3 : 2 : 1 : Nil`) and the other has values in the normal order (e.g. `1 : 2 : 3 : 4 : Nil`) . Your goal is to get the following `(Tuple 1 1) : (Tuple 2 2) : (Tuple 3 3) : (Tuple 4 4) : Nil`.

You're right. Calling something like `zipOpposingOrder revList normList = zip (reverse revList) normList` might be the easier and better thing to do. Still, you might have some circumstances where a variation of this idea forces you to do things differently. Fortunately, our example above only needs to change slightly.

The stack-unsafe code:
```purescript
zipOpposingOrder_unsafe :: forall a b. List a -> List b -> Maybe (List (Tuple a b))
zipOpposingOrder_unsafe revList normalList = map snd $ go revList normalList
  where
  go :: List a -> List b -> Maybe (Tuple (List a) (List (Tuple a b)))
  go revRemaining normalRemaining = case normalRemaining of
    Nil ->
      Just $ Tuple revRemaining Nil

    Cons headB tail -> do
      -- We're using the Maybe monad here to make this easier to read.
      -- A `Nothing` will be produced if the normal list had more elements
      -- than reversed one did at this particular level or
      -- if either one of the lists did at a deeper level

      -- finish zipping the tail first and return the remaining
      -- elements from the `revRemaining` list
      Tuple newRevRemaining newTail <- go revRemaining tail

      -- if the `newRevRemaining` has a value, zip it with this
      -- level's value, and return the tail for the parent's
      -- computation (if any)
      { head: headA, tail: revTail } <- uncons newRevRemaining
      pure $ Tuple revTail $ Cons (Tuple headA headB) newTail
```

Again, the above code is straight forward, but it'll cause a stack-overflow error if you give it a large enough input.

A stack-safe version of the above code might look like this:
```purescript
zipOpposingOrder_safe :: forall a b. List a -> List b -> Maybe (List (Tuple a b))
zipOpposingOrder_safe reveredList normalList = go reveredList Nil (Left normalList)
  where
  -- To keep track of "where" we are in the data structure, we'll
  -- maintain our own stack of what else still needs to be done.
  --
  -- `Left` values represent items in the normal list we haven't yet changed.
  -- They will appear in a reversed order when we start consuming them.
  --
  -- `Right` values will either be the final list or the current state
  -- of the final list as it is being built.
  go :: List a
     -> List b
     -> Either (List b) (List (Tuple a b))
     -> Maybe (List (Tuple a b))
  go revList stack = case _ of
    Left (Cons head tail) ->
      -- we've hit the next element in the list
      -- remember, we can't merge the head value yet
      -- because it might not be the last element.
      go revList (head : stack) (Left tail)

    Left Nil ->
      -- we've hit the end of the normal list
      -- we can now start consuming the stack we've created
      go revList stack $ Right Nil

    Right val ->
      -- `val` is either the end of the final list (i.e. `Nil`)
      -- or the current state of the final list since we're
      -- still in the process of creating it.
      -- We need to look at the stack to see what to do
      case stack of
        -- `b` is the element next closest to the end of the normal list
        -- so we can now zip it together with the revList's next element
        -- (if it exists)
        Cons b restB -> case revList of
          Cons a restA ->
            go restA restB $ Right $ (Tuple a b) : val

          Nil ->
            Nothing -- more elems in normalList than in reversedList

        -- the stack is now empty, so we return the final list
        -- (assuming there wasn't any other values left in the reverse list).
        Nil -> case revList of
          Nil -> Just val
          Cons _ _ -> Nothing -- more elems in reversedList than in normalList
```

To see the unsafe version fail and the safe version succeed with the same large input, see the [Writing Stack-Safe Code - Part 2](https://try.purescript.org/?gist=bb07a6e6b39ea5acd547e6d8ccf1ca80).

### Topologically sorting a graph

See [`topologicalSort` from `purescript-graphs`](https://github.com/purescript/purescript-graphs/blob/v5.0.0/src/Data/Graph.purs#L66-L114). We'll cover the types first and then explain each step in the computation.

First, `SortState` stores 1) the final `result` that will be returned, which is either the final list or the current state of that still-being-constructed final list, and 2) the map of not yet visited keys. For this version of an FP graph, the map keys are directed edges that point towards a vertex and all other edges to which the vertex is connected and points. These keys will be removed from the map after they have been visited.

Second, `SortStep` indicates two actions via defunctionalization:
- `Visit` means add the current key (i.e. edge) to the returned list and then add all of the edges coming out of the vertex to the stack, so that they can be visited, too.
- `Emit` means the key has already been visited and doesn't need to be checked again. Rather, add it to the final list that will be returned

Below is a general explanation of the control flow:
1. Visit the first smallest key. Indicate that the key should be added to the final list via `Emit` and indicate that all of its relationships should be examined via `Visit`, remove the key from the keys map, then loop.
2. Visit the first key's first relationship. If it hasn't already been visited, do the same as step 1. If it has been visited, just loop.
3. At some point, the first key and all of its relationships will have been visited, and the stack will be a topologically-sorted list in reverse. All of its values will be `Emit key`. For example, it may store, `Emit 5 : Emit 4 : Emit 3 : Emit 2 : Emit 1 : Nil`, when the final list should be `1 : 2 : 3 : 4 : 5 : Nil`.
4. Now the stack is reversed, producing the final topologically-sorted list and storing it in `result`.
5. Since the stack is empty, the `visit` loop stops. We return to the `go` loop and find the next smallest key, repeating steps 1 - 5.
6. At some point, there are no more smallest keys because all keys have been visited. Thus, we get a `Nothing` in the `go` loop and we return the `result`, which is now a topologically-sorted list.

## Principles

1. Write a simpler stack-safe function that isn't performant (e.g. `reverse <<< map f <<< reverse`)
1. Once you know you need the performance, write a stack-unsafe function first that solves the problem
1. Make the function tail-recursive by calling the same function on every possible path except one
1. Use defunctionalization to indicate what should happen in each loop.
    - Is it easier to read if you use explicit data constructors (e.g. `Visit` and `Emit` in the above graph example) or do you just need to distinguish between two states (e.g. `Either` in the above `mapLastElemFirs` List examples)?
1. Write the code "in order" of how it would execute. First X occurs, then Y, then Z.
1. Figure out what the stack should look like.
    - Is it a simple `List a` or something more complicated like `List (Either a b)`?
