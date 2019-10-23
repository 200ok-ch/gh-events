require 'json'

RSpec.describe Github::Events do
  it "has a version number" do
    expect(Github::Events::VERSION).not_to be nil
  end

  path = File.expand_path(File.join(%w(.. .. fixtures)), __FILE__)
  Dir.glob('*.json', base: path).each do |file|
    name = File.basename(file, '.json')
    it "detects events of type #{name}" do
      payload = JSON.parse(File.read(File.join(path, file)))
      result = Github::Events.typeof(payload)
      expect(result).to eq(name.to_sym)
    end
  end
end
