require 'spec_helper'

describe AngularConfig::Source do
  describe "#content" do
    it "returns the content of the file containing the source" do
      expect(AngularConfig::File.new("#{RSpec.configuration.fixtures}/simple_source.txt").content).to eql("This is some text.\n0cc175b9c0f1b6a831c399e269772661\n92eb5ffee6ae2fec3ad71c777531578f")
    end
  end

  describe "#save", fakefs: true do
    FakeFS.activate!
    FakeFS::FileSystem.clone(RSpec.configuration.fixtures)
    FakeFS.deactivate!
  end
  describe '#content' do
  end
end
