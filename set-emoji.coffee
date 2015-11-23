#!/usr/bin/env coffee
# vim:ft=coffee ts=2 sw=2 et :
# -*- mode:coffee -*-

casperLib = require('casper')
okta = require "./okta_login"
casper = okta(casperLib)
emoji_name = casper.cli.get(0)
image_url = casper.cli.get(1)
filename = "emoji_upload_#{emoji_name}"
spawn = require("child_process").spawn
execFile = require("child_process").execFile



casper.then ->
  console.log "downloading #{image_url} to #{filename}"
  @download image_url, filename

casper.then ->
  child = spawn("convert", ["-resize", "128x128", filename, "#{filename}_resized"])
  child.stdout.on "data", (data) ->
    console.log("spawnSTDOUT:", JSON.stringify(data))

  child.stderr.on "data", (data) ->
    console.log("spawnSTDERR:", JSON.stringify(data))

  child.on "exit", (code) ->
    console.log("spawnEXIT:", code)

casper.thenOpen "#{casper.slack_url}/customize/emoji", ->
  console.log "uploading #{filename}_resized as #{emoji_name}"
  emoji_name_selector = 'input#emojiname'
  casper.then ->
    @waitForSelector emoji_name_selector, ->
      @fill('form#addemoji', {
        'img': "#{filename}_resized"
        'name': emoji_name
      }, true)
    , ->
      @capture('emoji_enter_failure.png');

  casper.then ->
    @capture('emoji_name_entered.png')

casper.run ->
  phantom.onError =  ->
  phantom.exit()
