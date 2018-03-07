default: all

ELM_FILES = $(shell find src -name '*.elm')

SHELL := /bin/bash
NPM_PATH := ./node_modules/.bin

export PATH := $(NPM_PATH):$(PATH)

all: $(ELM_FILES)
	@elm-make --warn --yes src/Main.elm --output dist/main.js

clean:
	@rm -Rf dist/*

deps:
	@npm install
	@elm-package install --yes

distclean: clean
	@rm -Rf elm-stuff
	@rm -Rf node_modules

format:
	@elm-format --yes src

format-validate:
	@elm-format --validate src

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  all"
	@echo "  clean"
	@echo "  deps"
	@echo "  distclean"
	@echo "  format"
	@echo "  format-validate"
	@echo "  help"
	@echo "  watch"

watch:
	find src -name '*.elm' | entr make all
