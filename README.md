# Github Events

Via Webhooks Github can send a plethora of events, which can be used to facilitate all kinds of automation.

These events are _untyped_, meaning they clearly lack a property `type` to identify the type of event received. (The rationale here might be that one would have differen webhook endpoints for each type of events. But maintaining lots of endpoints is cumbersome. When all the events end up in one endpoint, this library helps by adding a property `type` to the event.)

Additionally this library provides means of translating the plain event into a human readable textutal representation. This functionality is wrapped in a command line utility, for your convenience.

## Example Usage

Let's say you have a github _commit_comment_ event stored in a file `event.json`

```
% cat event.json | gh-event2text
...
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gh-events'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gh-events

## References

- https://developer.github.com/v3/activity/events/types/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/200ok-ch/gh-events.
