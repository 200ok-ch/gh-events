require "gh/events/version"

require 'yaml'
require 'ostruct'

module GH
  module Events
    class Error < StandardError; end

    extend self

    PATH = File.expand_path(File.join(%w(.. .. .. res events.yml)), __FILE__)
    HEURISTICS = YAML.load_file(PATH)

    def typeof(payload)
      payload = payload.marshal_dump if payload.is_a?(OpenStruct)
      keys = payload.keys.map(&:to_s)
      HEURISTICS.each do |type, characteristics|
        # puts ("-" * 30) + " #{type}"

        # all keys in `present` are there
        x = ((characteristics['present'] || []) - keys)
        next unless x.empty?

        # non of the keys in `absent` are there
        y = ((characteristics['absent'] || []) & keys)
        next unless y.empty?

        # everything in `exactly` is there including the values
        z = payload.dup.merge(characteristics['exactly'] || {}) == payload
        next unless z

        n = characteristics['number_of_keys'] &&
            keys.count != characteristics['number_of_keys']
        next if n

        return type.to_sym
      end
      return :unknown
    end
  end
end
