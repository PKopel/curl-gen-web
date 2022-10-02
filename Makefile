AHC_DOCKER_IMAGE := terrorjack/asterius
APP_DOCKER_IMAGE ?= pkopel/curl-gen-server
APP_DOCKER_PORT ?= 8080
DOCKER_WS := /workspace
BUILD_DIR := _build
CABAL_DIR := $(DOCKER_WS)/$(BUILD_DIR)/.cabal
CABAL_BUILD_DIR := $(BUILD_DIR)/cabal
AHC_CABAL_BUILD_DIR := $(BUILD_DIR)/ahc-cabal
AHC_CABAL_INSTALL_DIR := $(BUILD_DIR)
ASTERIUS_OUTPUT_DIR = $(BUILD_DIR)/asterius


.PHONY: compile
compile:
	docker run --rm -v $(CURDIR):$(DOCKER_WS):z -w $(DOCKER_WS) $(AHC_DOCKER_IMAGE) \
		ahc-cabal install \
			--builddir $(AHC_CABAL_BUILD_DIR) --installdir $(AHC_CABAL_INSTALL_DIR) \
			--install-method copy --overwrite-policy always

.PHONY: link
link: compile
	mkdir -p $(ASTERIUS_OUTPUT_DIR)
	docker run --rm -v $(CURDIR):$(DOCKER_WS):z -w $(DOCKER_WS) $(AHC_DOCKER_IMAGE) \
		ahc-dist \
			--input-exe $(AHC_CABAL_INSTALL_DIR)/curl-gen-wasm \
			--output-directory $(ASTERIUS_OUTPUT_DIR) \
			--input-mjs static/index.mjs --no-main --browser \
			--gc-threshold 640

.PHONY: docker
docker:
	docker build -t $(APP_DOCKER_IMAGE) .

.PHONY: docker-run
docker-run: docker
	docker run --rm -p $(APP_DOCKER_PORT):80 $(APP_DOCKER_IMAGE)

.PHONY: start
start: link
	npm install
	ASTERIUS_OUTPUT_DIR=$(ASTERIUS_OUTPUT_DIR) npm start

.PHONY: build
build: link
	npm install
	ASTERIUS_OUTPUT_DIR=$(ASTERIUS_OUTPUT_DIR) npm run build

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -rf node_modules/
