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

  describe "#save", fakefs: true do
    FakeFS.activate!
    FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
    FakeFS.deactivate!
  end
end
