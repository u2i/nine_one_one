[![Build](https://travis-ci.org/u2i/nine_one_one.svg?branch=master)](https://travis-ci.org/u2i/nine_one_one)
[![Code
Climate](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/gpa.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/feed)
[![Test
Coverage](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/coverage.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/coverage)
[![Issue
Count](https://codeclimate.com/repos/58207e5ee72dfa227600001d/badges/ecd3be37c49334786095/issue_count.svg)](https://codeclimate.com/repos/58207e5ee72dfa227600001d/feed)

# NineOneOne

Common notification logic for PagerDuty/Slack notifications.

Please note that starting with version 1.0.0 this gem uses Pager Duty events api V2, which breaks backwards compatibility. 
If you don't want to change your existing API V1 calls made via this game please stick to 0.X.0 version. If you migrate 
though, please make sure all the trigger_event function calls in your app got updated and meet the new param requirements.

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

By default NineOneOne logs notifications and emergencies to STDOUT. You can override default settings with:

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

# optional custom configurations

NineOneOne.configure(:my_custom_configuration) do |config|
    config.send_pagers = false

    config.slack_enabled = true
    config.slack_webhook_url = 'https://hooks.slack.com/services/XXX/YYY/ZZZ'

    config.slack_username = 'NineOneOne'
    config.slack_channel = '#my-notifications'
end
```

## Usage

```ruby
# Send message to Slack channel or log it using logger depending on the `slack_enabled` config parameter
NineOneOne.notify('Something happened!')
# You can also send a hash message (compatible with the slack message spec: https://api.slack.com/docs/messages/builder) 
NineOneOne.notify({attachments: [{title: 'Something happened!', text: 'More info'}]})

# Send pager or log emergency using logger depending on the `send_pagers` config parameter
NineOneOne.emergency('Emergency message!', details_hash: { optional_hash: 'with details' })

# Send multiple pagers that will be grouped into one incident
NineOneOne.emergency('Emergency message!', dedup_key: 'Kinda unique key') 

# same for custom configurations
NineOneOne.use(:my_custom_configuration).notify('Something happened!')
NineOneOne.use(:my_custom_configuration).emergency('Emergency message!', details_hash: { optional_hash: 'with details' })
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

# Changelog

2.0.0 Change the interface to have default parameters. Introduce dedup_key. It's backwards incompatible again.

1.0.0 Migrate to Pager Duty Events API V2 (backwards incompatible!) and add support for slack hash message.

0.3.0 Allow to have multiple configurations for notifications 

0.2.0 Add the ability to customize slack username and channel

0.1.0 Initial version of the gem implementing Slack and Pager Duty services

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/u2i/nine_one_one.

