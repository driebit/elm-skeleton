default: all

.PHONY: test cover

ELM_FILES = $(shell find src -name '*.elm')

SHELL := /bin/bash
NPM_PATH := ./node_modules/.bin
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export PATH := $(NPM_PATH):$(PATH)

all: $(ELM_FILES)
	@elm-make --warn --yes src/Main.elm --output dist/main.js

clean:
	@rm -Rf dist/*

cover:
	elm-cover src --elm-test ${NPM_PATH}/elm-test --open -- --compiler ${ROOT_DIR}/.bin/elm-make

deps:
	@npm install
	@elm-package install --yes

distclean: clean
	@rm -Rf elm-stuff
	@rm -Rf tests/elm-stuff
	@rm -Rf node_modules

format:
	@elm-format --yes src
	@elm-format --yes tests

format-validate:
	@elm-format --validate src
	@elm-format --validate tests

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  all"
	@echo "  clean"
	@echo "  cover"
	@echo "  deps"
	@echo "  distclean"
	@echo "  format"
	@echo "  format-validate"
	@echo "  help"
	@echo "  test"
	@echo "  watch"

test:
	@elm-test --compiler ${ROOT_DIR}/.bin/elm-make

watch:
	find src -name '*.elm' | entr make all
