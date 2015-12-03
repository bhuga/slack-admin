// Generated by CoffeeScript 1.6.3
var casper, casperLib, okta, retention_link_selector, room;

var path = require('system').args[0].split('/');
currentDir = path.slice(0, path.length - 4).join('/');

casperLib = require('casper');

okta = require(currentDir + "/okta_login");

casper = okta(casperLib);

room = casper.cli.get(0);

casper.thenOpen("" + casper.slack_url + "/archives/" + room, function() {});

retention_link_selector = "a#data_retention_link";

casper.then(function() {
  return this.waitForSelector(retention_link_selector, function() {
    return this.click(retention_link_selector);
  }, function() {
    this.capture('retention_error.png');
    return phantom.exit();
  }, 5000);
});

casper.then(function() {
  return this.waitForSelector('select[name="retention_type"]', function() {
    return this.evaluate(function() {
      var value;
      value = $('select[name="retention_type"]').val();
      if (value === "0") {
        return console.log("OUTPUT:default");
      } else {
        value = $('input#retention_duration').val();
        return console.log("OUTPUT:" + value);
      }
    });
  }, function() {
    this.capture('retention_select_failure.png');
    return phantom.exit();
  });
});

/*
casper.then(function() {
  sleep(5000);
});
*/

casper.run(function() {
  phantom.onError = function() {};
  return phantom.exit();
});
