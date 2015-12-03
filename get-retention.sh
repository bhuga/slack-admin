#!/bin/sh

export PATH=./slimerjs:$PATH
export PATH=./node_modules/.bin:$PATH

casperjs --engine=slimerjs get-retention.js $@ | grep -v "Vector smash protection is enabled."
