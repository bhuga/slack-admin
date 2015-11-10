#!/usr/bin/env coffee
require 'coffee-errors'

kexec = require "kexec"
command_args = process.argv.slice(2)
command_args[0] = "#{command_args[0]}.coffee"

kexec "node_modules/.bin/casperjs", command_args
