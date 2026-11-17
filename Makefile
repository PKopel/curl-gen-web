APP_DOCKER_IMAGE ?= pkopel/curl-gen-server
APP_DOCKER_PORT ?= 8080
BUILD_DIR := ./build
WASM_CABAL_BUILD_DIR := $(BUILD_DIR)/wasm-cabal
WASM_OUTPUT_DIR := $(BUILD_DIR)/wasm


.PHONY: compile
compile:
	wasm32-wasi-cabal build --builddir=$(WASM_CABAL_BUILD_DIR) exe:curl-gen-wasm
	mkdir -p $(WASM_OUTPUT_DIR)
	cp "$$(wasm32-wasi-cabal list-bin --builddir=$(WASM_CABAL_BUILD_DIR) exe:curl-gen-wasm | tail -n 1)" $(WASM_OUTPUT_DIR)/curl-gen-wasm.wasm
	"$$(wasm32-wasi-ghc --print-libdir)/post-link.mjs" -i $(WASM_OUTPUT_DIR)/curl-gen-wasm.wasm -o $(WASM_OUTPUT_DIR)/curl-gen-wasm.mjs

.PHONY: docker
docker:
	docker build -t $(APP_DOCKER_IMAGE) .

.PHONY: docker-run
docker-run: docker
	docker run --rm -p $(APP_DOCKER_PORT):80 $(APP_DOCKER_IMAGE)

.PHONY: start
start: compile
	npm ci
	WASM_OUTPUT_DIR=$(WASM_OUTPUT_DIR) npm start

.PHONY: build
build: compile
	npm ci
	WASM_OUTPUT_DIR=$(WASM_OUTPUT_DIR) npm run build

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -rf node_modules/
