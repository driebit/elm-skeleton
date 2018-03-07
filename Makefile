SHELL := /bin/bash
NPM_PATH := ./node_modules/.bin

export PATH := $(NPM_PATH):$(PATH)

default: all

all:
	elm-make --warn --yes src/Main.elm --output dist/main.js

clean:
	@rm -Rf dist/*

deps:
	@npm install
	@elm-package install --yes

distclean: clean
	@rm -Rf elm-stuff
	@rm -Rf node_modules

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  all"
	@echo "  deps"
	@echo "  distclean"
