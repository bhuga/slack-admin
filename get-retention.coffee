#!/usr/bin/env coffee
# vim:ft=coffee ts=2 sw=2 et :
# -*- mode:coffee -*-

casperLib = require('casper')
okta = require "./okta_login"
casper = okta(casperLib)

room = casper.cli.get(0)

casper.thenOpen "https://#{casper.slack_team}.slack.com/archives/#{room}", ->

retention_link_selector = "a#data_retention_link"

casper.then ->
  @waitForSelector retention_link_selector, ->
    @click retention_link_selector
  , ->
    @capture('retention_error.png')
  , 5000

casper.then ->
  @waitForSelector 'select[name="retention_type"]', ->
    @evaluate ->
      value = $('select[name="retention_type"]').val()
      console.log value
      if value is "0"
        console.log "OUTPUT:default"
      else
        value = $('input#retention_duration').val()
        console.log "OUTPUT:#{value}"
  , ->
    @capture('retention_select_failure.png')

casper.run ->
  phantom.onError =  ->
  phantom.exit()
