require 'spec_helper'

describe AngularConfig::Config do
  describe "#new" do
    it "sets a default checksum type of SHA256" do
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).checksum_type).to eql('SHA256')
    end

    it "allows different checksum types" do
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}, 'md5').checksum_type).to eql('MD5')
    end
  end

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
      expect(AngularConfig::Config.new({'a' => 1}).hash_values.content).to eql({'a' => 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb'})
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).hash_values.content).to eql({'a' => 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', 'b' => '3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d'})
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
      expect(AngularConfig::Config.new({'a' => 1}).hash_keys.content).to eql({ 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb' => 1})
      expect(AngularConfig::Config.new({'a' => 1, 'b' => 2}).hash_keys.content).to eql({ 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb' => 1, '3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d' => 2})
    end
  end

  describe ".load" do
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

  describe ".save", fakefs: true do
    it "writes the provided config to the file" do
      FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
      AngularConfig::Config.save({'foo' => 'bar'}, "#{RSpec.configuration.fixtures}/test_config.json")
      expect(File.read("#{RSpec.configuration.fixtures}/test_config.json")).to eql('{"foo":"bar"}')
    end
  end
end
