require 'yaml'
require 'erb'
require 'ostruct'
require 'json'

module GH::Events::Text

  extend self

  # this is a carefully curated list of fields in gh events that might
  # be helpful when filtering events
  ASPECTS = %i[type action state]

  def translate(payload, dict)
    dict ||= 'plain'

    templates = YAML.load_file(templates_file(dict))

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
    return nil if template === false

    # if there is no template use a default
    template ||= templates['no_template']

    res = render(template, event).gsub(/[\n\r]+/, '\n')
    validate(res, dict)
    res
  end

  # Validate the format of the response in case it's JSON
  def validate(response, channel)
    return unless channel == "slack"
    begin
      JSON.parse(response)
    rescue Exception => e
      warn "Rendered template is not valid JSON"
      warn e
      exit 1
    end
    response
  end

  def templates_file(dict)
    preset = File.expand_path(File.join(%w(.. .. .. .. res) << "#{dict}.yml"), __FILE__)
    return preset if File.exists?(preset)

    return dict if File.exists?(dict.to_s)

    warn "Could not find dict file: #{dict}"
    exit(1)
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
