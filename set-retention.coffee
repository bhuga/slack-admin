#!/usr/bin/env coffee
# vim:ft=coffee ts=2 sw=2 et :
# -*- mode:coffee -*-

casperLib = require('casper')
okta = require "./okta_login"
casper = okta(casperLib)

room = casper.cli.get(0)
setting = casper.cli.get(1)

casper.thenOpen "#{casper.slack_url}/archives/#{room}", ->

retention_link_selector = "a#data_retention_link"

casper.then ->
  @waitForSelector retention_link_selector, ->
    @click retention_link_selector
  , ->
    @capture('retention_error.png')
  , 5000

casper.then ->
  @waitForSelector 'select[name="retention_type"]', ->
    if setting is "default"
      @evaluate ->
        $('select[name="retention_type"]').val(0).change()
    else
      @evaluate ->
        $('select[name="retention_type"]').val(1).change()
      @waitForSelector "input#retention_duration", ->
        @evaluate ((setting) ->
          $("input#retention_duration").val(setting).change()
        ), setting
  , ->
    @capture('retention_select_failure.png')

casper.then ->
  @click 'a[data-qa="generic_dialog_go"]'

casper.run ->
  phantom.onError =  ->
  phantom.exit()
