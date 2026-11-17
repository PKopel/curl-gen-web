# curl-gen-web

Webb app for curl scripts generation using [curl-gen](https://github.com/PKopel/curl-gen) library.
Haskell code is compiled to WebAssembly using the GHC 9.14 WASI backend.

## Try it out

<https://pkopel.github.io/curl-gen-web/>

## Running locally

* Install the [GHC WASM toolchain](https://gitlab.haskell.org/haskell-wasm/ghc-wasm-meta) with the `9.14` flavour and source `~/.ghc-wasm/env`
* Run `make start` to build and start the server
* Run `make docker` to build docker image of the server
