# Build Tools

Of the PureScript build tools, `pulp` seems to be used the most. [This section](https://github.com/purescript-contrib/pulp#what-if-i-need-something-a-bit-more-complicated) in their documentation summarizes it pretty well.

Unfortunately, `purs-loader` (webpack for PureScript) still has out-of-date examples:
- [psc-package example](https://github.com/ethul/purescript-webpack-example/tree/psc-package)
- [bower / fast rebuild example](https://github.com/ethul/purescript-webpack-example/tree/fast-rebuilds)

[`spago`](https://github.com/purescript/spago) is a more recent development that is picking up steam. It is designed to work well with [`parcel`](https://parceljs.org/)
