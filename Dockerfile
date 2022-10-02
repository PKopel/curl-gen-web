##### haskell wasm builder ####
FROM terrorjack/asterius AS wasmbuilder

WORKDIR /workspace

COPY wasm /workspace/wasm
COPY static /workspace/static
COPY cabal.project curl-gen-wasm.cabal README.md CHANGELOG.md LICENSE /workspace/

RUN ahc-cabal install \
    --builddir /build/ahc-cabal \
    --installdir /build \
    --install-method copy --overwrite-policy always

RUN mkdir -p /build/asterius; \
    ahc-dist \
    --input-exe /build/curl-gen-wasm \
    --output-directory /build/asterius \
    --input-mjs static/index.mjs --no-main --browser \
    --gc-threshold 640

#### node app builder ####
FROM node AS nodebuilder

WORKDIR /workspace

COPY --from=wasmbuilder /build/asterius /build/asterius
COPY static /workspace/static 
COPY package.json webpack.config.js /workspace/

RUN npm install; \
    ASTERIUS_OUTPUT_DIR="/build/asterius" npm run build

RUN ls

#### final app ####
FROM nginx

COPY --from=nodebuilder /workspace/server /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80