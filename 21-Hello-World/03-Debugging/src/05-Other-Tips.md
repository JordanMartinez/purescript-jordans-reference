# Other Tips

This file includes tips I've seen people share in the PureScript chatroom:

> How do you guys typically go about debugging runtime issues? Especially bad FFI interactions? Right now I end up using `Debug.Trace` pretty frequently. I’m trying to move toward a workflow where I can resolve more of these issues with automated testing and in the REPL. I think the REPL is probably the way to go for most logic issues in PS? However, if API definitions are wonky in the FFI then the REPL isn’t generally super useful since I’ll just get some error from deep in the bundle in some dependency typically.

From `@kritzcreek`:
> I use `Debug.Trace` and break points in the browser. In general, I minimize having to interact with the FFI. If you're crossing the boundary too often maybe you can change your design to move more into PS or isolate and group the FFI interactions more clearly. I rarely use the REPL at all, parcel or webpack reloading the webpage on change in my editor is fast enough for my feedback cycle needs
