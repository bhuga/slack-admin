#!/bin/sh

export PATH=./slimerjs:$PATH
export PATH=./node_modules/.bin:$PATH
export PATH=./bin:$PATH
export SLIMERJS_EXECUTABLE=./bin/slimerjs-wrapper

casperjs --engine=slimerjs get-retention.js $@ | grep -v "Vector smash protection is enabled."
