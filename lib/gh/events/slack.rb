require 'yaml'
require 'erb'
require 'ostruct'
require 'json'

module GH::Events::Slack

  extend self

  def translate(payload)
    event = JSON.parse(payload, object_class: OpenStruct)
    type = GH::Events.typeof(event).to_s

    # unify
    event.ref_type = 'branch' if event.ref.match(/^refs\/heads\//)
    event.ref_type = 'tag' if event.ref.match(/^refs\/tags\//)
    event.ref = event.ref.split('/').last

    template = (templates[type] || "No template for type: #{type}.")
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
    ERB.new(template).result(ErbBinding.new(data).get_binding)
  end

end
