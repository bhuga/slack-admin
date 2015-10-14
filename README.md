# PhantomJS Slack Admin

Uses PhantomJS (via Casperjs) to perform some Slack administration commands
not supported by the API.

### Usage:

Authorization and team setting are done exclusively through environment
variables.

```shell
$ export SLACK_TEAM=myteam
$ export SLACK_OKTA_USER=myuser
$ export SLACK_OKTA_PASSWORD=super-secure
```

Then run slack-admin with a subcommand and the correct arguments:

```shell
$ slack-admin set-retention foo 30 # Set #foo's retention to 30 days
$ slack-admin set-retention foo default # Set #foo's retention to the team default
$ slack-admin get-retention foo # echos "default" or a number of days for the retention for #foo
```

#### PhantomJS bugs

If you have 1.9.8 of PhantomJS, and casper seems to install it, you'll
get a bunch of Unsafe JavaScript messages at the end of the script, and
there's nothing you can do about it. Grep them out:

```
slack-admin set-retention random 30 | grep -v "Unsafe JavaScript" | awk NF
```


### Status

Currently this only supports Okta login without 2FA.

### License

UNLICENSE'd into the public domain.
