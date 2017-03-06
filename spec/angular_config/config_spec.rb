require 'spec_helper'

describe AngularConfig::Config do
  describe "#content" do
    it "returns a hash containing the configuration" do
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).content).to eql({'a' => 1, 'b' => 2})
    end
  end

  describe "#hash_values" do
    it "returns an instance of the same class" do
      expect(AngularConfig::Config.new.hash_values).to be_an_instance_of(AngularConfig::Config)
    end

    it "returns an empty hash on a configuration initialized without hash elements" do
      expect(AngularConfig::Config.new.hash_values.content).to be {}
    end

    it "hashes the keys of a configuration as the respective values" do
      expect(AngularConfig::Config.new({'a' => 1}).hash_values.content).to eql({'a' => '0cc175b9c0f1b6a831c399e269772661'})
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).hash_values.content).to eql({'a' => '0cc175b9c0f1b6a831c399e269772661', 'b' => '92eb5ffee6ae2fec3ad71c777531578f'})
    end
  end

  describe "#hash_keys" do
    it "returns an instance of the same class" do
      expect(AngularConfig::Config.new.hash_keys).to be_an_instance_of(AngularConfig::Config)
    end

    it "returns an empty hash on a configuration initialized without hash elements" do
      expect(AngularConfig::Config.new.hash_keys.content).to be {}
    end

    it "replaces the keys of a configuration with the hashed versions" do
      expect(AngularConfig::Config.new({'a' => 1}).hash_keys.content).to eql({ '0cc175b9c0f1b6a831c399e269772661' => 1})
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).hash_keys.content).to eql({ '0cc175b9c0f1b6a831c399e269772661' => 1, '92eb5ffee6ae2fec3ad71c777531578f' => 2})
    end
  end

  describe "#resolve" do
    it "exchanges hashed strings with strings from configuration" do
      unresolved_string = 'This is a string with "92eb5ffee6ae2fec3ad71c777531578f" and "0cc175b9c0f1b6a831c399e269772661"'
      config = AngularConfig::Config.new({'a' => 'b', 'b' => 'a'})
      expect(config.resolve(unresolved_string)).to eql('This is a string with "a" and "b"')
    end

    it "exchanges hashed strings with hashes from configuration" do
      unresolved_string = 'This is a string with "92eb5ffee6ae2fec3ad71c777531578f" and "0cc175b9c0f1b6a831c399e269772661"'
      config = AngularConfig::Config.new({'a' => 'b', 'b' => { 'containerId' => 'foo', 'googleSiteVerification' => 'bar'}})
      expect(config.resolve(unresolved_string)).to eql('This is a string with "{"containerId":"foo","googleSiteVerification":"bar"}" and "b"')
    end
  end

  describe "#load" do
    it "returns an instance of the same class" do
      config = AngularConfig::Config.load("#{RSpec.configuration.fixtures}/empty_config.json")
      expect(config).to be_an_instance_of(AngularConfig::Config)
    end

    it "returns an empty hash when a file with an empty hash is loaded" do
      config = AngularConfig::Config.load("#{RSpec.configuration.fixtures}/empty_config.json")
      expect(config.content).to eql({})
    end

    it "returns the hash representation when a JSON formatted file is loaded" do
      config = AngularConfig::Config.load("#{RSpec.configuration.fixtures}/simple_config.json")
      expect(config.content).to eql({"a" => "1", "b" => "2"})
    end
  end

  describe "#save", fakefs: true do
    FakeFS.activate!
    FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
    FakeFS.deactivate!
  end
end
