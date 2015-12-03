(function() {
  var system;

  system = require('system');

  module.exports = function(casperLib) {
    var verbose, casper, key, shim, _i, _len, _ref;
    casper = casperLib.create();
    verbose = !(system.env.SLACK_ADMIN_DEBUG == null || system.env.SLACK_ADMIN_DEBUG === "");
    if (verbose) {
      casper.options.verbose = true;
      casper.options.logLevel = "debug";
      casper.on('page.error', function(msg, trace) {
        return this.echo("Error: " + msg, "ERROR");
      });
    } else {
      casper.options.logLevel = "error"
    }
    casper.on('remote.message', function(message) {
      if (message.indexOf("OUTPUT:") === 0) {
        return this.echo(message.replace("OUTPUT:", ""));
      } else if (verbose) {
        return this.echo(message);
      }
    });
    _ref = ["SLACK_OKTA_USER", "SLACK_OKTA_PASSWORD", "OKTA_TEAM", "OKTA_SLACK_REDIRECT_URL", "SLACK_TEAM"];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if (!system.env[key]) {
        throw new Error("" + key + " is a required environment variable to log in.");
      }
    }
    casper.okta_team = system.env.OKTA_TEAM;
    casper.okta_url = "https://" + casper.okta_team + ".okta.com";
    casper.okta_slack_redirect_url = system.env.OKTA_SLACK_REDIRECT_URL;
    casper.slack_url = "https://" + system.env.SLACK_TEAM + ".slack.com";
    casper.okta_user = system.env.SLACK_OKTA_USER;
    casper.okta_pass = system.env.SLACK_OKTA_PASSWORD;
    casper.userAgent('Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36 I wish Slack had an administrative API');
    shim = require("./casper-bind-shim");
    shim(casper);
    casper.start(casper.okta_url);
    casper.then(function() {
      var creds;
      creds = {
        password: casper.okta_pass,
        username: casper.okta_user
      };
      return this.fill('form#credentials', creds, true);
    });
    casper.thenOpen(casper.okta_slack_redirect_url, function() {});
    return casper;
  };

}).call(this);
