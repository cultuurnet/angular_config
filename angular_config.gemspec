# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'angular_config/version'

Gem::Specification.new do |spec|
  spec.name          = "angular_config"
  spec.version       = AngularConfig::VERSION
  spec.authors       = ["Kristof Willaert"]
  spec.email         = ["kristof.willaert@cultuurnet.be"]

  spec.summary       = %q{Manage configuration in minified/uglified Angular apps}
  spec.description   = %q{Manage configuration in minified/uglified Angular apps by swapping out cryptographically hashed values}
  spec.homepage      = "https://github.com/cultuurnet/angular_config"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "fakefs", "~> 0.10"
end
