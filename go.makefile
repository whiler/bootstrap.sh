DT := $(shell date +%Y-%m-%dT%TZ%z)
REV := $(shell git rev-parse --short HEAD)
APP := $(shell basename $(CURDIR))
ARTIFACT := bin/$(APP)$(EXT)

GOFLAGS ?= -race -v
GOLDFLAGS ?= -X main.buildRevision=$(REV)@$(DT)

.PHONY: all amd64 arm64 build init linux release

build:
	go build $(GOFLAGS) -ldflags "$(GOLDFLAGS)" -o $(ARTIFACT) cmd/*.go

release:
	GOFLAGS="-trimpath" GOLDFLAGS="$(GOLDFLAGS) -s -w" $(MAKE) build
	upx $(ARTIFACT)

linux:
	GOOS=linux $(MAKE) release

amd64:
	EXT=.x86-64 GOARCH=amd64 $(MAKE) linux

arm64:
	EXT=.aarch64 GOARCH=arm64 $(MAKE) linux

armv7:
	EXT=.armv7l GOARCH=arm GOARM=7 $(MAKE) linux

armv6:
	EXT=.armv6 GOARCH=arm GOARM=6 $(MAKE) linux

init:
	go mod init $(shell hostname -f)/$(USER)/$(APP)

all: amd64 arm64
