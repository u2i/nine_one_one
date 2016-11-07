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

## Usage

Configure NineOneOne with:

```ruby
NineOneOne.configure do |config|
    config.send_pagers = true
    config.pager_duty_integration_key = 'key-123'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/u2i/nine_one_one.

