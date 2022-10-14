DT := $(shell date +%Y%U)
REV := $(shell git rev-parse --short HEAD)
APP := $(shell basename $(CURDIR))
ARTIFACT := bin/$(APP)$(EXT)

TAGS ?= dev
GOFLAGS ?= -race -v
GOLDFLAGS ?= -X main.buildRevision=$(DT).$(REV)

.PHONY: all amd64 arm64 armv6 armv7 build init linux release tidy

build:
	go build $(GOFLAGS) -ldflags "$(GOLDFLAGS)" -tags="$(TAGS)" -o $(ARTIFACT) cmd/*.go

release:
	GOFLAGS="-trimpath" GOLDFLAGS="$(GOLDFLAGS) -s -w" TAGS="release" $(MAKE) build
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

tidy: go.mod
	go mod tidy

updep: go.mod
	rm -f go.sum
	head -1 go.mod > /tmp/go.mod
	mv /tmp/go.mod go.mod
	go mod tidy

go.mod: init

all: amd64 arm64
