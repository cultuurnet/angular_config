module AngularConfig
  class Source
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def md5
      Digest::MD5.hexdigest(content)
    end

    def resolve(hashed_keys)
      hashed_keys.content.each do |key, value|
        if value.is_a?(String)
          self.content.gsub!(key, value)
        else
          self.content.gsub!("\"#{key}\"", value.to_json)
        end
      end

      self
    end

    def self.load(path)
      AngularConfig::Source.new AngularConfig::File.new(path).content
    end

    def self.save(data, path)
      AngularConfig::File.new(path).content = data
    end
  end
end
