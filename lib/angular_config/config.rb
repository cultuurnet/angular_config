module AngularConfig
  class Config
    attr_reader :content
    attr_reader :checksum_type

    def initialize(config = {}, type = 'SHA256')
      @content = config
      @checksum_type = type.upcase
    end

    def hash_keys
      hashed_keys = content.each_with_object({}) do |(key, value), result|
        digest = load_constant("Digest::#{checksum_type}").new
        result[digest.hexdigest(key)] = value
      end
      AngularConfig::Config.new(hashed_keys)
    end

    def hash_values
      hashed_values = content.each_with_object({}) do |(key, value), result|
        digest = load_constant("Digest::#{checksum_type}").new
        result[key] = digest.hexdigest(key)
      end
      AngularConfig::Config.new(hashed_values)
    end

    def self.load(path, type = nil)
      AngularConfig::Config.new(JSON.load(AngularConfig::File.new(path).content), type)
    end

    def self.save(data, path)
      AngularConfig::File.new(path).content = data.to_json
    end

    private

    def load_constant(name)
      parts = name.split('::')
      klass = Module.const_get(parts.shift)
      klass = klass.const_get(parts.shift) until parts.empty?
      klass
    end
  end
end
