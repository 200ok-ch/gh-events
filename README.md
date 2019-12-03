# Github Events

Via Webhooks Github can send a plethora of events, which can be used
to facilitate all kinds of automation.

These events are _untyped_, meaning they clearly lack a property
`type` to identify the type of event received. The rationale here
might be that one would have different webhook endpoints for each type
of events. But maintaining lots of endpoints is cumbersome. When all
the events end up in one endpoint, this library helps by adding a
property `type` to the event.

Additionally this library provides means of translating the plain
event (a deeply nested data structure serialized to JSON) into a human
readable textutal representation. Some functionality is wrapped in a
command line utilites, for your convenience.


## Installation

### To use the command line utilities

Or install it yourself as:

    $ gem install gh-events

### To use as a library in your own project

Add this line to your application's Gemfile:

```ruby
gem 'gh-events'
```

And then execute:

    $ bundle


## Usage

### CLI Util

#### Typing

You can use the command `gh-events` to list the types of events
stored in JSON files.

```
% gh-events spec/fixtures/*.json
events/001.json: commit_comment
events/002.json: create
events/003.json: delete
events/004.json: deployment
events/005.json: deployment_status
events/006.json: fork
...
```

#### Translating

The `gh-event2text` util will receive one event via stdin. Let's say
you have a github _commit_comment_ event stored in a file named
`event.json`. With you can to this:

```
% cat event.json | gh-event2text
"[Codertocat/Hello-World] Codertocat commented on commit `6113728f27ae82c7b1a177c8d03f9e96e0adf246`>: \"This is a really good change! :+1:\""
```

For translating the event into its textual representation
`gh-event2text` uses a dictionary. The dictionary can be given as an
argument to `gh-event2text`, which can either be a name of a packaged
dict (currently `plain` (default) or `slack`) or a path to a
dictionary file.

Dictionary files are YAML files with ERB for templating. The playload
is fed to the templates as nested Ruby OpenStructs. For an elaborate
example have a look at the dictionary for Slack.

If you write your own dictionary for other target systems, please
consider to contribute.

TODO: elaborate on how the lookup of types works


### Library

TODO: add an example


## References

- https://developer.github.com/v3/activity/events/types/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/200ok-ch/gh-events.
