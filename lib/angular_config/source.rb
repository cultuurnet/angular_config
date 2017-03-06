module AngularConfig
  class Source
    attr_reader :path

    def initialize(source_path)
      @path = AngularConfig::File.new(source_path)
      @content = ::File.read(path).chomp
    end

    def content
      @content
    end

    def content=(data)
      ::File.open(path, "w") do |file|
        file.write(data)
      end
    end

    def md5
      Digest::MD5.hexdigest(content)
    end

    def resolve(hashed_keys)
      hashed_keys.content.each do |key, value|
        if value.is_a?(String)
          self.content.gsub!(key, value)
        else
          self.content.gsub!("#{key}", value.to_json)
        end
      end

      self
    end

    def self.load(path)
      AngularConfig::Source.new AngularConfig::File.new(path)
    end

    def self.save(data, path)
      AngularConfig::File.new(path).save(data)
    end

  end
end
