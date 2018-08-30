# Mutable State: Global vs Local

There are two types of mutable state:

| | Global | Local |
| - | - | - |
| Creatable in... | Anywhere | Local scope
| Readable from... | Anywhere that has its reference | Local Scope
| Writable to... | Anywhere that has its reference | Local Scope

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

  public static void example1() {
    // change global state
    GLOBAL_STATE = "first change!"
    // localState changed, but we can't change
    //   it outside of it's scope
    function();
  }

  public static void example2() {
    // change global state again
    GLOBAL_STATE = "second change!"
  }
}
```
