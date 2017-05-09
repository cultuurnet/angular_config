require 'spec_helper'

describe AngularConfig::Source do
  describe "#content" do
    it "returns the content of the source" do
      expect(AngularConfig::Source.new('This is a string with "a" and "b"').content).to eql('This is a string with "a" and "b"')
    end
  end

  describe "#resolve" do
    it "exchanges hashed strings with values from configuration" do
      source = AngularConfig::Source.new('This is a string with "3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d" and "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"')
      config = AngularConfig::Config.new({'a' => 'b', 'b' => 'a'}).hash_keys
      expect(source.resolve(config).content).to eql('This is a string with "a" and "b"')
    end

    it "exchanges hashed strings with hashes without surrounding quotes from configuration" do
      source = AngularConfig::Source.new('This is a string with "3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d" and "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"')
      config = AngularConfig::Config.new({'a' => 'b', 'b' => { 'containerId' => 'foo', 'googleSiteVerification' => 'bar'}}).hash_keys
      expect(source.resolve(config).content).to eql('This is a string with {"containerId":"foo","googleSiteVerification":"bar"} and "b"')
    end
  end

  describe "#md5" do
    it "calculates an md5sum of the source" do
      source = AngularConfig::Source.new('This is a string with "92eb5ffee6ae2fec3ad71c777531578f"')
      expect(source.md5).to eql('9201303706f6d7268b947dbfcc4a1e37')
    end
  end

  describe ".load" do
    it "returns an instance of the same class" do
      source = AngularConfig::Source.load("#{RSpec.configuration.fixtures}/simple_source.txt")
      expect(source).to be_an_instance_of(AngularConfig::Source)
    end

    it "holds the file content when a file is loaded" do
      source = AngularConfig::Source.load("#{RSpec.configuration.fixtures}/simple_source.txt")
      expect(source.content).to eql('This is some text with "0cc175b9c0f1b6a831c399e269772661" and "92eb5ffee6ae2fec3ad71c777531578f".')
    end
  end

  describe ".save", fakefs: true do
    it "writes the provided content to the file" do
      FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
      AngularConfig::Source.save('Writing to a file', "#{RSpec.configuration.fixtures}/test_source.txt")
      expect(File.read("#{RSpec.configuration.fixtures}/test_source.txt")).to eql('Writing to a file')
    end
  end
end
