require 'spec_helper'

describe AngularConfig::File do
  describe "#path" do
    it "returns the path of the file containing the configuration" do
      expect(AngularConfig::File.new("#{RSpec.configuration.fixtures}/empty_config.json").path).to eql("#{RSpec.configuration.fixtures}/empty_config.json")
    end
  end

  describe "#content" do
    it "returns the content of the file containing the configuration" do
      expect(AngularConfig::File.new("#{RSpec.configuration.fixtures}/empty_config.json").content).to eql('{}')
      expect(AngularConfig::File.new("#{RSpec.configuration.fixtures}/simple_config.json").content).to eql('{"a": "1", "b": "2"}')
    end
  end

  describe "#content=", fakefs: true do
    it "updates the content of the file" do
      FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
      config = AngularConfig::File.new("#{RSpec.configuration.fixtures}/empty_config.json")
      config.content = '{"foo": "bar"}'
      expect(File.read("#{RSpec.configuration.fixtures}/empty_config.json")).to eql('{"foo": "bar"}')
    end
  end
end
