require 'json'

RSpec.describe GH::Events do
  it "has a version number" do
    expect(GH::Events::VERSION).not_to be nil
  end

  path = File.expand_path(File.join(%w(.. .. fixtures)), __FILE__)
  Dir.glob('*.json', base: path).sort.each do |file|
    name = File.basename(file, '.json')
    it "detects events of type #{name}" do
      payload = JSON.parse(File.read(File.join(path, file)))
      result = GH::Events.typeof(payload)
      expect(result).to eq(name.to_sym)
    end
  end
end
