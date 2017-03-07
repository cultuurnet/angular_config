module AngularConfig
  class Config
    attr_reader :content

    def initialize(config = {})
      @content = config
    end

    def hash_keys
      hashed_keys = content.each_with_object({}) do |(key, value), result|
        result[Digest::MD5.hexdigest(key)] = value
      end
      AngularConfig::Config.new(hashed_keys)
    end

    def hash_values
      hashed_values = content.each_with_object({}) do |(key, value), result|
        result[key] = Digest::MD5.hexdigest(key)
      end
      AngularConfig::Config.new(hashed_values)
    end

    def self.load(path)
      AngularConfig::Config.new JSON.load(AngularConfig::File.new(path).content)
    end

    def self.save(data, path)
      AngularConfig::File.new(path).content = data.to_json
    end
  end
end
