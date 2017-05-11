# AngularConfig
[![Build Status](https://travis-ci.org/cultuurnet/angular-config.png)](https://travis-ci.org/cultuurnet/angular-config)

This tool allows you to inject a JSON configuration into a minified Angular application. It inserts checksummed versions of the
configuration keys as values during the build process, and provides a mechanism to exchange these keys with the actual values when deploying.

This is a hackish solution, but it allows swapping configuration values without having to rebuild the application and does not require changes
to existing angular code.
If you are able to change the angular code, a solution like deferred bootstrapping is probably better suited.

I created it because, in continuous delivery fashion, I needed to be able to build an application artifact once and deploy it to a number of
different environments, with only the configuration changing. As minified Angular applications typically embed the configuration in the javascript,
this is what I came up with.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'angular_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install angular_config

## Usage

### Commandline tool

Create a hashed version of the config.json first:

    $ angular_config hash -c config.json -t md5 > hashed_config.json

Now build the angular app using the hashed configuration file.

After that, exchange the config values for the real ones:

    $ angular_config resolve -t md5 -c config_production.json -f scripts.js

If you use cache busting (embedding the md5 hash of the file source in the filename and
referencing that from the index.html), you will need the calculate a new md5 sum for the
changed file, rename and reference accordingly.

### Programmatically

Create a hashed version of the config.json first:

```
require 'angular_config'

config = AngularConfig::Config.load('config.json', 'md5')
puts config.hash_values.content.to_json
```

Now build the angular app using the hashed configuration file.

After that, exchange the config values for the real ones:

```
require 'angular_config'

config_hashed_keys = AngularConfig::Config.load('config.json', 'md5').hash_keys
file = AngularConfig::Source.load('source.js')

puts file.resolve(config_hashed_keys).content
```

If you use cache busting (embedding the md5 hash of the file source in the filename and
referencing that from the index.html), you will need the calculate a new md5 sum for the
changed file, rename and reference accordingly.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/cultuurnet/angular_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
