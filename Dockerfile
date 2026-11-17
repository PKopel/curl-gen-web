##### GHC WebAssembly builder ####
FROM node AS wasmbuilder

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    alex curl git jq unzip zstd \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://gitlab.haskell.org/haskell-wasm/ghc-wasm-meta/-/raw/master/bootstrap.sh | FLAVOUR=9.14 sh

COPY wasm /workspace/wasm
COPY static /workspace/static
COPY cabal.project curl-gen-wasm.cabal README.md CHANGELOG.md LICENSE Makefile package.json package-lock.json webpack.config.js /workspace/

RUN . /root/.ghc-wasm/env && make build

#### final app ####
FROM nginx

COPY --from=wasmbuilder /workspace/server /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80