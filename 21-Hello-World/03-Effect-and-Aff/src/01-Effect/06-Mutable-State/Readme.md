# Mutable State: Global vs Local

There are two types of mutable state:

| | Global | Local |
| - | - | - |
| Creatable in... | Anywhere | Local scope
| Readable from... | Anywhere that has its reference | Local Scope
| Writable to... | Anywhere that has its reference | Local Scope
| Destroyed when... | Program Exits? | Exit Local Scope

Using JavaScript as an example...
```javascript
var global_state = "some state";
var doStuffUsingLocalState() = {
  var local_state = "some value";
  local_state = local_state + "some other string";
  return local_state.length();
}
var example1() {
  // change global state
  global_state = "first change!";
  // localState changed during the execution of the below
  // function, but we can't change it outside of that function.
  doStuffUsingLocalState();
}
example1();
var example2() {
  global_state = "second change!";
  return;
}
example2();
```
