require 'json'

RSpec.describe GH::Events::Text do
  path = File.expand_path(File.join(%w(.. .. .. fixtures)), __FILE__)
  Dir.glob('*.json', base: path).sort.each do |file|
    name = File.basename(file, '.json')
    it "renders events of type #{name}" do
      payload = File.read(File.join(path, file))
      expect { GH::Events::Text.translate(payload, nil) }.to_not raise_error
    end
  end

  # TODO write a similar spec for `slack.yml` and validate the output
  # with a simple json schema for slack messages
end
