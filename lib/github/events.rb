require "github/events/version"

require 'yaml'

module Github
  module Events
    class Error < StandardError; end

    extend self

    PATH = File.expand_path(File.join(%w(.. .. .. res events.yml)), __FILE__)
    HEURISTICS = YAML.load_file(PATH)

    def typeof(payload)
      keys = payload.keys
      HEURISTICS.each do |type, characteristics|
        # all keys in `present` are there
        x = ((characteristics['present'] || []) - keys)
        next unless x.empty?

        # non of the keys in `absent` are there
        y = ((characteristics['absent'] || []) & keys)
        next unless y.empty?

        # everything in `exactly` is there including the values
        z = payload.dup.merge(characteristics['exactly'] || {}) == payload
        next unless z

        next if characteristics['number_of_keys'] &&
                keys.count != characteristics['number_of_keys']

        return type.to_sym
      end
      return :unknown
    end
  end
end
