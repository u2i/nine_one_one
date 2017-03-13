[![Build](https://travis-ci.org/u2i/nine_one_one.svg?branch=master)](https://travis-ci.org/u2i/nine_one_one)
[![Code
Climate](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/gpa.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/feed)
[![Test
Coverage](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/coverage.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/coverage)
[![Issue
Count](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/issue_count.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/feed)

# NineOneOne

Common notification logic for PagerDuty/Slack notifications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nine_one_one'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nine_one_one

## Configuration

By default NineOneOne loggs notifications and emegencies to STDOUT. You can override default settings with:

```ruby
NineOneOne.configure do |config|
    # Use Pager Duty API for emergencies (defaults to false)
    config.send_pagers = true
    config.pager_duty_integration_key = 'pager-api-key'

    # Post notifications using Slack Webhook URL (defaults to false)
    config.slack_enabled = true
    config.slack_webhook_url = 'https://hooks.slack.com/services/XXX/YYY/ZZZ'

    # Customize Slack username. If left blank NineOneOne will use the username specified in the Slack webkhook integration
    config.slack_username = 'NineOneOne'

    # Customize Slack channel. If left blank NineOneOne will use the channel specified in the Slack webkhook integration
    config.slack_channel = '#my-notifications'

    # Use custom logger - it must implement .info(string) and .error(string) methods
    # Defaults to Logger.new(STDOUT)
    config.logger = Logger.new('incidents.log') 
end
```

## Usage

```ruby
# Send message to Slack channel or log it using logger depending on the `slack_enabled` config parameter
NineOneOne.notify('Something happened!')

# Send pager or log emergency using logger depending on the `send_pagers` config parameter
NineOneOne.emergency('INCIDENT_KEY', 'Emergency message!', { optional_hash: 'with details' })
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/u2i/nine_one_one.

