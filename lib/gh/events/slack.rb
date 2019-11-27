require 'yaml'
require 'erb'
require 'ostruct'
require 'json'

module GH::Events::Slack

  extend self

  # this is a carefully curated list of fields in gh events that might
  # be helpful when filtering events
  ASPECTS = %i[type action state]

  def translate(payload)
    event = JSON.parse(payload, object_class: OpenStruct)
    type = GH::Events.typeof(event).to_s

    # unify
    event.ref_type = 'branch' if event.ref&.match(/^refs\/heads\//)
    event.ref_type = 'tag' if event.ref&.match(/^refs\/tags\//)
    event.ref = event.ref&.split('/')&.last

    # add type to the event
    event.type = type

    # collect the aspects
    aspects = ASPECTS.map { |a| event.send(a) }.compact

    # add the specific type (stype) to the event
    event.stype = aspects * '.'

    # lookup the template by type and all the specific types
    _result = aspects.reduce({as: [], ts: []}) do |r, aspect|
      r[:as] << aspect
      r[:ts] << templates[r[:as] * '.']
      r
    end
    template = _result[:ts].compact.last

    # if the event was set to `false` abort
    exit(1) if template === false

    # if there is no template use a default
    template ||= templates['no_template']

    render(template, event)
  end

  def templates_file
    File.expand_path(File.join(%w(.. .. .. .. res slack.yml)), __FILE__)
  end

  def templates
    @templates ||= YAML.load_file(templates_file)
  end

  class ErbBinding < OpenStruct
    def get_binding
      return binding()
    end
  end

  def render(template, data)
    ERB.new(JSON.unparse(template)).result(ErbBinding.new(data).get_binding)
  end

end
