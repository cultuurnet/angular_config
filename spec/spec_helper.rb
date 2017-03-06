require 'angular_config'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true

  config.add_setting :fixtures, :default => File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures')
end
