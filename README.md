[![Build](https://travis-ci.org/u2i/nine_one_one.svg?branch=master)](https://travis-ci.org/u2i/nine_one_one.svg?branch=master)
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

