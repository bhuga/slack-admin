#!/usr/bin/env coffee
# vim:ft=coffee ts=2 sw=2 et :
# -*- mode:coffee -*-

system = require 'system'

module.exports = (casperLib) ->

  logLevel = if system.env.SLACK_ADMIN_DEBUG? then "debug" else "error"
  verbose = if system.env.SLACK_ADMIN_DEBUG? then true else false

  casper = casperLib.create()

  if system.env.SLACK_ADMIN_DEBUG?
    casper.options.verbose = true
    casper.options.logLevel = "debug"
    casper.on 'page.error', (msg, trace) ->
      @echo "Error: #{msg}", "ERROR"
  else
    #Casper.prototype.echo = ->

  casper.on 'remote.message', (message) ->
    if message.indexOf("OUTPUT:") is 0
      @echo message.replace "OUTPUT:", ""
    else if system.env.SLACK_ADMIN_DEBUG?
      @echo message

  for key in ["SLACK_OKTA_USER", "SLACK_OKTA_PASSWORD", "OKTA_TEAM", "OKTA_SLACK_REDIRECT_URL", "SLACK_TEAM"]
    unless system.env[key]
      throw new Error("#{key} is a required environment variable to log in.")

  casper.okta_team = system.env.OKTA_TEAM
  casper.okta_url = "https://#{okta_team}.okta.com"
  casper.okta_slack_redirect_url = system.env.OKTA_SLACK_REDIRECT_URL
  casper.slack_url = "https://#{system.env.SLACK_TEAM}.slack.com"
  casper.okta_user = system.env.SLACK_OKTA_USER
  casper.okta_pass = system.env.SLACK_OKTA_PASSWORD

  casper.userAgent 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36 I wish Slack had an administrative API'

  shim = require "./casper-bind-shim"
  shim(casper)

  casper.start(casper.okta_url)

  casper.then ->
    creds =
      password: okta_pass,
      username: okta_user
    @fill('form#credentials', creds, true)

  casper.thenOpen casper.okta_slack_redirect_url, ->

  return casper
