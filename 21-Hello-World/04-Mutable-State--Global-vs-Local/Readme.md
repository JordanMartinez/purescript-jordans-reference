# Mutable State: Global vs Local

There are two types of mutable state"
- "global" - can be modified by anyone that has a reference to the variable
- "local" - can be modified only in a specific scope.

Using Java as an example...
```java
public class StateExample {
  // note the absence of "final"
  public String GLOBAL_STATE = "some state"

  public static int function() {
    String localState = "some value"
    localState = localState + "some other string"
    return localState.length();
  }

  public static void example() {
    GLOBAL_STATE = "changed to something else!"
    // localState changed, but we can't change
    //   it outside of it's scope
    function();
  }
}
```

Look at the `src/` directory for examples on their API.
