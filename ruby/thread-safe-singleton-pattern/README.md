# Thread Safe Singleton Pattern

The Ruby stdlib `Singleton` module is already thread-safe, but if you aren't using it , here is one such pattern to make your own singleton pattern thread-safe.

This covers the case where your singleton instance should be shared globally, across all threads of the program. This is almost always the behavior you want from a singleton, which is why it is presented here.

## Run Example

The example is a self-contained implementation and test. One test fails because it uses an implementation that is not thread-safe.

Run it with:

```
make run
```
