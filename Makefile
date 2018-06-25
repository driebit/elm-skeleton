default: all

.PHONY: test cover

ELM_FILES = $(shell find src -name '*.elm')

SHELL := /bin/bash
NPM_PATH := ./node_modules/.bin
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export PATH := $(NPM_PATH):$(PATH)

all: $(ELM_FILES)
	@elm-make --warn --yes src/Main.elm --output dist/main.js

analyse: deps
	@elm-analyse --elm-format-path=./node_modules/elm-format/bin/elm-format src

clean:
	@rm -Rf dist/*

cover:
	elm-coverage src --elm-test ${NPM_PATH}/elm-test --open -- --compiler ${ROOT_DIR}/node_modules/.bin/elm-make

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
	@echo "  all                    Compile all Elm files"
	@echo "  analyse                Run Elm analyse"
	@echo "  clean                  Remove 'dist' folder"
	@echo "  cover                  Run Elm coverage"
	@echo "  deps                   Install build dependencies"
	@echo "  distclean              Remove build dependencies"
	@echo "  format                 Run Elm format"
	@echo "  format-validate        Check if Elm files are formatted"
	@echo "  help                   Magic"
	@echo "  test                   Run Elm-test"
	@echo "  watch                  Run 'make all' on Elm file change"

test:
	@elm-test --compiler ${ROOT_DIR}/node_modules/.bin/elm-make

watch:
	find src -name '*.elm' | entr make all
